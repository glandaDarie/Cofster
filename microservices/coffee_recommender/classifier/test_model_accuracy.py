from typing import List, Dict
import os
from inference import predict
from classes import labels

def test_model_accuracy() -> None: 
    path : str = os.path.join(os.path.dirname(__file__), "coffee_dataset.txt") 
    expected_accuracy : int = 0.8
    nr_samples : int = 700

    with open(path, "r") as input_file:
        lines : List[str] = input_file.readlines()
        lines.pop(0)
        lines : List[str] = lines[:-2]
        correct : int = 0
        for line in lines[:nr_samples]:
            answers : str = line.split(",")
            ground_truth : str = answers[-1].rsplit("\n")[0]
            answers.pop(-1)
            sample_dict : Dict[str, str] = {}
            for j, answer in enumerate(answers):
                sample_dict[f"Question {j}"] = answer
            prediction : int = predict(responses=sample_dict, k=1)
            predicted : str = labels[prediction].lower()
            print(f"predicted_label : {predicted}, ground_truth_label : {ground_truth}")
            if ground_truth == predicted:
                correct += 1    
        actual_accuracy : float = ((correct / nr_samples)*100)

        assert actual_accuracy > expected_accuracy, f"Error: expected accuracy: {expected_accuracy}, actual accuracy: {actual_accuracy}"