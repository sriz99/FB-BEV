import pickle
import sys
from pathlib import Path

def inspect_pkl(file_path):
    file_path = Path(file_path)

    if not file_path.exists():
        print(f"Error: File not found: {file_path}")
        return

    print(f"Reading: {file_path}")
    print(f"File size: {file_path.stat().st_size / (1024 * 1024):.2f} MB")

    try:
        with open(file_path, "rb") as f:
            data = pickle.load(f)

        print("\nSuccessfully loaded the pickle file.")
        print(f"Data type: {type(data)}")

        if isinstance(data, dict):
            print(f"Number of keys: {len(data)}")
            print("\nKeys:")
            for key in data.keys():
                print(f"  - {key}")

        elif isinstance(data, (list, tuple)):
            print(f"Number of elements: {len(data)}")

            for i, item in enumerate(data[:5]):
                print(f"\nElement {i}:")
                print(f"  Type: {type(item)}")
                print(f"  Value preview: {repr(item)[:300]}")

        else:
            print("\nValue preview:")
            print(repr(data)[:2000])

        return data

    except Exception as e:
        print(f"Error loading pickle file: {e}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 read_pkl.py <path_to_pkl_file>")
        sys.exit(1)

    inspect_pkl(sys.argv[1])