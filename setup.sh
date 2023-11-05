#!/bin/sh

echo ">>> SETUP Scandocs Project"
xcodegen --spec project.yml
pod install