import pandas as pd
import os
import numpy as np
from typing import Tuple, List
import torch
from torch.utils.data import DataLoader, TensorDataset
from caching_utils import append_standard_scaler_params

def min_max_scaler(column_data : pd.DataFrame) -> List[float]:
    return [round((data - min(column_data)) / (max(column_data) - min(column_data)), 2) for data in column_data]

def standard_scaler(column_data : pd.DataFrame, params : dict = None) -> List[float]:
    if params is None:
        mean : pd.DataFrame = column_data.mean()
        std : pd.DataFrame = column_data.std()
        append_standard_scaler_params(path=os.path.join(os.path.dirname(__file__), "cache_standard_scaler_params.txt"), \
                                    mean=mean, std=std)
    else: 
        mean, std = params["mean"], params["std"]
    return (column_data - mean) / std

class Preprocessing():
    def __init__(self, file_name : str):
        self.file_name : str = file_name
        parent_directory : str = os.path.dirname(__file__)
        self.path: str = os.path.join(parent_directory, self.file_name)
        self.data : pd.core.frame.DataFrame = pd.read_csv(self.path)
        os.chdir(parent_directory)
        
    def simplify_column_names(self, column_names : list = None) -> None:
        if column_names is None: 
            modification : dict = {column:f"Question {i}" for (i, column) in enumerate(self.data.columns)}        
        else: 
            if len(column_names) == len(self.data.columns):
                modification : dict = {column:new_column for (column, new_column) in zip(self.data.columns)}  
            else:
                raise ValueError(f"Number of input columns ({len(column_names)}) does not match number of dataset columns ({len(self.data.columns)}).")
        for key, value in modification.items(): 
            try: 
                self.data.rename(columns={key:value}, inplace=True)        
            except KeyError as e: 
                raise KeyError(f"Column name '{key}' not found in dataset. Original error message: {str(e)}")
                 
    def convert_questions_to_numerical(self) -> None:
        self.data["Question 0"] : pd.DataFrame = pd.DataFrame([0 if row_answer_q0 == "light" else (1 if row_answer_q0 == "medium" else 2) \
                                   for row_answer_q0 in self.data["Question 0"]]).astype("float64")
        self.data["Question 1"] : pd.DataFrame = pd.DataFrame([0 if row_answer_q1 == "no" else 1 \
                                                               for row_answer_q1 in self.data["Question 1"]]).astype("float64")
        self.data["Question 2"] : pd.DataFrame = pd.DataFrame([0 if row_answer_q2 == "sugar" else (1 if row_answer_q2 == "stevia" else 2) \
                                   for row_answer_q2 in self.data["Question 2"]]).astype("float64")
        question_3_options = {row_answer_q3:index for (index, row_answer_q3) in enumerate(list(dict.fromkeys(self.data["Question 3"])))}
        self.data["Question 3"] : pd.DataFrame = pd.DataFrame([question_3_options[row_answer_q3] \
                                                               for row_answer_q3 in self.data["Question 3"]]).astype("float64")
        self.data["Question 4"] : pd.DataFrame = pd.DataFrame([0 if row_answer_q4 == "short and strong" else 1 \
                                                               for row_answer_q4 in self.data["Question 4"]]).astype("float64")
        self.data["Question 5"] : pd.DataFrame = pd.DataFrame([0 if row_answer_q5 == "sambuka" else (1 if row_answer_q5 == "whiskey" else 2) \
                                                               for row_answer_q5 in self.data["Question 5"]]).astype("float64")
        self.data["Question 6"] : pd.DataFrame = pd.DataFrame([0 if row_answer_q6 == "yes" else 1 \
                                                               for row_answer_q6 in self.data["Question 6"]]).astype("float64")
        question_7_option_labels : List[str] = {row_answer_q7:index for (index, row_answer_q7) in enumerate(list(dict.fromkeys(self.data["Question 7"])))}
        self.data["Question 7"] : pd.DataFrame = pd.DataFrame([question_7_option_labels["latte macchiato"] if row_answer_q7 == "latte machiatto" \
                                                               else (question_7_option_labels["corretto"] if row_answer_q7 == "coretto" \
                                                                     else question_7_option_labels[row_answer_q7]) \
                                                                        for row_answer_q7 in self.data["Question 7"]])
        question_7_option_labels : List[str] = {row_answer_q7:index for (index, row_answer_q7) in enumerate(list(dict.fromkeys(self.data["Question 7"])))}
        self.data["Question 7"] : pd.DataFrame = pd.DataFrame([question_7_option_labels[row_answer_q7] for row_answer_q7 in self.data["Question 7"]])

    def drop_feature_number(self, position : int):
        self.data.drop([f"Question {position}"], axis=1, inplace=True)

    def normalize_data(self) -> pd.DataFrame: 
        for (i, column) in enumerate(self.data.columns):
            if i >= len(list(self.data.columns)) - 1: # don't normalize the labels
                continue
            self.data[column] = pd.DataFrame(min_max_scaler(self.data[column])).astype("float64")
        return self.data
    
    def standardize_data(self) -> pd.DataFrame:
        for (i, column) in enumerate(self.data.columns):
            if i >= len(list(self.data.columns)) - 1: # don't normalize the labels
                continue
            self.data[column] = pd.DataFrame(standard_scaler(self.data[column])).astype("float64")
        return self.data

    def get_data(self) -> Tuple[np.ndarray, np.ndarray]:
        X : np.ndarray = self.get_features()
        y : np.ndarray = self.get_labels()
        return (X, y)

    def get_features(self) -> np.ndarray:
        X : np.ndarray = np.zeros(shape=(self.data.shape[0], self.data.shape[1]-1))
        feature_names : list = list(self.data.columns)
        feature_names.pop(-1) # remove the label column
        for i in range(X.shape[0]):
            for j, column_names in enumerate(feature_names):
                X[i][j] = self.data[column_names][i]
        return X
    
    def get_labels(self) -> np.ndarray:
        y : np.ndarray = np.zeros(shape=self.data.shape[0])
        label_name : str = list(self.data.columns)[-1]
        y = np.array(self.data[label_name])
        return y
    
    def arrays_to_tensor_floats32(self, X_train : np.ndarray, X_test : np.ndarray, y_train : np.ndarray, y_test : np.ndarray) \
        -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor]:
        return torch.tensor(X_train, requires_grad=True, dtype=torch.float32), \
            torch.tensor(X_test, requires_grad=True, dtype=torch.float32), \
            torch.tensor(y_train, requires_grad=True, dtype=torch.float32), \
            torch.tensor(y_test, requires_grad=True, dtype=torch.float32)
    
    def load_array_batches(self, data_arrays : Tuple[torch.Tensor, torch.Tensor], batch_size : int, is_train : bool = True) -> DataLoader: 
        dataset : TensorDataset = TensorDataset(*data_arrays)
        return DataLoader(dataset, batch_size=batch_size, shuffle=is_train)