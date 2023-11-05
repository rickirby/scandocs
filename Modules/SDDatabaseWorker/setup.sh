#!/bin/sh

echo ">>> SETUP SDDatabaseWorker Project"
xcodegen --spec project_SDDatabaseWorker.yml
pod install