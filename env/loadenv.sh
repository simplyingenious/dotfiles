#!/bin/bash
# loadenv.sh - Load environment variables from app-specific and common files
# Usage: source loadenv.sh app_name

function loadenv() {
    local app_name="$1"
    local env_file=""
    local common_env_file=""
    local loaded_files=0

    # Check if app name is provided
    if [ -z "$app_name" ]; then
        echo "Error: Please provide an application name"
        echo "Usage: loadenv app_name"
        return 1
    fi

    # Try different possible locations for the common env file
    common_locations=(
        "./.env"
        "$HOME/.env"
        "$HOME/.config/.env"
    )

    # Find the first existing common env file
    for location in "${common_locations[@]}"; do
        if [ -f "$location" ]; then
            common_env_file="$location"
            break
        fi
    done

    # Try different possible locations for the app-specific env file
    app_locations=(
        "./$app_name.env"
        "./.$app_name.env"
        "$HOME/$app_name.env"
        "$HOME/.$app_name.env"
        "$HOME/.config/$app_name.env"
        "$HOME/.config/.$app_name.env"
    )

    # Find the first existing app-specific env file
    for location in "${app_locations[@]}"; do
        if [ -f "$location" ]; then
            env_file="$location"
            break
        fi
    done

    # Function to load variables from a file
    load_from_file() {
        local file="$1"
        local prefix="$2"

        echo "Loading environment from: $file"

        # Load the environment variables
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip comments and empty lines
            if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
                continue
            fi

            # Remove inline comments
            line=$(echo "$line" | sed 's/#.*$//')

            # Trim whitespace
            line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

            # Skip if line is now empty
            if [[ -z "$line" ]]; then
                continue
            fi

            # Parse the variable name and value
            var_name=$(echo $line | cut -d= -f1 | sed -e 's/^export //')
            var_value=$(echo $line | cut -d= -f2-)

            # Remove surrounding quotes from the value if present
            # This mimics the behavior of direct source command
            if [[ "$var_value" =~ ^\"(.*)\"$ || "$var_value" =~ ^\'(.*)\'$ ]]; then
                # Remove the quotes using parameter expansion
                var_value="${var_value:1:${#var_value}-2}"
            fi

            # Export the variable in a shell-compatible way
            export "$var_name=$var_value"

            echo "${prefix}Set: $var_name"
        done < "$file"

        return 0
    }

    # Load common environment variables first, if found
    if [ -n "$common_env_file" ]; then
        load_from_file "$common_env_file" "Shared: "
        ((loaded_files++))
    else
        echo "Note: No common environment file found"
        echo "Looked in: ${common_locations[*]}"
    fi

    # Load app-specific environment variables, if found
    if [ -n "$env_file" ]; then
        load_from_file "$env_file" "$app_name: "
        ((loaded_files++))
    else
        echo "Warning: No environment file found for '$app_name'"
        echo "Looked in: ${app_locations[*]}"
    fi

    # Check if any files were loaded
    if [ "$loaded_files" -eq 0 ]; then
        echo "Error: No environment files found for '$app_name' or common"
        return 1
    fi

    echo "Environment loaded successfully for '$app_name'"
    return 0
}

# Detect if being sourced in zsh or bash
if [ -n "$ZSH_VERSION" ]; then
    # ZSH specific handling
    if [[ "$0" != "$ZSH_ARGZERO" && "$#" -gt 0 ]]; then
        loadenv "$1"
    fi
elif [ -n "$BASH_VERSION" ]; then
    # BASH specific handling
    if [[ "${BASH_SOURCE[0]}" != "${0}" && "$#" -gt 0 ]]; then
        loadenv "$1"
    fi
else
    # Generic fallback
    # Assuming if not executed directly, then it's being sourced
    if [[ "$#" -gt 0 ]]; then
        loadenv "$1"
    fi
fi

