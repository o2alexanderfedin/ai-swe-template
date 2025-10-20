#!/bin/bash
# AI SWE Template Setup Script
# Version: 1.0
# Description: Interactive setup wizard for initializing AI SWE methodology

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Function to print header
print_header() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   AI SWE Template Setup Wizard        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to validate non-empty input
validate_not_empty() {
    local input="$1"
    local field_name="$2"

    while [ -z "$input" ]; do
        print_error "$field_name cannot be empty"
        read -p "$field_name: " input
    done

    echo "$input"
}

# Function to validate language selection
validate_language() {
    local lang="$1"

    case $lang in
        python|javascript|typescript|go|rust)
            echo "$lang"
            ;;
        *)
            print_warning "Invalid language. Using 'python' as default."
            echo "python"
            ;;
    esac
}

# Function to detect project mode
detect_mode() {
    if [ -d ".git" ] && [ -f "README.md" ] && [ ! -f "TEMPLATE_STRATEGY.md" ]; then
        echo "existing"
    else
        echo "new"
    fi
}

# Main setup function
main() {
    print_header

    # Detect mode
    MODE=$(detect_mode)

    if [ "$MODE" = "existing" ]; then
        print_warning "Detected: Existing project"
        print_info "This will add AI SWE methodology to your existing project"
        echo ""
        read -p "Continue? (y/n): " CONTINUE
        if [ "$CONTINUE" != "y" ]; then
            print_error "Setup cancelled"
            exit 0
        fi
    else
        print_success "Mode: New project"
    fi

    echo ""
    print_info "Please answer the following questions to customize your project:"
    echo ""

    # Gather project information
    read -p "Project name: " PROJECT_NAME
    PROJECT_NAME=$(validate_not_empty "$PROJECT_NAME" "Project name")

    read -p "Brief description: " PROJECT_DESC
    PROJECT_DESC=$(validate_not_empty "$PROJECT_DESC" "Project description")

    read -p "Primary language (python/javascript/typescript/go/rust): " LANG
    LANG=$(validate_language "$LANG")

    read -p "Framework (optional, e.g., FastAPI, Django, Express, Next.js): " FRAMEWORK
    if [ -z "$FRAMEWORK" ]; then
        FRAMEWORK="None"
    fi

    read -p "Use AI/LLM features? (y/n): " USE_AI
    if [ "$USE_AI" = "y" ]; then
        AI_FEATURES="Yes"
    else
        AI_FEATURES="No"
    fi

    read -p "Database (postgresql/mongodb/redis/none): " DATABASE
    if [ -z "$DATABASE" ]; then
        DATABASE="none"
    fi

    echo ""
    print_info "Setting up project with following configuration:"
    echo "  Project: $PROJECT_NAME"
    echo "  Description: $PROJECT_DESC"
    echo "  Language: $LANG"
    echo "  Framework: $FRAMEWORK"
    echo "  AI Features: $AI_FEATURES"
    echo "  Database: $DATABASE"
    echo ""

    # Language-specific setup
    print_info "Applying language-specific configuration..."

    if [ -d "templates/$LANG" ]; then
        print_success "Using $LANG template"

        # Copy language-specific tech_stack.md if exists
        if [ -f "templates/$LANG/tech_stack.md" ]; then
            cp "templates/$LANG/tech_stack.md" ".memory_bank/tech_stack.md"
            print_success "Applied $LANG tech stack"
        fi

        # Copy language-specific workflows if exist
        if [ -d "templates/$LANG/workflows" ]; then
            cp -r templates/$LANG/workflows/* .memory_bank/workflows/ 2>/dev/null || true
            print_success "Applied $LANG workflows"
        fi
    else
        print_warning "Using generic template for $LANG"
    fi

    # Replace placeholders in Memory Bank files
    print_info "Customizing Memory Bank files..."

    # Detect OS for sed compatibility
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        SED_CMD="sed -i ''"
    else
        # Linux
        SED_CMD="sed -i"
    fi

    # Replace placeholders in all .md files in .memory_bank
    find .memory_bank -type f -name "*.md" -print0 | while IFS= read -r -d '' file; do
        # Create temporary file
        temp_file="${file}.tmp"

        # Perform replacements
        sed \
            -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
            -e "s/{{LANGUAGE}}/$LANG/g" \
            -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
            -e "s/{{AI_FEATURES}}/$AI_FEATURES/g" \
            -e "s/{{DATABASE}}/$DATABASE/g" \
            "$file" > "$temp_file"

        # Replace original file
        mv "$temp_file" "$file"
    done

    print_success "Memory Bank customized"

    # Update CLAUDE.md if it exists
    if [ -f "CLAUDE.md" ]; then
        print_info "Customizing CLAUDE.md..."

        temp_file="CLAUDE.md.tmp"
        sed \
            -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
            -e "s/{{LANGUAGE}}/$LANG/g" \
            -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
            "CLAUDE.md" > "$temp_file"

        mv "$temp_file" "CLAUDE.md"
        print_success "CLAUDE.md customized"
    fi

    # Remove template-specific files
    print_info "Cleaning up template files..."

    rm -f TEMPLATE_STRATEGY.md
    rm -f AI_SWE_article.md
    rm -f AI_SWE_SETUP_VALIDATION.md
    rm -f IMPLEMENTATION_PLAN.md
    rm -f SetupMemoryBank-prompt.md
    rm -rf templates/

    print_success "Template files removed"

    # Git operations
    if command -v git &> /dev/null; then
        if [ "$MODE" = "new" ]; then
            print_info "Initializing git repository..."

            # Initialize git if not already initialized
            if [ ! -d ".git" ]; then
                git init
                print_success "Git initialized"
            fi

            # Try to initialize git flow (optional)
            if command -v git-flow &> /dev/null; then
                print_info "Initializing git flow..."
                git flow init -d 2>/dev/null || print_warning "Git flow initialization skipped"
            fi

            # Create initial commit
            print_info "Creating initial commit..."
            git add .
            git commit -m "feat: Initialize project with AI SWE methodology

Project: $PROJECT_NAME
Language: $LANG
Framework: $FRAMEWORK

Setup includes:
- Memory Bank system
- Custom slash commands
- Three-phase workflow
- Complete documentation

Generated with AI SWE Template" || print_warning "Commit failed - may already exist"

            print_success "Git repository initialized"
        else
            print_info "Adding AI SWE methodology to existing project..."

            # Stage AI SWE files
            git add .memory_bank .claude CLAUDE.md 2>/dev/null || true

            # Create commit
            git commit -m "feat: Add AI SWE methodology

Added AI Software Engineering development infrastructure:
- Memory Bank system (.memory_bank/)
- Custom slash commands (.claude/commands/)
- Development workflows
- Documentation standards

Generated with AI SWE Template" || print_warning "Commit failed - no changes or already committed"

            print_success "AI SWE methodology added to project"
        fi
    else
        print_warning "Git not found - skipping git operations"
    fi

    # Print success message and next steps
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          Setup Complete! 🎉            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""

    print_success "Your project is now set up with AI SWE methodology!"
    echo ""

    print_info "Next steps:"
    echo "  1. Review and customize .memory_bank/product_brief.md"
    echo "  2. Update .memory_bank/tech_stack.md with specific dependencies"
    echo "  3. Add your current tasks to .memory_bank/current_tasks.md"
    echo "  4. Review CLAUDE.md for project-specific instructions"

    if command -v claude &> /dev/null; then
        echo "  5. Run: claude /refresh_context (to load Memory Bank in Claude Code)"
    else
        echo "  5. Open project in Claude Code and use /refresh_context command"
    fi

    echo ""
    print_info "Documentation:"
    echo "  - Quick Start: cat QUICK_START.md (if available)"
    echo "  - Full Guide: cat README.md"
    echo "  - Memory Bank: cat .memory_bank/README.md"
    echo ""

    print_success "Happy coding with AI assistance!"
    echo ""
}

# Run main function
main "$@"
