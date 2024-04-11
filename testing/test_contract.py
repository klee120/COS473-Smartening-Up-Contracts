import subprocess
import os
import tempfile
import json
from sys import argv, exit

DEBUG = True


def validate(contract: str, scratch_dir="/tmp/aytao") -> tuple[bool, list[tuple[str, str, str]]]:
    '''
    Returns tuple (error, slither_warnings). If error is true,
    slither_warnings will be empty. Otherwise, slither_warnings is a list of
    (impact, check, description) tuples.
    '''
    os.makedirs(scratch_dir, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=scratch_dir) as work_dir:
        os.chdir(work_dir)

        contract_file = "contract.sol"
        with open(contract_file, "w") as f:
            f.write(contract)

        command = ["solc", contract_file]
        compile = subprocess.run(command, capture_output=True, text=True)

        try:
            compile.check_returncode()
        except:
            print(compile.stderr)
            print("\n\n")
            print(contract)
            exit(1)
            return True, []

        command = ["slither", contract_file]
        command.extend(["--exclude-optimization", "--exclude-informational"])
        command.extend(["--solc-disable-warnings"])
        command.extend(["--json", "-"])
        slither_process = subprocess.run(command, capture_output=True)
        slither = json.loads(slither_process.stdout)

        if "success" not in slither or not slither["success"] or \
                slither["error"] is not None or "results" not in slither:
            return True, []

        try:
            errors = slither["results"]["detectors"]
            ret = []

            for error in errors:
                cleaned_error = (
                    error["impact"], error["check"], error["description"])
                ret.append(cleaned_error)

            return False, ret

        except:
            return True, []


def main(argv):
    if len(argv) <= 1:
        print("Usage:", "python", "[FILE]...")

    # for i in range(1, len(argv)):
    #     with open(argv[i], "r") as f:
    #         contract = f.read()
    #         compile_err, slither_errors = validate(contract, ".")

    #         if compile_err:
    #             print(
    #                 "Error while compiling contract/parsing slither output", argv[i])
    #         else:
    #             print("Errors:")

    #             for error in slither_errors:
    #                 print('\t', error)

    with open(argv[1], "r") as contracts_file:
        contracts = json.load(contracts_file)

        for i, contract in enumerate(contracts):
            # if (i < 7):
            #     continue
            # compile_err, slither_errors = validate(contract)
            # if compile_err:
            #     print("compile err")
            # else:
            #     print(len(slither_errors))
            prefix = argv[2]
            with open(prefix + "contract_file_" + str(i) + ".sol", "w") as f:
                f.write(contract)


if __name__ == "__main__":
    main(argv)
