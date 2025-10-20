# Project Notes

## AI SWE Methodology Template

This project serves as a complete reference implementation of the AI Software Engineering (AI SWE) methodology based on the article: https://habr.com/ru/articles/934806/

### What Makes This a Great Template

1. **Complete Memory Bank System** - Fully documented with real examples
2. **Custom Commands** - Both global and project-specific commands
3. **Three-Phase Workflow** - Planning-Execution-Review fully implemented
4. **Comprehensive Documentation** - Over 9,200 lines of guides, patterns, and workflows
5. **Git Flow Integration** - Proper versioning and release management
6. **English-Only** - All documentation translated from Russian to English

### To Use This as a Template

1. Clone this repository
2. Update `.memory_bank/product_brief.md` with your project details
3. Update `.memory_bank/tech_stack.md` with your technology choices
4. Customize workflows in `.memory_bank/workflows/` as needed
5. Update `CLAUDE.md` with project-specific instructions
6. Start development with `/refresh_context` and appropriate workflows

### Key Features

- **Memory Bank**: 13 files, 3,541 lines of project knowledge
- **Custom Commands**: 5 global commands for workflow automation
- **Documentation**: 27 files total, ~270KB of comprehensive guides
- **Validation**: 100% complete and production-ready

### Repository Structure

See `FILE_INDEX.md` for complete file listing and organization.

### Quick Start

See `QUICK_START.md` for daily workflow and command reference.

### Template Strategy

**See [TEMPLATE_STRATEGY.md](./TEMPLATE_STRATEGY.md) for the complete implementation plan.**

This document contains:
- Comprehensive strategy for making this a reusable template
- Three usage modes (new projects, existing projects, power users)
- Smart setup script specifications
- Language-specific variant support
- Update handling strategies
- Complete implementation roadmap

**Recommended Approach**: GitHub Template + Smart Setup Script
- One-click initialization
- Works for new AND existing projects
- Full customization available
- 2-minute setup for most users

### Future Enhancements

Implementation roadmap is detailed in TEMPLATE_STRATEGY.md:

**Phase 1: Core Template**
- [ ] Add placeholder variables to all files
- [ ] Create `scripts/setup.sh` for interactive setup
- [ ] Mark repository as GitHub Template

**Phase 2: Language Variants**
- [ ] Python-specific template
- [ ] JavaScript/TypeScript template
- [ ] Go template
- [ ] Rust template

**Phase 3: Advanced Features**
- [ ] Setup script for existing projects
- [ ] One-liner quick-start script
- [ ] Cookiecutter support
- [ ] GitHub Action for template sync

**Phase 4: Polish**
- [ ] Comprehensive documentation
- [ ] Video walkthrough
- [ ] Example projects
- [ ] Community feedback

---

**Status**: Production-ready reference implementation
**Template Strategy**: Documented in TEMPLATE_STRATEGY.md
**Version**: 0.5.0
**Last Updated**: 2025-10-19
