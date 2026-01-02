#!/bin/bash
# loadenv.sh - Load environment variables from app-specific and common files
# Usage: source loadenv.sh [app_name] [--prod] [--with-sh]

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

get_app_name() {
    echo "${1:-$(basename "$(pwd)")}"
}

load_common_env() {
    local common_env_file=""
    local common_locations=(
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

    if [ -n "$common_env_file" ]; then
        load_from_file "$common_env_file" "Shared: "
        return 0
    else
        echo "Note: No common environment file found"
        echo "Looked in: ${common_locations[*]}"
        return 1
    fi
}

function loadenv() {
    local app_name=""
    local env_type="dev"
    local with_sh=false

    # Parse options (long and short, with combined shorts)
    while [[ $# -gt 0 ]]; do
        if [[ $1 == --* ]]; then
            case $1 in
                --prod) env_type="prod"; shift ;;
                --with-sh) with_sh=true; shift ;;
                *) echo "Invalid long option: $1" >&2; return 1 ;;
            esac
        elif [[ $1 == -* ]]; then
            local optstring="${1#-}"
            while [[ -n $optstring ]]; do
                case ${optstring:0:1} in
                    p) env_type="prod" ;;
                    w) with_sh=true ;;
                    *) echo "Invalid short option: -${optstring:0:1}" >&2; return 1 ;;
                esac
                optstring="${optstring:1}"
            done
            shift
        else
            app_name="$1"
            shift
        fi
    done

    # Get app name (first remaining argument or default to current dir)
    if [ -z "$app_name" ]; then
        app_name="$(get_app_name "$1")"
    fi

    # Set file suffix based on environment type
    local suffix=""
    if [ "$env_type" = "prod" ]; then
        suffix="-prod"
    fi

    local loaded_files=0

    # Load common environment variables first
    if load_common_env; then
        ((loaded_files++))
    fi

    # Load .sh file if requested
    if $with_sh; then
        local sh_file=""
        local sh_locations=(
            "./$app_name.sh"
            "./.$app_name.sh"
            "$HOME/$app_name.sh"
            "$HOME/.$app_name.sh"
            "$HOME/.config/$app_name.sh"
            "$HOME/.config/.$app_name.sh"
            "../../config/$app_name-dev-config.sh"
        )

        for location in "${sh_locations[@]}"; do
            if [ -f "$location" ]; then
                sh_file="$location"
                break
            fi
        done

        if [ -n "$sh_file" ]; then
            echo "Sourcing shell script: $sh_file"
            source "$sh_file"
        else
            echo "Warning: Shell script not found for '$app_name'"
            echo "Looked in: ${sh_locations[*]}"
        fi
    fi

    # Load app-specific environment variables
    local env_file=""
    local env_locations=(
        "./${app_name}${suffix}.env"
        "./.${app_name}${suffix}.env"
        "$HOME/${app_name}${suffix}.env"
        "$HOME/.${app_name}${suffix}.env"
        "$HOME/.config/${app_name}${suffix}.env"
        "$HOME/.config/.${app_name}${suffix}.env"
    )

    for location in "${env_locations[@]}"; do
        if [ -f "$location" ]; then
            env_file="$location"
            break
        fi
    done

    if [ -n "$env_file" ]; then
        load_from_file "$env_file" "$app_name: "
        ((loaded_files++))
    else
        echo "Warning: Environment file not found for '$app_name' ($env_type)"
        echo "Looked in: ${env_locations[*]}"
    fi

    # Check if any files were loaded
    if [ "$loaded_files" -eq 0 ]; then
        echo "Error: No environment files found for '$app_name' or common"
        return 1
    fi

    echo "Environment loaded successfully for '$app_name' ($env_type)"
    return 0
}


# Detect if being sourced in zsh or bash
if [ -n "$ZSH_VERSION" ]; then
    # ZSH specific handling
    if [[ "$0" != "$ZSH_ARGZERO" && "$#" -gt 0 ]]; then
        loadenv "$@"
    fi
elif [ -n "$BASH_VERSION" ]; then
    # BASH specific handling
    if [[ "${BASH_SOURCE[0]}" != "${0}" && "$#" -gt 0 ]]; then
        loadenv "$@"
    fi
else
    # Generic fallback
    # Assuming if not executed directly, then it's being sourced
    if [[ "$#" -gt 0 ]]; then
        loadenv "$@"
    fi
fi

