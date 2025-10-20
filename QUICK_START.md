# Quick Start Guide - AI SWE Template

Get started with AI-assisted development in **2 minutes**.

---

## ⚡ The Fastest Path

### New Project (One Command)

```bash
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-project --lang python --framework fastapi
```

That's it! Your project is ready with:
- ✅ Complete Memory Bank system
- ✅ Custom slash commands
- ✅ Language-specific configuration
- ✅ Git repository initialized

### Existing Project (Three Commands)

```bash
cd your-project
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/setup-existing.sh -o setup.sh
chmod +x setup.sh && ./setup.sh
```

Answer a few questions, and you're done!

---

## 📋 Installation Methods

Choose the method that fits your workflow:

| Method | Best For | Time | Customization |
|--------|----------|------|---------------|
| **One-liner** | Quick prototypes, tutorials | 2 min | Minimal |
| **GitHub Template** | New projects | 3 min | Standard |
| **Existing Project** | Retrofitting AI SWE | 5 min | Adaptive |
| **Cookiecutter** | Power users, teams | 10 min | Full |

### Method 1: One-Liner

**Non-Interactive (fastest):**
```bash
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-api --lang python --framework fastapi --desc "My awesome API"
```

**Interactive:**
```bash
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-api
# Runs setup.sh interactively
```

**All Options:**
```bash
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s PROJECT_NAME \
    --lang LANGUAGE \           # python, javascript, go, rust
    --framework FRAMEWORK \      # fastapi, express, gin, axum, etc.
    --desc "DESCRIPTION"
```

### Method 2: GitHub Template

1. **Click "Use this template"** on GitHub
2. **Clone** your new repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/your-project.git
   cd your-project
   ```
3. **Run setup:**
   ```bash
   ./scripts/setup.sh
   ```
4. **Answer questions:**
   - Project name
   - Description
   - Language (python/javascript/go/rust)
   - Framework (optional)
   - Database (optional)

Done! Start coding with `/refresh_context` in Claude Code.

### Method 3: Existing Project

1. **Navigate to your project:**
   ```bash
   cd your-existing-project
   ```

2. **Download and run setup:**
   ```bash
   curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/setup-existing.sh -o setup.sh
   chmod +x setup.sh
   ./setup.sh
   ```

3. **Script will:**
   - Auto-detect your language
   - Download template files
   - Merge intelligently with existing config
   - Create commit with AI SWE methodology

### Method 4: Cookiecutter (Power Users)

1. **Install cookiecutter:**
   ```bash
   pip install cookiecutter
   ```

2. **Generate project:**
   ```bash
   cookiecutter gh:o2alexanderfedin/ai-swe-template
   ```

3. **Answer detailed prompts:**
   - Full project customization
   - All options available
   - Pre/post generation hooks run automatically

---

## 🎯 First Steps After Setup

### 1. Review Core Files (5 minutes)

```bash
# Understand the Memory Bank structure
cat .memory_bank/README.md

# Review your project context
cat .memory_bank/product_brief.md

# Check tech stack decisions
cat .memory_bank/tech_stack.md

# See available workflows
ls .memory_bank/workflows/
```

### 2. Customize for Your Project (10 minutes)

**Essential customizations:**

```bash
# 1. Update business context
nano .memory_bank/product_brief.md
# Edit: Project goals, target users, key features

# 2. Specify your tech stack
nano .memory_bank/tech_stack.md
# Add: Specific versions, libraries, frameworks

# 3. Add initial tasks
nano .memory_bank/current_tasks.md
# List: Your immediate TODOs
```

**Optional customizations:**

```bash
# Add project-specific patterns
nano .memory_bank/patterns/your_pattern.md

# Create custom guides
nano .memory_bank/guides/your_guide.md

# Add feature specifications
nano .memory_bank/specs/your_feature.md
```

### 3. Start Using Claude Code (Immediately!)

```bash
# Open in Claude Code
claude

# In Claude Code, refresh context:
/refresh_context

# Now use the workflows:
/m_feature "Add user authentication"
/m_bug "Fix login redirect"
/m_review
```

---

## 🧭 Daily Workflow

### Morning Routine (2 minutes)

```bash
# 1. Start Claude Code
claude

# 2. Refresh context
/refresh_context

# 3. Check current tasks
# (automatically loaded from .memory_bank/current_tasks.md)
```

### Working on Features

```
# 1. Start feature implementation
/m_feature "Add payment processing"

# Claude Code will:
# ✅ Read feature spec (if exists in .memory_bank/specs/)
# ✅ Follow new_feature.md workflow
# ✅ Update current_tasks.md
# ✅ Implement systematically
# ✅ Run tests
# ✅ Create commit
```

### Fixing Bugs

```
# 1. Start bug fix
/m_bug "Payment fails for negative amounts"

# Claude Code will:
# ✅ Follow bug_fix.md workflow
# ✅ Reproduce issue
# ✅ Write failing test
# ✅ Fix bug
# ✅ Verify fix
# ✅ Update documentation
```

### Code Reviews

```
# 1. Self-review before committing
/m_review

# 2. Or review specific files
/m_review src/payment.py src/user.py
```

---

## 📚 Key Commands Reference

### Essential Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/refresh_context` | Restore AI context | Use when context feels lost |
| `/m_feature [desc]` | Implement feature | `/m_feature "Add OAuth"` |
| `/m_bug [desc]` | Fix bug | `/m_bug "Login timeout"` |
| `/m_review [files]` | Code review | `/m_review src/auth.py` |
| `/m_refactor [desc]` | Refactor code | `/m_refactor "Extract service"` |

### Command Locations

Commands are installed in two places:

**Global commands** (`~/.config/claude/commands/`):
- Work across all projects
- Shared workflows

**Project commands** (`.claude/commands/`):
- Project-specific
- Override global commands if same name

---

## 🎨 Language-Specific Quick Starts

### Python

```bash
# Create project
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-api --lang python --framework fastapi

cd my-api

# Install dependencies
poetry install  # or pip install -r requirements.txt

# Start development
claude
/refresh_context
/m_feature "Create hello world endpoint"
```

### JavaScript/TypeScript

```bash
# Create project
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-app --lang javascript --framework express

cd my-app

# Install dependencies
npm install  # or yarn install

# Start development
claude
/refresh_context
/m_feature "Create hello world route"
```

### Go

```bash
# Create project
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-service --lang go --framework gin

cd my-service

# Initialize module
go mod init github.com/yourusername/my-service

# Start development
claude
/refresh_context
/m_feature "Create health check endpoint"
```

### Rust

```bash
# Create project
curl -sSL https://raw.githubusercontent.com/o2alexanderfedin/ai-swe-template/main/scripts/quick-start.sh | \
  bash -s my-app --lang rust --framework axum

cd my-app

# Create Cargo project structure
cargo init

# Start development
claude
/refresh_context
/m_feature "Create hello world handler"
```

---

## 🔧 Troubleshooting

### Setup Issues

**Problem**: "Permission denied" when running setup.sh
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

**Problem**: Placeholders not replaced
```bash
# Check that files contain {{VARIABLE}} format
grep -r "{{PROJECT_NAME}}" .memory_bank/

# Re-run setup if needed
./scripts/setup.sh
```

### Command Issues

**Problem**: Commands not found
```bash
# Check if installed
ls ~/.config/claude/commands/
ls .claude/commands/

# Manually copy if needed
cp -r .claude/commands/* ~/.config/claude/commands/
```

**Problem**: Context not loading
```bash
# Verify Memory Bank structure
ls .memory_bank/

# Should have: README.md, product_brief.md, tech_stack.md, current_tasks.md

# Force refresh
/refresh_context
```

---

## 📖 Learning Path

### Day 1: Setup and Basics (30 minutes)

1. ✅ Install template
2. ✅ Read `.memory_bank/README.md`
3. ✅ Try `/refresh_context`
4. ✅ Implement one simple feature with `/m_feature`

### Day 2: Understanding Workflows (1 hour)

1. ✅ Read `.memory_bank/workflows/new_feature.md`
2. ✅ Read `.memory_bank/workflows/bug_fix.md`
3. ✅ Fix a simple bug with `/m_bug`
4. ✅ Do a self-review with `/m_review`

### Week 1: Customization (2 hours)

1. ✅ Fully customize `.memory_bank/product_brief.md`
2. ✅ Add project-specific patterns
3. ✅ Create first feature spec in `.memory_bank/specs/`
4. ✅ Update `.memory_bank/tech_stack.md` with all dependencies

### Week 2: Mastery (ongoing)

1. ✅ Maintain `.memory_bank/current_tasks.md` daily
2. ✅ Add guides as you discover patterns
3. ✅ Contribute improvements back to template
4. ✅ Share with team

---

## 💡 Pro Tips

### Context Management

```
# Always start sessions with:
/refresh_context

# If AI seems confused, refresh again:
/refresh_context

# Before long tasks, ensure context is fresh
```

### Memory Bank Hygiene

```bash
# Update current tasks regularly
nano .memory_bank/current_tasks.md

# Document architectural decisions
nano .memory_bank/patterns/new_decision.md

# Keep tech stack current
nano .memory_bank/tech_stack.md
```

### Workflow Efficiency

```
# Use feature specs for complex features:
# 1. Create spec: .memory_bank/specs/feature-name.md
# 2. Run: /m_feature "Feature name"
# Claude Code reads spec automatically!

# Chain workflows:
/m_feature "Add auth" → /m_review → /m_refactor "Extract auth service"
```

---

## 🚀 Next Steps

### Immediate Actions

1. **Customize Memory Bank** (10 minutes)
   - Update product brief
   - Specify tech stack
   - Add current tasks

2. **Try First Feature** (15 minutes)
   - Use `/m_feature` command
   - Follow the workflow
   - See systematic development in action

3. **Read Documentation** (30 minutes)
   - [Template Strategy](TEMPLATE_STRATEGY.md)
   - [Workflows](.memory_bank/workflows/)
   - [Patterns](.memory_bank/patterns/)

### For Teams

1. **Share Memory Bank**
   - Commit to repository
   - All team members use same knowledge base

2. **Customize Commands**
   - Add team-specific workflows
   - Create organization patterns

3. **Setup CI/CD**
   - Use `.github/workflows/template-sync.yml` for updates
   - Add team-specific workflows

---

## 📞 Getting Help

### Resources

- **Documentation**: [README.md](README.md)
- **Detailed Setup**: [TEMPLATE_STRATEGY.md](TEMPLATE_STRATEGY.md)
- **Original Article**: [AI_SWE_article.md](AI_SWE_article.md)
- **Scripts Guide**: [scripts/README.md](scripts/README.md)

### Common Questions

**Q: Can I use this with my existing project?**
A: Yes! Use `scripts/setup-existing.sh`. It intelligently merges with your existing structure.

**Q: What if I don't use Python/JS/Go/Rust?**
A: The template works with any language. Language-specific templates are optional optimizations.

**Q: Can I modify the Memory Bank structure?**
A: Absolutely! It's your project. The template is a starting point.

**Q: How do I get template updates?**
A: Option 1: Use `.github/workflows/template-sync.yml` for automatic PRs.
Option 2: Manually pull from template repository.
Option 3: Don't update - you own your fork completely.

**Q: Is this only for Claude Code?**
A: Memory Bank works with any AI assistant. Commands are Claude Code-specific but easy to adapt.

---

## ✨ You're Ready!

You now have everything you need to start systematic AI-assisted development.

**Your next command:**

```
claude           # Start Claude Code
/refresh_context # Load your Memory Bank
/m_feature "..." # Build something awesome!
```

Happy coding! 🚀

---

**Version**: 0.8.0
**Last Updated**: 2025-10-19
**Template**: [github.com/o2alexanderfedin/ai-swe-template](https://github.com/o2alexanderfedin/ai-swe-template)
