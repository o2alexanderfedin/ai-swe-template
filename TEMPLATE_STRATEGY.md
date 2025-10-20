# AI SWE Template Repository Strategy

## Executive Summary

Transform this repository into a reusable GitHub Template with smart setup scripts, enabling one-click initialization of AI Software Engineering methodology for any project (new or existing).

**Target**: 2-minute setup for 80% of users, with full customization available for power users.

---

## 🎯 Recommended Approach: GitHub Template + Smart Setup Script

### Why This Works Best

1. ✅ **Familiar Pattern** - Developers know GitHub templates
2. ✅ **Zero Submodule Complexity** - Direct file ownership
3. ✅ **Works for New AND Existing Projects**
4. ✅ **One-Click Start** - Literally
5. ✅ **Full Customization** - Users own everything
6. ✅ **No Magic** - Transparent file structure
7. ✅ **Team-Friendly** - No special knowledge needed

---

## 📋 Three Usage Modes

### Mode 1: New Project (80% of users)

**GitHub UI Workflow:**
```bash
# 1. Click "Use this template" button on GitHub
# 2. Name your new repository
# 3. Clone it locally
cd my-new-project
./scripts/setup.sh --new

# Interactive setup asks:
# - Project name?
# - Project description?
# - Primary language? (Python/JavaScript/Go/Rust)
# - Framework? (FastAPI/Django/Express/Next.js/etc.)
# - Use AI/LLM features? [y/n]
# - Database? (PostgreSQL/MongoDB/None)
#
# Automatically:
# - Updates all Memory Bank files with project details
# - Customizes CLAUDE.md
# - Selects appropriate tech stack template
# - Sets up git flow
# - Creates initial commit
# - Removes template-specific files
```

**One-Liner (Advanced):**
```bash
curl -sSL https://raw.githubusercontent.com/user/ai-swe-template/main/scripts/quick-start.sh | bash -s my-project
```

### Mode 2: Existing Project (15% of users)

```bash
cd my-existing-project

# Download and run setup
curl -sSL https://setup.ai-swe.dev/install | bash

# Or manual:
wget https://raw.githubusercontent.com/user/ai-swe-template/main/scripts/setup-existing.sh
chmod +x setup-existing.sh
./setup-existing.sh

# Script intelligently:
# - Detects existing structure
# - Asks what to preserve
# - Merges .gitignore intelligently
# - Adds Memory Bank without conflicts
# - Sets up .claude/commands/
# - Updates or creates CLAUDE.md
# - Preserves existing git history
# - Creates "feat: Add AI SWE methodology" commit
```

### Mode 3: Cookiecutter (5% power users)

```bash
cookiecutter gh:user/ai-swe-template

# Full interactive customization:
# Project name, language, framework, features, etc.
# Generates fully tailored template
```

---

## 🏗️ Repository Structure

### Current Template Repository

```
ai-swe-template/
├── .github/
│   ├── workflows/
│   │   └── template-sync.yml        # Optional: auto-update for users
│   └── ISSUE_TEMPLATE/
├── .memory_bank/
│   ├── README.md                    # Template with {{VARIABLES}}
│   ├── product_brief.md             # Template with {{VARIABLES}}
│   ├── tech_stack.md                # Template with {{VARIABLES}}
│   ├── current_tasks.md             # Template
│   ├── patterns/
│   ├── guides/
│   ├── workflows/
│   └── specs/
├── .claude/
│   └── commands/                    # Standard commands
├── scripts/
│   ├── setup.sh                     # Main setup script
│   ├── setup-new.sh                 # For new projects
│   ├── setup-existing.sh            # For existing projects
│   ├── quick-start.sh               # One-liner setup
│   └── update-template.sh           # Pull improvements
├── templates/                       # Language-specific variants
│   ├── python/
│   │   ├── tech_stack.md
│   │   └── workflows/
│   ├── javascript/
│   │   ├── tech_stack.md
│   │   └── workflows/
│   ├── go/
│   └── rust/
├── cookiecutter.json                # For cookiecutter users
├── CLAUDE.md                        # Template version
├── README.md                        # Template usage guide
├── TEMPLATE_STRATEGY.md             # This document
├── PROJECT_NOTES.md                 # Template documentation
└── package.json / pyproject.toml    # Optional: for script deps
```

---

## 🔧 Setup Script Specification

### Core Features

```bash
#!/bin/bash
# scripts/setup.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   AI SWE Template Setup Wizard        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Detect mode
if [ -d ".git" ] && [ -f "README.md" ]; then
    MODE="existing"
    echo -e "${YELLOW}Detected: Existing project${NC}"
else
    MODE="new"
    echo -e "${GREEN}Mode: New project${NC}"
fi

# Interactive prompts with validation
read -p "Project name: " PROJECT_NAME
while [ -z "$PROJECT_NAME" ]; do
    echo -e "${RED}Project name cannot be empty${NC}"
    read -p "Project name: " PROJECT_NAME
done

read -p "Brief description: " PROJECT_DESC
read -p "Primary language (python/javascript/go/rust): " LANG
read -p "Framework (optional, e.g., FastAPI, Express): " FRAMEWORK

# Language-specific setup
case $LANG in
    python)
        echo -e "${GREEN}Setting up Python project...${NC}"
        cp templates/python/tech_stack.md .memory_bank/tech_stack.md
        cp -r templates/python/workflows/* .memory_bank/workflows/
        ;;
    javascript|typescript)
        echo -e "${GREEN}Setting up JavaScript/TypeScript project...${NC}"
        cp templates/javascript/tech_stack.md .memory_bank/tech_stack.md
        cp -r templates/javascript/workflows/* .memory_bank/workflows/
        ;;
    go)
        echo -e "${GREEN}Setting up Go project...${NC}"
        cp templates/go/tech_stack.md .memory_bank/tech_stack.md
        ;;
    rust)
        echo -e "${GREEN}Setting up Rust project...${NC}"
        cp templates/rust/tech_stack.md .memory_bank/tech_stack.md
        ;;
    *)
        echo -e "${YELLOW}Using generic template${NC}"
        ;;
esac

# Replace placeholders
echo -e "${GREEN}Customizing Memory Bank...${NC}"
find .memory_bank -type f -name "*.md" -exec sed -i.bak \
    -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
    -e "s/{{LANGUAGE}}/$LANG/g" \
    -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
    {} \;

# Clean up backup files
find .memory_bank -name "*.bak" -delete

# Update CLAUDE.md
sed -i.bak \
    -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" \
    CLAUDE.md && rm CLAUDE.md.bak

# Remove template-specific files
rm -f TEMPLATE_STRATEGY.md
rm -f AI_SWE_article.md
rm -f AI_SWE_SETUP_VALIDATION.md
rm -f IMPLEMENTATION_PLAN.md
rm -f SetupMemoryBank-prompt.md
rm -rf templates/

# Git setup
if [ "$MODE" = "new" ]; then
    echo -e "${GREEN}Initializing git flow...${NC}"
    git flow init -d 2>/dev/null || true
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

🤖 Generated with AI SWE Template
" || true
else
    echo -e "${GREEN}Adding AI SWE methodology to existing project...${NC}"
    git add .memory_bank .claude CLAUDE.md
    git commit -m "feat: Add AI SWE methodology

Added AI Software Engineering development infrastructure:
- Memory Bank system
- Custom slash commands
- Development workflows
- Documentation standards

🤖 Generated with AI SWE Template
" || true
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Setup Complete! 🎉            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Review .memory_bank/product_brief.md"
echo "  2. Customize .memory_bank/tech_stack.md"
echo "  3. Update .memory_bank/current_tasks.md with your tasks"
echo "  4. Run: /refresh_context (in Claude Code)"
echo ""
echo "Quick start guide: cat QUICK_START.md"
echo "Documentation: cat README.md"
```

---

## 📝 Template Variables

### Files with Placeholders

All files should use these variables:

```markdown
# In .memory_bank/product_brief.md
Project Name: {{PROJECT_NAME}}
Description: {{PROJECT_DESC}}

# In .memory_bank/tech_stack.md
Primary Language: {{LANGUAGE}}
Framework: {{FRAMEWORK}}

# In CLAUDE.md
Project: {{PROJECT_NAME}}
Type: {{PROJECT_TYPE}}
Language: {{LANGUAGE}}
```

---

## 🔄 Handling Template Updates

### Option A: One-Time Template (Recommended)
- User clicks template, gets files
- Full ownership, modify freely
- No ongoing sync complexity
- **Best for: 90% of users**

### Option B: Git Remote Sync (Manual)
```bash
# Add template as remote
git remote add template https://github.com/user/ai-swe-template.git
git fetch template

# Pull improvements when desired
git merge template/main --allow-unrelated-histories
# Or cherry-pick specific commits
```
- **Best for: Teams wanting occasional updates**

### Option C: GitHub Action (Automated)
```yaml
# .github/workflows/template-sync.yml
name: Template Sync
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly Sunday
  workflow_dispatch:     # Manual trigger

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Sync template
        run: |
          git remote add template https://github.com/user/ai-swe-template.git
          git fetch template
          git merge template/main --allow-unrelated-histories || true
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          title: "chore: Sync AI SWE template updates"
          body: "Automated template synchronization"
          branch: template-sync
```
- Creates PR with updates weekly
- User reviews and merges
- **Best for: Teams wanting continuous improvements**

---

## 🎨 Customization Levels

### Level 1: Minimal (2 minutes)
```bash
./scripts/setup.sh
# Answer 4-5 questions
# Done!
```
- Uses template as-is
- Only updates project name/description
- **Good for: Quick prototypes**

### Level 2: Standard (15 minutes)
- Run setup script
- Review and customize:
  - `.memory_bank/product_brief.md`
  - `.memory_bank/tech_stack.md`
  - `.memory_bank/current_tasks.md`
- **Good for: Most production projects**

### Level 3: Full Custom (1-2 hours)
- Run setup script
- Add industry-specific patterns to `.memory_bank/patterns/`
- Create custom commands in `.claude/commands/`
- Build domain-specific workflows
- Add team conventions to guides
- **Good for: Large teams, specialized domains**

---

## 🚀 Implementation Roadmap

### Phase 1: Core Template (Week 1)
- [x] Current repository with all features
- [ ] Add placeholder variables to all files
- [ ] Create basic `scripts/setup.sh`
- [ ] Test setup script on fresh clone
- [ ] Update README.md with template usage
- [ ] Mark repository as GitHub Template

### Phase 2: Language Variants (Week 2)
- [ ] Create `templates/python/` variant
- [ ] Create `templates/javascript/` variant
- [ ] Create `templates/go/` variant
- [ ] Create `templates/rust/` variant
- [ ] Test each variant

### Phase 3: Advanced Features (Week 3)
- [ ] Create `scripts/setup-existing.sh`
- [ ] Create `scripts/quick-start.sh`
- [ ] Add cookiecutter.json support
- [ ] Create template-sync GitHub Action
- [ ] Add script tests

### Phase 4: Documentation & Polish (Week 4)
- [ ] Comprehensive README
- [ ] Video walkthrough
- [ ] Example projects using template
- [ ] Blog post / announcement
- [ ] Gather user feedback

---

## 📊 Success Metrics

### Usability
- **Time to setup**: < 2 minutes for 80% of users
- **Documentation clarity**: Users don't need external help
- **Error rate**: < 5% of setups fail

### Adoption
- **Template uses**: Track via GitHub
- **User feedback**: Issues, discussions
- **Community contributions**: PRs to improve template

---

## 🎯 Key Design Principles

1. **Convention over Configuration** - Sensible defaults
2. **Progressive Enhancement** - Start simple, customize as needed
3. **Transparent Magic** - No hidden behavior
4. **Fail-Safe** - Preserve user data, never destructive
5. **Documentation First** - Every feature explained
6. **Community Driven** - Open to improvements

---

## 🔧 Technical Decisions

### Why Not Submodules?
- Complex for average users
- Update conflicts
- Directory structure constraints
- Team coordination overhead

### Why Not Yeoman/Generator?
- Extra dependency
- JavaScript-centric
- Template approach more universal

### Why Not Just Fork?
- Template button is one-click
- GitHub tracks template usage
- Cleaner than fork for new projects

---

## 📝 Alternative Approaches Considered

### Approach: Container with Submodule
```
workspace/
├── infrastructure/  (this template)
└── project/        (user's project)
```
**Rejected because:**
- Feels backwards
- Git operations in subdirectory
- CI/CD complexity
- Publishing/sharing unclear

### Approach: NPM/PyPI Package
```bash
npm install -g @ai-swe/template
ai-swe init my-project
```
**Rejected because:**
- Language-specific
- Requires package installation
- Less discoverable than GitHub

---

## 🎬 Next Immediate Actions

1. **Create placeholder variables** in current files
2. **Write setup.sh script** with basic functionality
3. **Test on fresh clone** to validate approach
4. **Update README.md** with template usage instructions
5. **Mark as GitHub Template** in repository settings

---

## 📚 References

- [GitHub Template Repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)
- [Cookiecutter Documentation](https://cookiecutter.readthedocs.io/)
- [Create React App Approach](https://create-react-app.dev/)
- [Vite Template System](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)

---

## 💡 Future Enhancements

### Phase 5+: Advanced Features
- [ ] Web UI for template customization
- [ ] VS Code extension for setup
- [ ] Pre-built industry templates (FinTech, HealthTech)
- [ ] Multi-language support in Memory Bank
- [ ] Team workspace mode (monorepo)
- [ ] Integration marketplace (Jira, Linear, etc.)

---

**Version**: 1.0
**Status**: Planning
**Last Updated**: 2025-10-19
**Owner**: AI SWE Template Project
