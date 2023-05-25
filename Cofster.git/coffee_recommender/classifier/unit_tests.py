from typing import List, Dict
import os
from prediction import predict
from classes import labels

def unit_test_accuracy(path : str, nr_samples : int = 100) -> List[Dict[str, str]]: 
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
        return ((correct / nr_samples)*100) 

if __name__ == "__main__":
    path : str = os.path.join(os.path.dirname(__file__), "coffee_dataset.txt") 
    print(f"Accruacy = {unit_test_accuracy(path=path, nr_samples=700)}")