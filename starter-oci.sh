#!/bin/bash

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
    echo "Usage: starter-oci <command> [options]"
    echo ""
    echo "Commands:"
    echo "  pull <registry> <chart>   - Pull a starter chart from an OCI registry"
    echo "  update <registry> <chart> - Update a starter chart if a newer version is available"
    echo "  delete <chart>            - Delete a starter chart from the local system"
    echo "  help                      - Show this help message"
}

# Pull command
function pull_chart() {
    local chart="$1"
    local registry="$2"

    if [ -z "$chart" ] || [ -z "$registry" ]; then
        echo "Usage: starter-oci pull <registry> <chart>"
        return 1
    fi

    helm pull "$registry/$chart" --version "$VERSION" --destination "$STARTERS_DIRECTORY" --untar
    echo "Chart '$chart' pulled successfully to $STARTERS_DIRECTORY."
}

# Update command
function update_chart() {
    local chart="$1"
    local registry="$2"

    if [ -z "$chart" ] || [ -z "$registry" ]; then
        echo "Usage: starter-oci update <registry> <chart>"
        return 1
    fi

    helm pull "$registry/$chart" --destination "$STARTERS_DIRECTORY" --version "$VERSION" --untar
    echo "Chart '$chart' updated successfully in $STARTERS_DIRECTORY."
}

# Delete command
function delete_chart() {
    local chart="$1"

    if [ -z "$chart" ]; then
        echo "Usage: starter-oci delete <chart>"
        return 1
    fi

    rm -rf "$STARTER_DIR/$chart"
    echo "Chart '$chart' deleted from $STARTERS_DIRECTORY."
}

# Parse command-line arguments
case "$1" in
    pull)
        pull_chart "$2" "$3"
        ;;
    update)
        update_chart "$2" "$3"
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
