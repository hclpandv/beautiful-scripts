#!/usr/bin/env bash
# Clone all repositories from an Azure DevOps project

set -euo pipefail

# config
#
ORG="MyOrg"        
PROJECT="Main"
PAT="G4t887v7e3PBZNiStIxxxxxxxxxxxxxxxxxxxxxx99BJACAAAAAb7uNtAAASAZDO4MMq"
DEST_DIR="./repos"

# Pre-reqs and validate inputs
#
for cmd in curl jq git; do
  if ! command -v $cmd &> /dev/null; then
    echo "Missing required command: $cmd"
    exit 1
  fi
done

if [[ -z "$ORG" || -z "$PROJECT" || -z "$PAT" ]]; then
  echo "Usage: set ORG, PROJECT, and PAT variables inside the script or pass them as environment variables."
  echo "Example: ORG='myorg' PROJECT='myproject' PAT='mypat' ./clone_azdevops_repos.sh"
  exit 1
fi

# Main
#
mkdir -p "$DEST_DIR"

echo "Fetching repositories from Azure DevOps project: $PROJECT"
API_URL="https://dev.azure.com/${ORG}/${PROJECT}/_apis/git/repositories?api-version=7.1-preview.1"

REPOS_JSON=$(curl -s -u ":$PAT" "$API_URL")
REPO_COUNT=$(echo "$REPOS_JSON" | jq '.count')

echo "✅ Found $REPO_COUNT repositories."

echo "$REPOS_JSON" | jq -r '.value[] | "\(.name) \(.remoteUrl)"' | while read -r NAME URL; do
  TARGET="${DEST_DIR}/${NAME}"
  if [ -d "$TARGET/.git" ]; then
    echo "Skipping '$NAME' (already cloned)"
  else
    echo "Cloning '$NAME'..."
    git clone "$URL" "$TARGET"
  fi
done

echo "Done! All repositories cloned to: $DEST_DIR"
