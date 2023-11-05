#!/bin/sh

echo ">>> SETUP SDCorekit Project"
xcodegen --spec project_SDCoreKit.yml
pod install