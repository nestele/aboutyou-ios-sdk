#!/bin/sh

PROJECT_NAME="AboutYouShop-iOS-SDK"
SOURCE_DIR="Classes/Core"

/usr/local/bin/appledoc \
--project-name "$PROJECT_NAME" \
--project-company "Slice-Dice GmbH" \
--company-id "de.slice-dice" \
--output "~/Projects/Help/$PROJECT_NAME" \
--install-docset \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--merge-categories \
--exit-threshold 2 \
--docset-platform-family iphoneos \
--ignore "*.m" \
--index-desc "README.md" \
"$SOURCE_DIR"