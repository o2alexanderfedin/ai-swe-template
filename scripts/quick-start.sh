#!/bin/bash
# AI SWE Template - Quick Start
# One-liner installer for new projects
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | bash -s my-project
#
# Or with all options:
#   curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | bash -s my-project --lang python --framework fastapi

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   AI SWE Template - Quick Start       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
PROJECT_NAME=""
LANG=""
FRAMEWORK=""
DESC=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --lang)
            LANG="$2"
            shift 2
            ;;
        --framework)
            FRAMEWORK="$2"
            shift 2
            ;;
        --desc)
            DESC="$2"
            shift 2
            ;;
        --help)
            echo "Usage: quick-start.sh PROJECT_NAME [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --lang LANGUAGE       Primary language (python/javascript/go/rust)"
            echo "  --framework FRAMEWORK Framework name (fastapi/express/gin/axum/etc)"
            echo "  --desc DESCRIPTION    Project description"
            echo "  --help                Show this help message"
            echo ""
            echo "Examples:"
            echo "  quick-start.sh my-api --lang python --framework fastapi"
            echo "  quick-start.sh my-app --lang javascript --framework express"
            echo ""
            echo "One-liner install:"
            echo "  curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | bash -s my-project"
            exit 0
            ;;
        *)
            if [ -z "$PROJECT_NAME" ]; then
                PROJECT_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Validate project name
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    echo ""
    echo "Usage: $0 PROJECT_NAME [OPTIONS]"
    echo "Run with --help for more information"
    exit 1
fi

# Check if directory already exists
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Directory '$PROJECT_NAME' already exists${NC}"
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    exit 1
fi

# Clone template repository
echo -e "${BLUE}Cloning AI SWE Template...${NC}"
git clone --depth 1 https://github.com/o2alexanderfedin/ai-swe-template.git "$PROJECT_NAME"

cd "$PROJECT_NAME"

# Remove git history
echo -e "${BLUE}Initializing fresh git repository...${NC}"
rm -rf .git
git init -q
git checkout -b main -q

# Initialize git flow
if command -v git-flow &> /dev/null; then
    echo -e "${BLUE}Initializing git flow...${NC}"
    git flow init -d &> /dev/null || true
fi

# Prepare non-interactive setup if args provided
if [ -n "$LANG" ] || [ -n "$FRAMEWORK" ] || [ -n "$DESC" ]; then
    echo -e "${BLUE}Configuring project...${NC}"

    # Use defaults if not provided
    if [ -z "$DESC" ]; then
        DESC="A new project built with AI SWE methodology"
    fi

    # Replace placeholders directly
    find .memory_bank -type f -name "*.md" -exec sed -i.bak \
        -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{PROJECT_DESC}}/$DESC/g" \
        -e "s/{{LANGUAGE}}/$LANG/g" \
        -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
        {} \;

    sed -i.bak \
        -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{PROJECT_DESC}}/$DESC/g" \
        -e "s/{{LANGUAGE}}/$LANG/g" \
        -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
        CLAUDE.md

    # Copy language-specific template
    if [ -n "$LANG" ] && [ -f "templates/$LANG/tech_stack.md" ]; then
        cp "templates/$LANG/tech_stack.md" .memory_bank/tech_stack.md
    fi

    # Clean up backup files
    find .memory_bank -name "*.bak" -delete
    rm -f CLAUDE.md.bak

    # Remove template-specific files
    rm -f TEMPLATE_STRATEGY.md AI_SWE_article.md PROJECT_NOTES.md
    rm -rf templates/

    # Initial commit
    git add .
    git commit -q -m "feat: Initialize project with AI SWE methodology

Project: $PROJECT_NAME
Language: $LANG
Framework: $FRAMEWORK

🤖 Generated with AI SWE Template
https://github.com/o2alexanderfedin/due_diligence_bot
"

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       Project Created! 🎉             ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Project: $PROJECT_NAME${NC}"
    echo -e "${BLUE}Language: $LANG${NC}"
    echo -e "${BLUE}Framework: $FRAMEWORK${NC}"
    echo ""
    echo "Next steps:"
    echo "  cd $PROJECT_NAME"
    echo "  # Review and customize:"
    echo "  cat .memory_bank/product_brief.md"
    echo "  cat .memory_bank/tech_stack.md"
    echo "  # Start developing with Claude Code:"
    echo "  claude"
    echo "  # Then run: /refresh_context"
else
    # Interactive setup
    echo -e "${BLUE}Running interactive setup...${NC}"
    echo ""

    if [ -x "./scripts/setup.sh" ]; then
        ./scripts/setup.sh
    else
        echo -e "${YELLOW}Warning: setup.sh not found or not executable${NC}"
        echo -e "${YELLOW}Please configure manually${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Quick start complete!${NC}"
echo ""
echo "Get started:"
echo "  cd $PROJECT_NAME"
echo "  claude  # Start Claude Code"
echo ""
echo "Documentation:"
echo "  https://github.com/o2alexanderfedin/due_diligence_bot#readme"
