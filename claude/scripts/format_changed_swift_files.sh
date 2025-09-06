#!/bin/bash

# Read JSON input from stdin
json_input=$(cat)

# Extract file path from tool_input
file_path=$(echo "$json_input" | jq -r '.tool_input.file_path // empty')

# If file path exists and is a Swift file, format it
if [[ -n "$file_path" && "$file_path" == *.swift && -f "$file_path" ]]; then
    swiftformat "$file_path" 2>/dev/null || true
fi

# Always exit successfully to avoid blocking the edit
exit 0