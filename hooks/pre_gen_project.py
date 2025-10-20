#!/usr/bin/env python3
"""
Pre-generation hook for AI SWE Template cookiecutter.
Validates input before generating project.
"""

import re
import sys

PROJECT_NAME = "{{ cookiecutter.project_name }}"
PROJECT_SLUG = "{{ cookiecutter.project_slug }}"

# Validation patterns
SLUG_REGEX = r'^[a-z][a-z0-9_]+$'

def validate_project_slug():
    """Validate project slug format."""
    if not re.match(SLUG_REGEX, PROJECT_SLUG):
        print(f"ERROR: '{PROJECT_SLUG}' is not a valid project slug.")
        print("Project slug must:")
        print("  - Start with a lowercase letter")
        print("  - Contain only lowercase letters, numbers, and underscores")
        print(f"  - Match pattern: {SLUG_REGEX}")
        sys.exit(1)

def validate_project_name():
    """Validate project name is not empty."""
    if not PROJECT_NAME or PROJECT_NAME.strip() == "":
        print("ERROR: Project name cannot be empty")
        sys.exit(1)

if __name__ == "__main__":
    validate_project_name()
    validate_project_slug()
    print(f"✓ Generating project: {PROJECT_NAME}")
