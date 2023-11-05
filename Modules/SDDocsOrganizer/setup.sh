#!/bin/sh

echo ">>> SETUP SDDocsOrganizer Project"
xcodegen --spec project_SDDocsOrganizer.yml
pod install