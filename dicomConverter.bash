#!/bin/bash

# Parse command-line arguments
while getopts i:o:h flag
do
    case "${flag}" in
        i) DICOM_DIR=${OPTARG};;
        o) OUTPUT_DIR=${OPTARG};;
        h) echo "Usage: $0 -i input_directory -o output_directory -h for usage guide"
         exit 0 ;;
        *) echo "Usage: $0 -i input_directory -o output_directory -h for usage guide"
           exit 1 ;;
    esac
done

# Check if both input and output directories are provided
if [ -z "$DICOM_DIR" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Both input (-i) and output (-o) directories are required."
    echo "Usage: $0 -i input_directory -o output_directory"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

#check for input dir
if [ -z "$(ls -A "$DICOM_DIR")" ]; then
    echo "No DICOM files found in the directory."
    exit 1
fi

# Generate timestamp once for the overall statistics file
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
stats_file="${OUTPUT_DIR}/${timestamp}_statistics_summary.txt"

# Iterate over each DICOM file in the directory
for dcm_file in "$DICOM_DIR"/*; do
  # Convert DICOM to NIfTI using dcm2niix
  ./dcm2niix.exe -b y -ba n -o "$OUTPUT_DIR" "$dcm_file"

  # Get the base filename using the first field before the first underscore
  base_name=$(basename "$dcm_file" | cut -d'_' -f1)

  echo "Processing base name: $base_name"

  # Find the corresponding NIfTI and JSON files in the output directory
  nii_file=$(find "$OUTPUT_DIR" -name "${base_name}*.nii" | head -n 1)
  json_file=$(find "$OUTPUT_DIR" -name "${base_name}*.json" | head -n 1)

  # Check if both files exist
  if [[ -f "$nii_file" && -f "$json_file" ]]; then
    echo "Statistics for $base_name:" >> "$stats_file"

    # Extract and append desired statistics (i.e., Patient Age, Acquisition Date/Time, etc.)
    ./jq.exe -r '"Patient Age: \(.PatientAge)\nMagnetic Field Strength: \(.MagneticFieldStrength)\nAcquisition Date/Time: \(.AcquisitionDateTime)\nSeries Description: \(.SeriesDescription)"' "$json_file" >> "$stats_file"

    # Add an empty line for readability between entries
    echo "" >> "$stats_file"

    echo "Conversion and statistics extraction for $base_name complete. Stats appended to: $stats_file"
  else
    echo "No matching JSON or NIfTI file found for $base_name."
  fi
done

# Final message
echo "Conversion and statistics extraction complete for all files. Check the compiled statistics in: $stats_file"


