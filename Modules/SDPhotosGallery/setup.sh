#!/bin/sh

echo ">>> SETUP SDPhotosGallery Project"
xcodegen --spec project_SDPhotosGallery.yml
pod install