#!/bin/bash

# Input Param
new_build_number="$1"

# Change BUILD_NUMBER in .xcconfig files
echo -e "\033[0;33mChange BUILD_NUMBER in all .xcconfig files into $new_build_number...\033[0m"
xcconfig_path="Configuration"

find "$xcconfig_path" -type f -name "*.xcconfig" -exec sed -i '' -e "s/BUILD_NUMBER = .*/BUILD_NUMBER = $new_build_number/" {} \;
echo -e "\033[0;32m✅ Successfully update BUILD_NUMBER to $new_build_number in all .xcconfig files\033[0m"