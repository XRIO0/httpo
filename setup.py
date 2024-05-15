import shutil
import os

source_directory = os.getcwd()

destination_directory = "/usr/local/bin"

binary_files = ["httpo"]

for file_name in binary_files:
    source_path = os.path.join(source_directory, file_name)
    destination_path = os.path.join(destination_directory, file_name)
    
    try:
        shutil.move(source_path, destination_path)
        print(f"File '{file_name}' moved successfully to '{destination_directory}'.")
        
        os.chmod(destination_path, 0o755) 
        
        print(f"Permission set for file '{file_name}' in '{destination_directory}'.")
    except FileNotFoundError:
        print(f"File '{file_name}' not found in the source directory.")
    except PermissionError:
        print(f"Permission denied to move file '{file_name}' to '{destination_directory}'.")
    except Exception as e:
        print(f"Error occurred while moving file '{file_name}': {e}")
