from typing import Union, Tuple

class FileIO:
    def __init__(self, path : str):
        self.__path : str = path
    
    def read(self) -> Tuple[Union[str, None], Union[str, None]]:
        error_msg : Union[str, None] = None
        out_data : Union[str, None] = None
        
        try:
            with open(file=self.__path, mode="r") as input_file:
                out_data : str = input_file.read()
                return error_msg, out_data
            
        except FileNotFoundError as file_not_found_error:
            error_msg = file_not_found_error

        except Exception as error:
            error_msg = error

        return error_msg, out_data
    
    def write(self, content : str) -> Union[str, None]:
        error_msg : Union[str, None] = None
        try:
            with open(file=self.__path, mode="w") as output_file:
                output_file.write(content)
        except Exception as error:
            error_msg = error

        return error_msg