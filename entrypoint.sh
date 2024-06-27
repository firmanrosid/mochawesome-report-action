#!/usr/bin/env bash

# Create directories for gh-pages and report-history if they don't exist
echo "Creating directories: ./${INPUT_GH_PAGES} and ./${INPUT_REPORT_HISTORY}"
mkdir -p ./${INPUT_GH_PAGES}
mkdir -p ./${INPUT_REPORT_HISTORY}

# Copy all contents from gh-pages to report-history
echo "Copying contents from ./${INPUT_GH_PAGES} to ./${INPUT_REPORT_HISTORY}"
cp -r ./${INPUT_GH_PAGES}/. ./${INPUT_REPORT_HISTORY}

# Get repository name from full input (owner/repo)
REPOSITORY_OWNER_SLASH_NAME=${INPUT_GITHUB_REPO}
REPOSITORY_NAME=${REPOSITORY_OWNER_SLASH_NAME##*/}
GITHUB_PAGES_WEBSITE_URL="https://${INPUT_GITHUB_REPO_OWNER}.github.io/${REPOSITORY_NAME}"

# If a subfolder is specified, adjust paths and URL
if [[ ${INPUT_SUBFOLDER} != '' ]]; then
    INPUT_REPORT_HISTORY="${INPUT_REPORT_HISTORY}/${INPUT_SUBFOLDER}"
    INPUT_GH_PAGES="${INPUT_GH_PAGES}/${INPUT_SUBFOLDER}"
    mkdir -p ./${INPUT_REPORT_HISTORY}
    GITHUB_PAGES_WEBSITE_URL="${GITHUB_PAGES_WEBSITE_URL}/${INPUT_SUBFOLDER}"
    echo "Adjusted paths for subfolder: INPUT_REPORT_HISTORY=${INPUT_REPORT_HISTORY}, INPUT_GH_PAGES=${INPUT_GH_PAGES}"
    echo "Updated GITHUB_PAGES_WEBSITE_URL: ${GITHUB_PAGES_WEBSITE_URL}"
fi

# Rename INPUT_MOCHAWESOME_REPORT folder to INPUT_SUBFOLDER
if [ -d "${INPUT_MOCHAWESOME_REPORT}" ]; then
  echo "Renaming ${INPUT_MOCHAWESOME_REPORT} to ${INPUT_SUBFOLDER}"
  mv "${INPUT_MOCHAWESOME_REPORT}" "${INPUT_SUBFOLDER}"
fi

# Copy contents of INPUT_SUBFOLDER to report-history
if [ -d "${INPUT_SUBFOLDER}" ]; then
  echo "Copying contents of ${INPUT_SUBFOLDER} to ${INPUT_REPORT_HISTORY}"
  cp -r ./${INPUT_SUBFOLDER}/. ./${INPUT_REPORT_HISTORY}
else
  echo "Folder ${INPUT_SUBFOLDER} not found."
fi

ls -R
