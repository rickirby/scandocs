#!/bin/sh

echo ">>> SETUP SDCloudKitModel Project"
xcodegen --spec project_SDCloudKitModel.yml
pod install