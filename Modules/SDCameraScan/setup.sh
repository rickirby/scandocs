#!/bin/sh

echo ">>> SETUP SDCameraScan Project"
xcodegen --spec project_SDCameraScan.yml
pod install