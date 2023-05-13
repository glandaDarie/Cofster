import numpy as np
from typing import List
import os

def select_n_random_samples(samples : List[str], batch_size : int = 200) -> np.ndarray[str]:
    return np.random.choice(samples, batch_size, replace=False)

def get_samples_from_file(path : str) -> List[str]:
    with open(path, "r") as file:
        start_samples : int = 1
        content : List[str] = file.readlines()
        end_samples : int = len(content)
        return [line for (index, line) in enumerate(content) if index >= start_samples and index <= end_samples]

def format_content(samples : np.ndarray[str]) -> str:
    content : str = ""
    for line in samples:
        content += line
    return content

def add_sample_batch_to_file(path : str, content : str) -> None:
    with open(path, "a") as file:
        file.write(content)

def main() -> None:
    PATH : str = os.path.join(os.path.dirname(__file__), "coffee_dataset.txt") 
    samples : List[str] = get_samples_from_file(path=PATH)
    PATH : str = os.path.join(os.path.dirname(__file__), "test_dataset.txt") 
    for batch_size in range(50):
        random_samples : np.ndarray[str] = select_n_random_samples(samples=samples)
        formatted_samples : str = format_content(samples=random_samples)
        add_sample_batch_to_file(PATH, formatted_samples)
        print(f"Batch size: {batch_size}")

if __name__ == "__main__":
    main()
