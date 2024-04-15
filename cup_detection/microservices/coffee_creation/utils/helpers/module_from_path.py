import importlib.util as l_util
from importlib.machinery import ModuleSpec
from types import ModuleType

def get_module_from_path(module_path : str) -> ModuleType:
    module_name : str = module_path.split("/")[-1]
    spec : (ModuleSpec | None) = l_util.spec_from_file_location(name=module_name, location=f"{module_path}.py")
    module : ModuleType = l_util.module_from_spec(spec=spec)
    spec.loader.exec_module(module=module)
    return module