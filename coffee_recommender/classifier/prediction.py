# from preprocessing import standard_scaler
# from typing import Tuple, List, Dict, cast
# import torch
# import numpy as np
# import os
# from model import DrinkClassifier
# from collections import OrderedDict
# from caching_utils import read_standard_scalar_params
# from train import load_model
# import decimal

# def predict(responses = None) -> str|int:
#     if responses is None:
#         return "No response on the formular."
#     path_state_dict : str = os.path.join(os.path.dirname(__file__), "model_parameters.pickle")
#     path_params_standard_scaler : str = os.path.join(os.path.dirname(__file__), "cache_standard_scaler_params.txt")
#     if path_state_dict is None:
#         return "Model failed to load."
#     options_3 : List[str] = ["20%", "0%", "50%", "70% or above", "below 30%", "below 50%", "below 20%"]
#     responses["Question 0"] : float = float(0) if responses["Question 0"] == "light" else \
#     (float(1) if responses["Question 0"] == "medium" else float(2))
#     responses["Question 1"] : float = float(0) if responses["Question 1"] == "no" else float(1)
#     responses["Question 2"] : float = float(0) if responses["Question 2"] == "sugar" \
#         else (float(1) if responses["Question 2"] == "stevia" else float(2))
#     responses["Question 3"] : float = [float(index) for index, option in enumerate(options_3) if \
#                                             option == responses["Question 3"]][-1]
#     responses["Question 4"] : float = float(0) if responses["Question 4"] == "short and strong" else float(1)
#     responses["Question 5"] : float = float(0) if responses["Question 5"] == "sambuka" else \
#         (float(1) if responses["Question 5"] == "whiskey" else float(2))
#     responses["Question 6"] : float = float(0) if responses["Question 6"] == "yes" else float(1)

#     out_responses : Dict[str, str] = {}
#     standard_scalar_params : List[str] = read_standard_scalar_params(path_params_standard_scaler)
#     for i, ((_, value), line_params) in enumerate(zip(responses.items(), standard_scalar_params)):
#         mean_str, std_str = line_params.split()
#         mean, std = np.float64(decimal.Decimal(mean_str)), np.float64(decimal.Decimal(std_str))
#         params : Dict[str, str] = {"mean" : mean, "std" : std}
#         out_responses[f"Question {i}"] = standard_scaler(value, params)

#     X_test : torch.tensor = torch.tensor(list(out_responses.values()), requires_grad=False, dtype=torch.float32)
#     X_test : torch.tensor = X_test.unsqueeze(0)

#     nr_features : Tuple[int, int, int, int, int, int, int] = len(responses), 128, 256, 128, 256, 128, 10
#     in_features, hid_features_hid_in, hid_features_hid_hid, hid_features_hid_hid_second, \
#         hid_features_hid_hid_third, hid_features_hid_hid_fourth, out_features_hid_out = \
#         cast(Tuple[int, int, int, int, int, int, int], nr_features)
    
#     loaded_state_dict : OrderedDict = load_model(path_state_dict)
#     model : DrinkClassifier = DrinkClassifier(in_features=in_features, hid_features_hid_in=hid_features_hid_in, 
#                                                         hid_features_hid_hid=hid_features_hid_hid, 
#                                                         hid_features_hid_hid_second=hid_features_hid_hid_second,
#                                                         hid_features_hid_hid_third=hid_features_hid_hid_third,
#                                                         hid_features_hid_hid_fourth=hid_features_hid_hid_fourth, 
#                                                         out_features_hid_out=out_features_hid_out)
#     model.load_state_dict(loaded_state_dict)
    
#     model.eval()
#     with torch.inference_mode():
#         test_logits = model(X_test)
#         y_test_probs = torch.softmax(test_logits, dim=1)
#         prediction = y_test_probs.argmax(dim=1).to(torch.float32)
#     return int(prediction.item()) 


from preprocessing import standard_scaler
from typing import Tuple, List, Dict, cast
import torch
import numpy as np
import os
from model import DrinkClassifier
from collections import OrderedDict
from caching_utils import read_standard_scalar_params
from train import load_model
import decimal

def predict(responses = None) -> str|int:
    if responses is None:
        return "No response on the formular."
    path_state_dict : str = os.path.join(os.path.dirname(__file__), "model_parameters.pickle")
    path_params_standard_scaler : str = os.path.join(os.path.dirname(__file__), "cache_standard_scaler_params.txt")
    if path_state_dict is None:
        return "Model failed to load."
    options_3 : List[str] = ["20%", "0%", "50%", "70% or above", "below 30%", "below 50%", "below 20%"]
    responses["Question 0"] : float = float(0) if responses["Question 0"] == "light" else \
    (float(1) if responses["Question 0"] == "medium" else float(2))
    responses["Question 1"] : float = float(0) if responses["Question 1"] == "no" else float(1)
    responses["Question 2"] : float = float(0) if responses["Question 2"] == "sugar" \
        else (float(1) if responses["Question 2"] == "stevia" else float(2))
    responses["Question 3"] : float = [float(index) for index, option in enumerate(options_3) if \
                                            option == responses["Question 3"]][-1]
    responses["Question 4"] : float = float(0) if responses["Question 4"] == "short and strong" else float(1)
    responses["Question 5"] : float = float(0) if responses["Question 5"] == "sambuka" else \
        (float(1) if responses["Question 5"] == "whiskey" else float(2))
    responses["Question 6"] : float = float(0) if responses["Question 6"] == "yes" else float(1)

    out_responses : Dict[str, str] = {}
    standard_scalar_params : List[str] = read_standard_scalar_params(path_params_standard_scaler)
    for i, ((_, value), line_params) in enumerate(zip(responses.items(), standard_scalar_params)):
        mean_str, std_str = line_params.split()
        mean, std = np.float64(decimal.Decimal(mean_str)), np.float64(decimal.Decimal(std_str))
        params : Dict[str, str] = {"mean" : mean, "std" : std}
        out_responses[f"Question {i}"] = standard_scaler(value, params)

    X_test : torch.Tensor = torch.tensor(list(out_responses.values()), requires_grad=False, dtype=torch.float32)
    X_test : torch.Tensor = X_test.unsqueeze(0)

    nr_features : Tuple[int, int, int, int, int, int, int] = len(responses), 128, 256, 128, 256, 128, 10
    in_features, hid_features_hid_in, hid_features_hid_hid, hid_features_hid_hid_second, \
        hid_features_hid_hid_third, hid_features_hid_hid_fourth, out_features_hid_out = \
        cast(Tuple[int, int, int, int, int, int, int], nr_features)
    
    loaded_state_dict : OrderedDict = load_model(path_state_dict)
    model : DrinkClassifier = DrinkClassifier(in_features=in_features, hid_features_hid_in=hid_features_hid_in, 
                                                        hid_features_hid_hid=hid_features_hid_hid, 
                                                        hid_features_hid_hid_second=hid_features_hid_hid_second,
                                                        hid_features_hid_hid_third=hid_features_hid_hid_third,
                                                        hid_features_hid_hid_fourth=hid_features_hid_hid_fourth, 
                                                        out_features_hid_out=out_features_hid_out)
    model.load_state_dict(loaded_state_dict)
    
    model.eval()
    with torch.inference_mode():
        test_logits : torch.Tensor = model(X_test)
        y_test_probs : torch.Tensor = torch.softmax(test_logits, dim=1)
        # prediction : torch.Tensor = y_test_probs.argmax(dim=1).to(torch.float32)
        _, top_indices = torch.topk(y_test_probs, k=5, dim=1)
    # return int(prediction.item()) 
    return top_indices.tolist()


