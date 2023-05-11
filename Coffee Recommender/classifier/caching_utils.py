from typing import Tuple, List
import torch
import os
import numpy as np
import pandas as pd

def put_content_in_cache(path : str, data : Tuple[torch.tensor, torch.tensor, \
torch.tensor, torch.tensor]) -> None:
  X_train, X_test, y_train, y_test = data
  with open(path, "wb") as output_file:
    np.savez(output_file, X_train=X_train.detach(), X_test=X_test.detach(), y_train=y_train.detach(), y_test=y_test.detach())
 
def empty_cache(path : str) -> bool:
  return os.path.getsize(path) == 0

def load_content_from_cache(path: str) -> Tuple[torch.tensor, torch.tensor, \
torch.tensor, torch.tensor]:
  with open(path, "rb") as input_file:
      content = np.load(input_file, allow_pickle=True)
      X_train : torch.Tensor = torch.from_numpy(content["X_train"])
      X_test : torch.Tensor = torch.from_numpy(content["X_test"])
      y_train : torch.Tensor = torch.from_numpy(content["y_train"])
      y_test : torch.Tensor = torch.from_numpy(content["y_test"])
  return X_train, X_test, y_train, y_test 

def append_standard_scaler_params(path : str, mean : pd.DataFrame, std : pd.DataFrame) -> None:
  with open(path, "a") as output_file: 
    output_file.write(f"{mean} {std}\n")

def read_standard_scalar_params(path : str) -> List[str]: 
  with open(path, "r") as input_file:
    lines : List[str] = []
    while True:
      line : str = input_file.readline()
      if not line:
        break
      lines.append(line.rstrip())
    return lines