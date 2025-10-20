# Scripts Directory

This directory contains utility scripts for setting up and managing the AI SWE Template methodology in your project.

## Available Scripts

### `setup.sh`

Interactive setup wizard for initializing or adding AI SWE methodology to your project.

**Purpose:**
- Configures Memory Bank with project-specific information
- Customizes templates based on programming language
- Sets up git repository with proper initial commit
- Removes template-specific files

**Usage:**

```bash
# For new projects (cloned from template)
./scripts/setup.sh

# For existing projects (after downloading setup files)
./scripts/setup.sh
```

**Features:**

1. **Mode Detection**
   - Automatically detects if project is new or existing
   - Adapts setup process accordingly

2. **Interactive Prompts**
   - Project name (required)
   - Project description (required)
   - Primary language: python, javascript, typescript, go, rust (required)
   - Framework: FastAPI, Django, Express, Next.js, etc. (optional)
   - AI/LLM features: yes/no
   - Database: postgresql, mongodb, redis, none

3. **Language-Specific Configuration**
   - Applies language-specific tech stack templates
   - Copies appropriate workflow files
   - Falls back to generic template if specific one doesn't exist

4. **Placeholder Replacement**
   - Replaces `{{PROJECT_NAME}}` in all Memory Bank files
   - Replaces `{{PROJECT_DESC}}` with project description
   - Replaces `{{LANGUAGE}}` with selected language
   - Replaces `{{FRAMEWORK}}` with selected framework
   - Replaces `{{AI_FEATURES}}` with AI usage preference
   - Replaces `{{DATABASE}}` with database choice

5. **Git Integration**
   - For new projects: Initializes git, sets up git flow (optional), creates initial commit
   - For existing projects: Creates commit adding AI SWE methodology
   - Gracefully handles missing git or git-flow

6. **Cleanup**
   - Removes template-specific documentation files
   - Removes language template directories
   - Keeps only project-relevant files

**Requirements:**

- Bash 4.0+
- Git (optional, recommended)
- Git Flow (optional)

**Error Handling:**

- Validates all required inputs
- Provides clear error messages with color coding
- Fails fast on errors (set -e)
- Gracefully handles missing optional tools

**Color Coding:**

- GREEN: Success messages and headers
- YELLOW: Warnings and non-critical issues
- RED: Errors and validation failures
- BLUE: Information messages

**Exit Codes:**

- 0: Success
- 1: Error during execution
- Non-zero: Validation or execution failure

## Output Examples

### Successful Setup (New Project)

```
╔════════════════════════════════════════╗
║   AI SWE Template Setup Wizard        ║
╚════════════════════════════════════════╝

✓ Mode: New project

ℹ Please answer the following questions to customize your project:

Project name: my-awesome-bot
Brief description: AI-powered Telegram bot for automated tasks
Primary language (python/javascript/typescript/go/rust): python
Framework (optional, e.g., FastAPI, Django, Express, Next.js): aiogram
Use AI/LLM features? (y/n): y
Database (postgresql/mongodb/redis/none): postgresql

ℹ Setting up project with following configuration:
  Project: my-awesome-bot
  Description: AI-powered Telegram bot for automated tasks
  Language: python
  Framework: aiogram
  AI Features: Yes
  Database: postgresql

ℹ Applying language-specific configuration...
✓ Using python template
✓ Applied python tech stack
✓ Applied python workflows
ℹ Customizing Memory Bank files...
✓ Memory Bank customized
ℹ Customizing CLAUDE.md...
✓ CLAUDE.md customized
ℹ Cleaning up template files...
✓ Template files removed
ℹ Initializing git repository...
✓ Git initialized
ℹ Initializing git flow...
ℹ Creating initial commit...
✓ Git repository initialized

╔════════════════════════════════════════╗
║          Setup Complete! 🎉            ║
╚════════════════════════════════════════╝

✓ Your project is now set up with AI SWE methodology!

ℹ Next steps:
  1. Review and customize .memory_bank/product_brief.md
  2. Update .memory_bank/tech_stack.md with specific dependencies
  3. Add your current tasks to .memory_bank/current_tasks.md
  4. Review CLAUDE.md for project-specific instructions
  5. Open project in Claude Code and use /refresh_context command

ℹ Documentation:
  - Quick Start: cat QUICK_START.md (if available)
  - Full Guide: cat README.md
  - Memory Bank: cat .memory_bank/README.md

✓ Happy coding with AI assistance!
```

### Successful Setup (Existing Project)

```
╔════════════════════════════════════════╗
║   AI SWE Template Setup Wizard        ║
╚════════════════════════════════════════╝

⚠ Detected: Existing project
ℹ This will add AI SWE methodology to your existing project

Continue? (y/n): y

[... interactive prompts ...]

ℹ Adding AI SWE methodology to existing project...
✓ AI SWE methodology added to project

╔════════════════════════════════════════╗
║          Setup Complete! 🎉            ║
╚════════════════════════════════════════╝
```

## Development Notes

### Script Structure

The `setup.sh` script follows these design principles:

1. **Fail-Fast**: Uses `set -e` to exit on first error
2. **User-Friendly**: Color-coded output, clear messages
3. **Defensive**: Validates all user inputs
4. **Safe**: Never destructive, preserves existing data
5. **Portable**: Works on macOS and Linux

### Adding New Languages

To add support for a new language:

1. Create `templates/{language}/` directory
2. Add language-specific `tech_stack.md`
3. Add language-specific workflows in `templates/{language}/workflows/`
4. Update `validate_language()` function to accept new language
5. Test setup script with new language

### Testing the Script

```bash
# Test in dry-run mode (if implemented)
./scripts/setup.sh --dry-run

# Test with specific configuration
PROJECT_NAME="test" \
PROJECT_DESC="Test project" \
LANG="python" \
FRAMEWORK="FastAPI" \
./scripts/setup.sh

# Test on fresh clone
git clone <template-repo> test-project
cd test-project
./scripts/setup.sh
```

### Maintenance

**Regular checks:**
- Ensure compatibility with latest bash versions
- Test on macOS and Linux
- Validate all placeholder replacements
- Check git operations work correctly
- Verify cleanup removes all template files

**Known Limitations:**
- Requires bash (not sh or zsh)
- Git operations require git to be installed
- macOS and Linux have different sed syntax (handled in script)

## Troubleshooting

### Common Issues

**Issue**: "command not found: setup.sh"
**Solution**: Make sure script is executable: `chmod +x scripts/setup.sh`

**Issue**: Placeholders not replaced
**Solution**: Check that template files contain `{{VARIABLE}}` format, not `$VARIABLE`

**Issue**: Git commit fails
**Solution**: Configure git user: `git config user.name "Your Name"` and `git config user.email "email@example.com"`

**Issue**: Permission denied
**Solution**: Run with proper permissions or use `bash scripts/setup.sh`

## Future Enhancements

Planned improvements:

- [ ] Add `--dry-run` mode to preview changes
- [ ] Add `--non-interactive` mode for CI/CD
- [ ] Support configuration file (`.setup.config`)
- [ ] Add rollback functionality
- [ ] Create update script for pulling template improvements
- [ ] Add validation tests for setup script
- [ ] Support Windows (PowerShell version)

## Contributing

When modifying setup scripts:

1. Test on both macOS and Linux
2. Maintain color-coded output
3. Add validation for new inputs
4. Update this README
5. Follow bash best practices
6. Add error handling for new operations

## License

Same as project license.
