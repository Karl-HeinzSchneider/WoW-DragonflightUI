#!/bin/bash
# Deploy the fork into the live Classic Era AddOns folder.
set -euo pipefail
SRC="$(cd "$(dirname "$0")/.." && pwd)"
DEST="/Applications/World of Warcraft/_classic_era_/Interface/AddOns/DragonflightUI"
rsync -a --delete \
    --exclude '.git' --exclude 'docs' --exclude 'scripts' --exclude 'tests' \
    --exclude '*.md' --exclude '.github' --exclude '.vscode' \
    "$SRC/" "$DEST/"
echo "Deployed to $DEST"
