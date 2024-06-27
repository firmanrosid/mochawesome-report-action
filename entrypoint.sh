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

COUNT=$( ( ls ./${INPUT_REPORT_HISTORY} | wc -l ) )
echo "Count folders in report-history: ${COUNT}"
echo "Keep reports count ${INPUT_KEEP_REPORTS}"
INPUT_KEEP_REPORTS=$((INPUT_KEEP_REPORTS+1))
echo "If ${COUNT} > ${INPUT_KEEP_REPORTS}"
if (( COUNT > INPUT_KEEP_REPORTS )); then
  cd ./${INPUT_REPORT_HISTORY}
  rm report.html report.json -rv
  echo "Remove old reports"
  ls | sort -n | grep -v 'CNAME' | head -n -$((${INPUT_KEEP_REPORTS}-2)) | xargs rm -rv;
  cd ${GITHUB_WORKSPACE}
fi

# Rename INPUT_MOCHAWESOME_REPORT folder to INPUT_SUBFOLDER
if [ -d "${INPUT_MOCHAWESOME_REPORT}" ]; then
  echo "Renaming ${INPUT_MOCHAWESOME_REPORT} to ${INPUT_SUBFOLDER}"
  mv "${INPUT_MOCHAWESOME_REPORT}" "${INPUT_SUBFOLDER}"
fi

# Copy contents of INPUT_SUBFOLDER to INPUT_REPORT_HISTORY/INPUT_GITHUB_RUN_NUM
if [ -d "${INPUT_SUBFOLDER}" ]; then
  echo "Copying contents of ${INPUT_SUBFOLDER} to ${INPUT_REPORT_HISTORY}/${INPUT_GITHUB_RUN_NUM}"
  cp -r ./${INPUT_SUBFOLDER}/. ./${INPUT_REPORT_HISTORY}/${INPUT_GITHUB_RUN_NUM}
else
  echo "Folder ${INPUT_SUBFOLDER} not found."
fi

# Rename report.html files to index.html
# find "$INPUT_REPORT_HISTORY" -type f -name 'report.html' -execdir mv {} index.html \;

ls -R
