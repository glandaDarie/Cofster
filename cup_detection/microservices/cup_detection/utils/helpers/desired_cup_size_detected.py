from typing import List
from utils.helpers.shared_resource_singleton import SharedResourceSingleton

class DesiredCupSizeDetected(SharedResourceSingleton):
    def set_state(self, customer_selected_cup_size: str, detected_cup_sizes: List[str]) -> None:
        with self.lock:
            self.state[0] = self.__is_desired_cup_size_detected(
                customer_selected_cup_size=customer_selected_cup_size,
                detected_cup_sizes=detected_cup_sizes
            )

    def get_state(self) -> bool:
        with self.lock:
            return self.state[0]

    def __is_desired_cup_size_detected(self, customer_selected_cup_size: str, detected_cup_sizes: List[str]) -> bool:
        return customer_selected_cup_size in detected_cup_sizes