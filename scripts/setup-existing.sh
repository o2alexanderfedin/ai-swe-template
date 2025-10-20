#!/bin/bash
# AI SWE Template - Setup for Existing Projects
# This script adds AI SWE methodology to an existing project

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   AI SWE Template - Existing Project  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Detect project directory
PROJECT_DIR=$(pwd)
echo -e "${BLUE}Project directory: $PROJECT_DIR${NC}"

# Verify this is an existing project
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: This doesn't appear to be a git repository${NC}"
    echo -e "${YELLOW}Please run this script from your project root, or initialize git first:${NC}"
    echo "  git init"
    exit 1
fi

# Check if already has Memory Bank
if [ -d ".memory_bank" ]; then
    echo -e "${YELLOW}Warning: .memory_bank directory already exists${NC}"
    read -p "Do you want to overwrite it? (y/N): " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        echo -e "${RED}Aborted.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Backing up existing .memory_bank to .memory_bank.backup${NC}"
    mv .memory_bank .memory_bank.backup
fi

# Detect project language
echo ""
echo -e "${BLUE}Detecting project language...${NC}"

DETECTED_LANG=""
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    DETECTED_LANG="python"
    echo -e "${GREEN}Detected: Python${NC}"
elif [ -f "package.json" ]; then
    DETECTED_LANG="javascript"
    echo -e "${GREEN}Detected: JavaScript/TypeScript${NC}"
elif [ -f "go.mod" ]; then
    DETECTED_LANG="go"
    echo -e "${GREEN}Detected: Go${NC}"
elif [ -f "Cargo.toml" ]; then
    DETECTED_LANG="rust"
    echo -e "${GREEN}Detected: Rust${NC}"
else
    echo -e "${YELLOW}Could not auto-detect language${NC}"
fi

# Interactive prompts
echo ""
echo -e "${BLUE}Project Configuration${NC}"
read -p "Project name (detected from directory): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$PROJECT_DIR")
    echo -e "${YELLOW}Using: $PROJECT_NAME${NC}"
fi

read -p "Brief description: " PROJECT_DESC
while [ -z "$PROJECT_DESC" ]; do
    echo -e "${RED}Description cannot be empty${NC}"
    read -p "Brief description: " PROJECT_DESC
done

read -p "Primary language [$DETECTED_LANG]: " LANG
if [ -z "$LANG" ]; then
    LANG=$DETECTED_LANG
fi

read -p "Framework (optional): " FRAMEWORK

# Download template files
echo ""
echo -e "${GREEN}Downloading AI SWE Template files...${NC}"

TEMPLATE_URL="https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main"

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download Memory Bank structure
echo -e "${BLUE}Setting up Memory Bank...${NC}"
mkdir -p .memory_bank/{patterns,guides,workflows,specs}

# Download core Memory Bank files
curl -sSL "$TEMPLATE_URL/.memory_bank/README.md" -o "$TMP_DIR/README.md"
curl -sSL "$TEMPLATE_URL/.memory_bank/product_brief.md" -o "$TMP_DIR/product_brief.md"
curl -sSL "$TEMPLATE_URL/.memory_bank/current_tasks.md" -o "$TMP_DIR/current_tasks.md"

# Download patterns
curl -sSL "$TEMPLATE_URL/.memory_bank/patterns/api_standards.md" -o .memory_bank/patterns/api_standards.md
curl -sSL "$TEMPLATE_URL/.memory_bank/patterns/error_handling.md" -o .memory_bank/patterns/error_handling.md

# Download guides
curl -sSL "$TEMPLATE_URL/.memory_bank/guides/coding_standards.md" -o .memory_bank/guides/coding_standards.md
curl -sSL "$TEMPLATE_URL/.memory_bank/guides/testing_strategy.md" -o .memory_bank/guides/testing_strategy.md

# Download workflows
curl -sSL "$TEMPLATE_URL/.memory_bank/workflows/bug_fix.md" -o .memory_bank/workflows/bug_fix.md
curl -sSL "$TEMPLATE_URL/.memory_bank/workflows/new_feature.md" -o .memory_bank/workflows/new_feature.md
curl -sSL "$TEMPLATE_URL/.memory_bank/workflows/code_review.md" -o .memory_bank/workflows/code_review.md
curl -sSL "$TEMPLATE_URL/.memory_bank/workflows/self_review.md" -o .memory_bank/workflows/self_review.md
curl -sSL "$TEMPLATE_URL/.memory_bank/workflows/refactoring.md" -o .memory_bank/workflows/refactoring.md

# Download language-specific tech_stack.md
case $LANG in
    python)
        echo -e "${GREEN}Using Python template...${NC}"
        curl -sSL "$TEMPLATE_URL/templates/python/tech_stack.md" -o "$TMP_DIR/tech_stack.md"
        ;;
    javascript|typescript)
        echo -e "${GREEN}Using JavaScript/TypeScript template...${NC}"
        curl -sSL "$TEMPLATE_URL/templates/javascript/tech_stack.md" -o "$TMP_DIR/tech_stack.md"
        ;;
    go)
        echo -e "${GREEN}Using Go template...${NC}"
        curl -sSL "$TEMPLATE_URL/templates/go/tech_stack.md" -o "$TMP_DIR/tech_stack.md"
        ;;
    rust)
        echo -e "${GREEN}Using Rust template...${NC}"
        curl -sSL "$TEMPLATE_URL/templates/rust/tech_stack.md" -o "$TMP_DIR/tech_stack.md"
        ;;
    *)
        echo -e "${YELLOW}Using generic template${NC}"
        curl -sSL "$TEMPLATE_URL/.memory_bank/tech_stack.md" -o "$TMP_DIR/tech_stack.md"
        ;;
esac

# Replace placeholders in downloaded files
echo -e "${BLUE}Customizing for your project...${NC}"

for file in "$TMP_DIR"/*.md; do
    if [ -f "$file" ]; then
        sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
            -e "s/{{LANGUAGE}}/$LANG/g" \
            -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
            "$file" > ".memory_bank/$(basename "$file")"
    fi
done

# Set up .claude/commands/
echo -e "${BLUE}Setting up custom commands...${NC}"
mkdir -p .claude/commands

curl -sSL "$TEMPLATE_URL/.claude/commands/refresh_context.md" -o .claude/commands/refresh_context.md
curl -sSL "$TEMPLATE_URL/.claude/commands/m_bug.md" -o .claude/commands/m_bug.md
curl -sSL "$TEMPLATE_URL/.claude/commands/m_feature.md" -o .claude/commands/m_feature.md
curl -sSL "$TEMPLATE_URL/.claude/commands/m_review.md" -o .claude/commands/m_review.md
curl -sSL "$TEMPLATE_URL/.claude/commands/m_refactor.md" -o .claude/commands/m_refactor.md

# Handle CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    echo -e "${YELLOW}CLAUDE.md already exists${NC}"
    read -p "Do you want to replace it? (y/N): " REPLACE_CLAUDE
    if [[ "$REPLACE_CLAUDE" =~ ^[Yy]$ ]]; then
        mv CLAUDE.md CLAUDE.md.backup
        curl -sSL "$TEMPLATE_URL/CLAUDE.md" -o CLAUDE.md
        sed -i.bak \
            -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
            -e "s/{{LANGUAGE}}/$LANG/g" \
            -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
            CLAUDE.md && rm CLAUDE.md.bak
        echo -e "${GREEN}Original backed up to CLAUDE.md.backup${NC}"
    else
        echo -e "${YELLOW}Skipping CLAUDE.md${NC}"
    fi
else
    curl -sSL "$TEMPLATE_URL/CLAUDE.md" -o CLAUDE.md
    sed -i.bak \
        -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
        -e "s/{{LANGUAGE}}/$LANG/g" \
        -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
        CLAUDE.md && rm CLAUDE.md.bak
fi

# Merge .gitignore intelligently
if [ -f ".gitignore" ]; then
    echo -e "${BLUE}Merging .gitignore...${NC}"

    # Add AI SWE specific entries if not present
    if ! grep -q ".memory_bank/current_tasks.md" .gitignore 2>/dev/null; then
        echo "" >> .gitignore
        echo "# AI SWE Memory Bank - Don't ignore the structure, only volatile files" >> .gitignore
        echo "# .memory_bank/current_tasks.md  # Uncomment if tasks are personal" >> .gitignore
    fi
else
    echo -e "${YELLOW}No .gitignore found, creating one${NC}"
    cat > .gitignore << 'EOF'
# AI SWE Memory Bank
# Most files should be committed to share team knowledge
# Uncomment to make tasks personal:
# .memory_bank/current_tasks.md

# OS
.DS_Store
Thumbs.db

# Editors
.vscode/
.idea/
*.swp
*.swo
*~

# Environment
.env
.env.local
EOF
fi

# Git commit
echo ""
echo -e "${GREEN}Creating git commit...${NC}"

git add .memory_bank .claude CLAUDE.md .gitignore

if git diff --staged --quiet; then
    echo -e "${YELLOW}No changes to commit${NC}"
else
    git commit -m "feat: Add AI SWE methodology

Added AI Software Engineering development infrastructure to existing project:
- Memory Bank system (.memory_bank/)
- Custom slash commands (.claude/commands/)
- Development workflows
- Documentation standards

Project: $PROJECT_NAME
Language: $LANG
Framework: $FRAMEWORK

🤖 Generated with AI SWE Template
https://github.com/o2alexanderfedin/ai-swe-template
" || echo -e "${YELLOW}Commit created (or already exists)${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      AI SWE Setup Complete! 🎉        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Your project now has:"
echo "  ✅ Memory Bank system (.memory_bank/)"
echo "  ✅ Custom slash commands (.claude/commands/)"
echo "  ✅ Development workflows"
echo "  ✅ Documentation standards"
echo ""
echo "Next steps:"
echo "  1. Review .memory_bank/product_brief.md"
echo "  2. Customize .memory_bank/tech_stack.md for your stack"
echo "  3. Update .memory_bank/current_tasks.md with your tasks"
echo "  4. In Claude Code, run: /refresh_context"
echo ""
echo "Documentation:"
echo "  - Quick start: https://github.com/o2alexanderfedin/ai-swe-template#readme"
echo "  - Memory Bank guide: cat .memory_bank/README.md"
echo ""
echo -e "${BLUE}Happy coding with AI assistance! 🤖${NC}"
