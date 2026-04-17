#!/bin/bash

# project-generator - Create new Makefile or Qt projects from templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/templates"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    echo "Usage: $0 <project_name> [type]"
    echo ""
    echo "Arguments:"
    echo "  project_name    Name of the project to create"
    echo "  type            Project type: makefile or qt (default: makefile)"
    echo ""
    echo "Examples:"
    echo "  $0 myapp makefile"
    echo "  $0 myapp qt"
    exit 1
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [ $# -lt 1 ]; then
    usage
fi

PROJECT_NAME="$1"
PROJECT_TYPE="${2:-makefile}"

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    log_error "Invalid project name. Use letters, numbers, underscores and hyphens only."
    exit 1
fi

# Validate project type
if [ "$PROJECT_TYPE" != "makefile" ] && [ "$PROJECT_TYPE" != "qt" ]; then
    log_error "Invalid project type: $PROJECT_TYPE"
    echo "Valid types: makefile, qt"
    exit 1
fi

# Target directory
TARGET_DIR="$(pwd)/$PROJECT_NAME"

if [ -d "$TARGET_DIR" ]; then
    log_error "Directory '$TARGET_DIR' already exists"
    exit 1
fi

log_info "Creating $PROJECT_TYPE project: $PROJECT_NAME"
log_info "Target: $TARGET_DIR"

# Copy template
if [ "$PROJECT_TYPE" == "qt" ]; then
    TEMPLATE_PATH="$TEMPLATE_DIR/qt"
else
    TEMPLATE_PATH="$TEMPLATE_DIR/makefile"
fi

if [ ! -d "$TEMPLATE_PATH" ]; then
    log_error "Template not found: $TEMPLATE_PATH"
    exit 1
fi

cp -r "$TEMPLATE_PATH" "$TARGET_DIR"

# Replace placeholders
find "$TARGET_DIR" -type f -name "*.cpp" -o -name "*.h" -o -name "*.pro" -o -name "Makefile*" -o -name "*.md" 2>/dev/null | while read file; do
    sed -i "s/@PROJECT_NAME@/$PROJECT_NAME/g" "$file" 2>/dev/null || true
done

# Rename template files if needed
if [ -f "$TARGET_DIR/@PROJECT_NAME@.pro" ]; then
    mv "$TARGET_DIR/@PROJECT_NAME@.pro" "$TARGET_DIR/$PROJECT_NAME.pro"
fi

# Create build directory
mkdir -p "$TARGET_DIR/build"

# Make script executable
chmod +x "$TARGET_DIR/scripts/"* 2>/dev/null || true

log_info "Project created successfully!"
echo ""
echo "Project structure:"
find "$TARGET_DIR" -type f -not -path "*/.git/*" | head -20
echo ""
echo "To build:"
echo "  cd $TARGET_DIR"
echo "  make"
echo ""
echo "To clean:"
echo "  make clean"
