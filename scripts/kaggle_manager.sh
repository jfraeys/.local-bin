#!/bin/bash

# Default settings
DATASET_DIR="data/raw"                     # Directory to store downloaded datasets
NOTEBOOK_DIR="notebooks"                   # Directory to store downloaded notebooks
COMMIT_MESSAGE="Added dataset or notebook" # Default commit message
VERBOSE=0                                  # Default verbosity flag

# Usage function
usage() {
	echo "Usage: $0 [options]"
	echo "  -d, --dataset   Kaggle dataset name (e.g., 'username/dataset-name') to download"
	echo "  -n, --notebook  Kaggle notebook URL suffix (e.g., 'username/notebook-name') to download"
	echo "  -s, --submit    Notebook file to submit to a competition"
	echo "  -c, --competition Competition name for notebook submission"
	echo "  -g, --git       Flag to add and commit changes to Git after download or submission"
	echo "  -v, --verbose    Enable verbose output"
	echo "  -h, --help       Display this help message"
	exit 1
}

# Parse command-line arguments
COMMIT_FLAG=0
DATASET_NAME=""
NOTEBOOK_NAME=""
NOTEBOOK_FILE=""
COMPETITION_NAME=""

while [[ "$#" -gt 0 ]]; do
	case $1 in
	-d | --dataset)
		DATASET_NAME="$2"
		shift
		;;
	-n | --notebook)
		NOTEBOOK_NAME="$2"
		shift
		;;
	-s | --submit)
		NOTEBOOK_FILE="$2"
		shift
		;;
	-c | --competition)
		COMPETITION_NAME="$2"
		shift
		;;
	-g | --git) COMMIT_FLAG=1 ;;
	-v | --verbose) VERBOSE=1 ;;
	-h | --help) usage ;; # Call usage function for help
	*) usage ;;
	esac
	shift
done

# Extract Kaggle credentials from kaggle.json
if ! KAGGLE_USERNAME=$(jq -r .username ~/.kaggle/kaggle.json) || ! KAGGLE_KEY=$(jq -r .key ~/.kaggle/kaggle.json); then
	echo "Failed to retrieve Kaggle credentials from kaggle.json."
	exit 1
fi

# Check if credentials were successfully extracted
if [[ -z "$KAGGLE_USERNAME" || -z "$KAGGLE_KEY" ]]; then
	echo "Kaggle credentials are empty. Please check your kaggle.json file."
	exit 1
fi

# Function to echo messages if verbosity is enabled
verbose_echo() {
	if [[ $VERBOSE -eq 1 ]]; then
		echo "$1"
	fi
}

# Download dataset
if [[ -n "$DATASET_NAME" ]]; then
	# Create the dataset directory if it doesn't exist
	mkdir -p "$DATASET_DIR"

	# Download the dataset using curl
	verbose_echo "Downloading dataset: $DATASET_NAME to $DATASET_DIR"
	if ! curl -L -o "${DATASET_DIR}/dataset.zip" \
		-u "$KAGGLE_USERNAME:$KAGGLE_KEY" \
		"https://www.kaggle.com/api/v1/datasets/download/$DATASET_NAME"; then
		echo "Failed to download dataset: $DATASET_NAME"
		exit 1
	fi

	# Unzip the dataset and remove the zip file
	verbose_echo "Unzipping dataset..."
	if ! unzip -o "${DATASET_DIR}/dataset.zip" -d "$DATASET_DIR"; then
		echo "Failed to unzip dataset."
		exit 1
	fi
	rm "${DATASET_DIR}/dataset.zip"

	# Git add and commit if the flag is set
	if [[ $COMMIT_FLAG -eq 1 ]]; then
		if ! git add "$DATASET_DIR"; then
			echo "Failed to add dataset to Git."
			exit 1
		fi
		if ! git commit -m "$COMMIT_MESSAGE: Dataset $DATASET_NAME"; then
			echo "Failed to commit dataset to Git."
			exit 1
		fi
		verbose_echo "Committed dataset $DATASET_NAME to Git."
	fi
fi

# Download notebook
if [[ -n "$NOTEBOOK_NAME" ]]; then
	# Create the notebook directory if it doesn't exist
	mkdir -p "$NOTEBOOK_DIR"

	# Download the notebook using curl
	verbose_echo "Downloading notebook: $NOTEBOOK_NAME to $NOTEBOOK_DIR"
	if ! curl -L -o "${NOTEBOOK_DIR}/${NOTEBOOK_NAME##*/}.ipynb" \
		-u "$KAGGLE_USERNAME:$KAGGLE_KEY" \
		"https://www.kaggle.com/api/v1/kernels/source/$NOTEBOOK_NAME"; then
		echo "Failed to download notebook: $NOTEBOOK_NAME"
		exit 1
	fi

	# Git add and commit if the flag is set
	if [[ $COMMIT_FLAG -eq 1 ]]; then
		if ! git add "$NOTEBOOK_DIR"; then
			echo "Failed to add notebook to Git."
			exit 1
		fi
		if ! git commit -m "$COMMIT_MESSAGE: Notebook $NOTEBOOK_NAME"; then
			echo "Failed to commit notebook to Git."
			exit 1
		fi
		verbose_echo "Committed notebook $NOTEBOOK_NAME to Git."
	fi
fi

# Submit a notebook to a Kaggle competition
if [[ -n "$NOTEBOOK_FILE" && -n "$COMPETITION_NAME" ]]; then
	verbose_echo "Submitting notebook: $NOTEBOOK_FILE to competition $COMPETITION_NAME"

	# Submit the notebook
	if ! curl -L -X POST \
		-F "file=@${NOTEBOOK_FILE}" \
		-u "$KAGGLE_USERNAME:$KAGGLE_KEY" \
		"https://www.kaggle.com/api/v1/competitions/submissions/upload/$COMPETITION_NAME"; then
		echo "Notebook submission failed."
		exit 1
	else
		echo "Notebook submitted successfully!"

		# Git add and commit if the flag is set
		if [[ $COMMIT_FLAG -eq 1 ]]; then
			if ! git add "$NOTEBOOK_FILE"; then
				echo "Failed to add submitted notebook to Git."
				exit 1
			fi
			if ! git commit -m "$COMMIT_MESSAGE: Submitted notebook $NOTEBOOK_FILE to $COMPETITION_NAME"; then
				echo "Failed to commit submitted notebook to Git."
				exit 1
			fi
			verbose_echo "Committed submitted notebook $NOTEBOOK_FILE to Git."
		fi
	fi
fi

# If no operation was specified
if [[ -z "$DATASET_NAME" && -z "$NOTEBOOK_NAME" && -z "$NOTEBOOK_FILE" ]]; then
	echo "No operation specified. Please provide a dataset, notebook, or submission to process."
	usage
fi
