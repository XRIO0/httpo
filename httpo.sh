#!/bin/bash

display_logo() {
    local logo="\
 __  __ ___ ____ ____   __  __  ____  ___ ___
 |  \/  |_ _/ ___/ ___|  \ \/ / |  _ \|_ _/ _ \\
 | |\/| || |\___ \\___ \\   \  /  | |_) || | | | |
 | |  | || | ___) ___) |  /  \\  |  _ < | | |_| |
 |_|  |_|___|____|____/  /_/\\_\\ |_| \\_|___\\___/
                                    version:- 1.0
                           https://github.com/XRIO0
NOTE:- READ THE README.txt FOR OPTION AND USE
 "

    local delay=0.001
    for (( i=0; i<${#logo}; i++ )); do
        echo -n "${logo:$i:1}"
        sleep "$delay"
    done
    echo
}

display_logo

show_usage() {
    echo "Usage: $0 -i <input_file>"
    echo "Options:"
    echo "  -i, --input       Specify the input file containing subdomains"
    echo "  -h, --help        Display this help message"
    echo "  No need any  output file name he make automatic output file "
    exit 1
}

check_httpx() {
    if ! command -v httpx-toolkit &> /dev/null; then
        echo "httpx-toolkit is not installed."
        echo "Please run 'sudo apt install httpx-toolkit' to install it."
        exit 1
    fi
}

INPUT_FILE=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--input)
            INPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            echo "Error: Unknown option: $key"
            show_usage
            ;;
    esac
done

if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: Missing input file. Specify the input file containing subdomains."
    show_usage
fi

check_httpx

OUTPUT_DIR="${INPUT_FILE%.*}"
mkdir -p "$OUTPUT_DIR"

for STATUS_CODE in 200 301 302 400 401 403 404 500 503 504; do
    OUTPUT_FILE_NAME="${STATUS_CODE}_${INPUT_FILE}"
    httpx-toolkit -l "$INPUT_FILE" -mc "$STATUS_CODE" -silent -t 130 -o "$OUTPUT_DIR/$OUTPUT_FILE_NAME"
done

folder_path="$OUTPUT_DIR/"

if [ -d "$folder_path" ]; then
    cd "$folder_path"
    for file in *.txt; do
        if [ ! -s "$file" ]; then
            rm "$file"
            echo "Removed empty file: $file"
        fi
    done
    echo "Empty file removal completed."

   
    cat *.txt > final.txt
    echo "Combined non-empty files into final.txt"
else
    echo "Error: Folder not found."
fi
