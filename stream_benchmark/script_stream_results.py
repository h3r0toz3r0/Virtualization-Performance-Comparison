import argparse
import csv
from pathlib import Path
import itertools

FUNCTION_NAMES = ("Copy", "Scale", "Add", "Triad")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="Path to the results file.")
    args = parser.parse_args()

    results = {name: [] for name in FUNCTION_NAMES}

    with open(args.file, "r") as fh:
        for line in fh:
            if line.startswith(FUNCTION_NAMES):
                # Resulting split will be [Function Name, Avg Rage, Avg Time, Min time, Max Time]
                line_split = line.split()
                fname = line_split[0][:-1]  # Remove the :

                results[fname].append(float(line_split[1]))

    # Sanity check to make sure all the results are the same length
    length = None
    for rate_list in results.values():
        if length == None:
            length = len(rate_list)
        else:
            if length != len(rate_list):
                raise RuntimeError(
                    f"Number of results do not match! {length} != {len(rate_list)}"
                )

    print("Average Rate MB/s")
    name_width = max([len(name) for name in FUNCTION_NAMES])

    for fname, rates in results.items():
        avg = sum(rates) / len(rates)
        print(f"{fname:<{name_width}}:  {avg:.6}")

    # Output to csv file
    csv_path = Path(args.file).with_suffix(".csv")
    with open(csv_path, "w") as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(FUNCTION_NAMES)  # Header

        result_lists = [results[func] for func in FUNCTION_NAMES]
        for result_row in itertools.zip_longest(*result_lists):
            writer.writerow(result_row)
