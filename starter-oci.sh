#!/bin/bash

set -e

# Define the directory where starter charts are stored, based on Helm's data home
STARTERS_DIRECTORY="$(helm env HELM_DATA_HOME)/starters"

# Ensure Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed."
    exit 1
fi

# Ensure the starter directory exists
mkdir -p "$STARTERS_DIRECTORY"

# Help message
function show_help() {
    echo "Usage: helm starter-oci <command> [options]"
    echo ""
    echo "Commands:"
    echo "  pull <registry_url> --version <version>   - Pull a starter chart from an OCI registry"
    echo "  update <registry_url> --version <version> - Update a starter chart if a newer version is available"
    echo "  delete <chart_name>                       - Delete a starter chart from the local system"
    echo "  help                                      - Show this help message"
    echo ""
    echo "Note: The registry URL must start with 'oci://'."
}

# Ensure registry URL starts with 'oci://'
function check_registry_url() {
    local registry_url="$1"
    if [[ "$registry_url" != oci://* ]]; then
        echo "Error: The registry URL must start with 'oci://'."
        show_help
        exit 1
    fi
}

# Extract chart name from registry URL
function get_chart_name() {
    local registry_url="$1"
    basename "$registry_url"
}

# Parse command-line arguments for version flag
function require_version_flag() {
    for arg in "$@"; do
        if [[ "$arg" == "--version" ]]; then
            return 0
        fi
    done
    echo "Error: --version flag is required."
    show_help
    exit 1
}

# Pull command
function pull_chart() {
    local registry_url="$1"
    local version="$2"

    check_registry_url "$registry_url"

    if [ -z "$registry_url" ] || [ -z "$version" ]; then
        echo "Usage: helm starter-oci pull <registry_url> --version <version>"
        return 1
    fi

    local chart_name
    chart_name=$(get_chart_name "$registry_url")

    helm pull "$registry_url" --version "$version" --destination "$STARTERS_DIRECTORY" --untar
    echo "Chart '$chart_name' (version $version) pulled successfully to $STARTERS_DIRECTORY."
}

# Update command
function update_chart() {
    local registry_url="$1"
    local version="$2"

    check_registry_url "$registry_url"

    if [ -z "$registry_url" ] || [ -z "$version" ]; then
        echo "Usage: helm starter-oci update <registry_url> --version <version>"
        return 1
    fi

    local chart_name
    chart_name=$(get_chart_name "$registry_url")

    helm pull "$registry_url" --version "$version" --destination "$STARTERS_DIRECTORY" --untar
    echo "Chart '$chart_name' (version $version) updated successfully in $STARTERS_DIRECTORY."
}

# Delete command
function delete_chart() {
    local chart_name="$1"

    if [ -z "$chart_name" ]; then
        echo "Usage: helm starter-oci delete <chart_name>"
        return 1
    fi

    rm -rf "$STARTERS_DIRECTORY/$chart_name"
    echo "Chart '$chart_name' deleted from $STARTERS_DIRECTORY."
}

# Parse command-line arguments
case "$1" in
    pull)
        require_version_flag "$@"
        pull_chart "$2" "$4"
        ;;
    update)
        require_version_flag "$@"
        update_chart "$2" "$4"
        ;;
    delete)
        delete_chart "$2"
        ;;
    help)
        show_help
        ;;
    *)
        echo "Invalid command."
        show_help
        ;;
esac
