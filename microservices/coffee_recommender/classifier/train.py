from preprocessing import Preprocessing
from torch import nn
from typing import Tuple, cast
import torch
import numpy as np
from sklearn import model_selection
import os
from model import DrinkClassifier
from collections import OrderedDict
from torch.utils.data import DataLoader
from hyperparameters import params_dict
from caching_utils import put_content_in_cache, empty_cache, load_content_from_cache

process : Preprocessing = Preprocessing("coffee_dataset.txt")
cache_path : str = os.path.join(os.path.dirname(__file__), "cache_preprocessing.pickle") 

def preprocess() -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor]: 
    if not empty_cache(cache_path):
      X_train, X_test, y_train, y_test = load_content_from_cache(cache_path)
      train_dataloader : DataLoader = process.load_array_batches(data_arrays=(X_train, y_train), batch_size=params_dict["BATCH_SIZE"])
      test_dataloader : DataLoader = process.load_array_batches(data_arrays=(X_test, y_test), batch_size=params_dict["BATCH_SIZE"])
    else:  
      process.simplify_column_names()
      process.convert_questions_to_numerical()
      process.standardize_data()
      data : Tuple[np.ndarray, np.ndarray] = process.get_data()
      X, y = cast(Tuple[np.ndarray, np.ndarray], data)
      data : Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray] = \
          model_selection.train_test_split(X, y, test_size=0.2, random_state=42)
      X_train, X_test, y_train, y_test = cast(Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray], data)
      data : Tuple[torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor] = \
          process.arrays_to_tensor_floats32(X_train, X_test, y_train, y_test)
      X_train, X_test, y_train, y_test = cast(Tuple[torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor], data)
      put_content_in_cache(cache_path, (X_train, X_test, y_train, y_test))
      train_dataloader : DataLoader = process.load_array_batches(data_arrays=(X_train, y_train), batch_size=params_dict["BATCH_SIZE"])
      test_dataloader : DataLoader = process.load_array_batches(data_arrays=(X_test, y_test), batch_size=params_dict["BATCH_SIZE"])
    return (train_dataloader, test_dataloader)

def accuracy_fn(y_true : torch.Tensor, y_pred : torch.Tensor) -> float:
    correct = 0
    for _true, _pred in zip(y_true, y_pred):
        if _true == _pred:
            correct += 1
    return (correct / len(y_pred)) * 100

def save_params(path : str, model : DrinkClassifier) -> str:
    try:
        torch.save(model.state_dict(), path)
    except Exception as e:
        return f"Exception {e} appeard when trying to save the model."
    return "Model saved successfully"

def load_model(path : str) -> OrderedDict:
    try:
        loaded_state_dict : OrderedDict = torch.load(path, map_location=torch.device("cpu"))
    except Exception as e:
        print(f"Exception {e} appeared when trying to load the model.")
        return None
    return loaded_state_dict

def train_model() -> None:
    torch.manual_seed(42)
    loaded = False
    if not loaded:
        loaders : Tuple[DataLoader, DataLoader] = preprocess()
        train_dataloader, test_dataloader = cast(Tuple[DataLoader, DataLoader], loaders)
    print("------Model------")
    device : str = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"Model training is set on {device}")
    nr_features : Tuple[int, int, int, int, int, int, int] = len(process.data.columns)-1, 128, 256, 128, 256, 128, 10
    in_features, hid_features_hid_in, hid_features_hid_hid, hid_features_hid_hid_second, \
        hid_features_hid_hid_third, hid_features_hid_hid_fourth, out_features_hid_out = \
        cast(Tuple[int, int, int, int, int, int, int], nr_features)
    model : DrinkClassifier = DrinkClassifier(
        in_features=in_features, hid_features_hid_in=hid_features_hid_in, 
        hid_features_hid_hid=hid_features_hid_hid, 
        hid_features_hid_hid_second=hid_features_hid_hid_second,
        hid_features_hid_hid_third=hid_features_hid_hid_third,
        hid_features_hid_hid_fourth=hid_features_hid_hid_fourth, 
        out_features_hid_out=out_features_hid_out
    ).to(device)
    loss_fn : torch.nn.modules.loss.CrossEntropyLoss = nn.CrossEntropyLoss()
    optimizer : torch.optim.SGD = torch.optim.SGD(params=model.parameters(), lr=params_dict["LEARNING_RATE"], 
                                                  weight_decay=params_dict["WEIGHT_DECAY"])
    for epoch in range(params_dict["EPOCHS"]):
        model.train()
        train_loss : int = 0
        train_acc : int = 0
        for _, (X_train, y_train) in enumerate(train_dataloader):
            X_train, y_train = X_train.to(device), y_train.to(device)
            y_logits = model(X_train)
            y_probs = torch.softmax(y_logits, dim=1)
            y_pred = y_probs.argmax(dim=1).to(torch.float32)
            loss = loss_fn(y_logits, y_train.to(torch.long))
            train_loss += loss
            acc = accuracy_fn(y_true=y_train, y_pred=y_pred)
            train_acc += acc
            optimizer.zero_grad()
            nn.utils.clip_grad_norm_(model.parameters(), params_dict["GRADIENT_CLIPPING_VALUE"]) 
            loss.backward()
            optimizer.step()
        train_loss /= len(train_dataloader)
        train_acc /= len(train_dataloader)
        model.eval()
        test_loss : int = 0
        test_acc : int = 0
        with torch.inference_mode():
            for X_test, y_test in test_dataloader:
                X_test, y_test = X_test.to(device), y_test.to(device)
                test_logits = model(X_test)
                y_test_probs = torch.softmax(test_logits, dim=1)
                test_pred = y_test_probs.argmax(dim=1).to(torch.float32)
                test_loss += loss_fn(test_logits, y_test.type(torch.long)) 
                test_acc += accuracy_fn(y_true=y_test, y_pred=test_pred)
            test_loss /= len(test_dataloader)
            test_acc /= len(test_dataloader)
        if (epoch+1) % 100 == 0:
            print(f"Epoch: {epoch} | train loss: {train_loss:.5f}, train acc: {train_acc:.2f}% | test Loss: {test_loss:.5f}, test Acc: {test_acc:.2f}%")
    path : str = os.path.join(os.path.dirname(__file__), "model_parameters.pickle") 
    save_params(path, model)