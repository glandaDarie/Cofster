from typing import List, Dict
import os
import json
from roboflow import Roboflow, Project
import ultralytics
from ultralytics import YOLO
from IPython.display import display
from IPython import display
display.clear_output()
ultralytics.checks()

def find_single_matching_path(build_path : str, target_path : str = "credentials") -> str:
    """
    Find a single path matching the target path within the specified directory.

    Args:
        build_path (str): The directory path to search.
        target_path (str, optional): The target path to match. Defaults to "credentials".

    Returns:
        str: The matched path.
    """
    paths : List[str] = os.listdir(build_path)
    filtered_paths : List[str] = [path for path in paths if path == target_path]
    if len(filtered_paths) > 1:
      return "Can't have more than one path available"
    elif len(filtered_paths) == 1:
      return os.path.join(build_path, filtered_paths[0])
    else:
      return "Respective path does not exist"

def read_credentials(path : str) -> Dict[str, str]:
    """
    Read credentials from a JSON file.

    Args:
        path (str): The path to the JSON file.

    Returns:
        Dict[str, str]: The credentials as a dictionary.
    """
    with open(path, "r") as input_file:
        data : Dict[str, str] = json.load(input_file)
    return data

def freeze_layers(trainer, num_freeze : int = 5) -> None:
    """
    Freeze layers in the YOLO model.

    Args:
        trainer: The YOLO trainer object.
        num_freeze (int, optional): The number of layers to freeze. Defaults to 5.
    """
    model : YOLO = trainer.model
    print(f"Freezing {num_freeze} layers")
    freeze : list[str] = [f'model.{x}.' for x in range(num_freeze)]
    for k, v in model.named_parameters():
        v.requires_grad = True
        if any(x in k for x in freeze):
            print(f"freezing {k}")
            v.requires_grad = False
    print(f"{num_freeze} layers are freezed.")

def display_YOLO_params(model : YOLO) -> None:
    """
    Print the names and shapes of parameters in the YOLO model.

    Args:
        model (YOLO): YOLO model instance.

    Returns:
        None
    """
    for k, v in model.named_parameters():
        print(f"{k = }, {v.shape = }")

def main() -> None:
    """
    Main function to train the YOLO model for custom cup detection.

    Returns:
        None
    """
    build_path : str = find_single_matching_path(build_path=os.path.join(os.getcwd()))
    assert " " not in build_path, build_path.split("/")[-1]
    build_path : str = find_single_matching_path(build_path, "roboflow_key.json")
    assert " " not in build_path, build_path.split("/")[-1]
    yolo_cred : Dict[str, str] = read_credentials(build_path)

    rf : Roboflow = Roboflow(api_key=yolo_cred["api_key"])
    project : Project = rf.workspace("universitatea-politehnica-timioara").project("custom-cup-detection")
    project.version(3).download("yolov8")

    model : YOLO = YOLO("yolov8n.pt")
    model.add_callback("on_train_start", freeze_layers)
    model.train(
        data=os.path.join(os.getcwd(), "Custom-Cup-Detection-3", "data.yaml"),
        epochs=400,
        batch=16,
        workers=16,
        pretrained=True,
        cache=True,
        label_smoothing=0.05,
        optimizer="AdamW",
        dropout=0.4,
        weight_decay=0.01,
    )

if __name__ == "__main__":
    main()
