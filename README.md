
# DICOM to NIfTI Conversion Script

This script converts DICOM files to NIfTI format using the `dcm2niix` tool and extracts specific metadata from the generated JSON files. The extracted statistics are then written to a summary file in the specified output directory.

## Prerequisites

- **Git Bash or any Bash-compatible terminal** (for running the script)
- **dcm2niix** executable for converting DICOM files to NIfTI
- **jq** command-line tool for processing JSON files

Ensure that `dcm2niix` and `jq` are installed and accessible in the directory where the script is run or are available in your system's PATH.

## Usage

To run the script, use the following command:

\`\`\`bash
bash script_name.bash -i input_directory -o output_directory
\`\`\`

### Command-Line Arguments

- `-i`: **Required.** Specifies the input directory containing DICOM files.
- `-o`: **Required.** Specifies the output directory where NIfTI files and the summary file will be saved.
- `-h`: Displays usage information.

### Example

\`\`\`bash
bash script_name.bash -i /path/to/dicom_directory -o /path/to/output_directory
\`\`\`

This will convert all DICOM files in \`/path/to/dicom_directory\` to NIfTI format, extract metadata, and save the results in \`/path/to/output_directory\`.

## Description

1. **Parsing Command-Line Arguments:**
   - The script accepts three arguments: the input directory, output directory, and a help flag.
   - If the required arguments are not provided, the script will display usage instructions and exit.

2. **Directory Checks:**
   - The script checks whether both the input and output directories are provided.
   - It creates the output directory if it does not exist.
   - It checks if the input directory contains any DICOM files. If none are found, the script exits with an error.

3. **Conversion and Metadata Extraction:**
   - The script iterates over each DICOM file in the input directory, converting them to NIfTI format using `dcm2niix`.
   - The base name of each file (before the first underscore) is extracted and used to find the corresponding `.nii` and `.json` files in the output directory.
   - The script uses `jq` to extract specific metadata from the JSON files, including:
     - Patient Age
     - Magnetic Field Strength
     - Acquisition Date/Time
     - Series Description
   - The extracted information is appended to a summary file in the output directory.

4. **Compatibility Notes:**
   - If running on a different machine, the `dcm2niix` and `jq` command calls might need to be adjusted (e.g., removing the `.exe` extension on non-Windows systems).

## Output

- **NIfTI Files**: Converted files are saved in the specified output directory.
- **Statistics Summary**: A file named `statistics_summary.txt` is created in the output directory, containing the extracted metadata for each DICOM file.

### Example Output in `statistics_summary.txt`:

\`\`\`
Statistics for I171270:
Patient Age: 86
Magnetic Field Strength: 3
Acquisition Date/Time: 2021-09-15T14:25:30Z
Series Description: Head MRI

Statistics for I171274:
Patient Age: 65
Magnetic Field Strength: 1.5
Acquisition Date/Time: 2021-09-16T10:15:00Z
Series Description: Brain T1

...

Conversion and statistics extraction complete. Check /path/to/output_directory/statistics_summary.txt for details.
\`\`\`

## Troubleshooting

- **jq: command not found**: Ensure `jq` is installed and accessible in your PATH. See the [jq installation guide](https://stedolan.github.io/jq/download/) for more information.
- **dcm2niix.exe: command not found**: Ensure `dcm2niix` is installed and accessible in your PATH. Adjust the command call if necessary based on your operating system.
