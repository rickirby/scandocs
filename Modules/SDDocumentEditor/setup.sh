#!/bin/sh

echo ">>> SETUP SDDocumentEditor Project"
xcodegen --spec project_SDDocumentEditor.yml
pod install