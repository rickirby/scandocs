#!/bin/sh

echo ">>> SETUP SDScanKit Project"
xcodegen --spec project_SDScanKit.yml
pod install