#!/usr/bin/env python3
"""
Post-generation hook for AI SWE Template cookiecutter.
Performs cleanup and customization after project generation.
"""

import os
import shutil
import subprocess
from pathlib import Path

# Cookiecutter variables
PROJECT_SLUG = "{{ cookiecutter.project_slug }}"
LANGUAGE = "{{ cookiecutter.language }}"
INIT_GIT = "{{ cookiecutter.init_git }}"
INIT_GIT_FLOW = "{{ cookiecutter.init_git_flow }}"
USE_DOCKER = "{{ cookiecutter.use_docker }}"
USE_CI_CD = "{{ cookiecutter.use_ci_cd }}"
CI_PLATFORM = "{{ cookiecutter.ci_platform }}"

PROJECT_DIR = Path.cwd()


def cleanup_template_files():
    """Remove template-specific files not needed in generated project."""
    files_to_remove = [
        "TEMPLATE_STRATEGY.md",
        "AI_SWE_article.md",
        "PROJECT_NOTES.md",
        "cookiecutter.json",
        "hooks/",
    ]

    print("🧹 Cleaning up template files...")
    for item in files_to_remove:
        path = PROJECT_DIR / item
        if path.exists():
            if path.is_dir():
                shutil.rmtree(path)
            else:
                path.unlink()
            print(f"  ✓ Removed {item}")


def setup_language_specific():
    """Copy language-specific tech_stack.md."""
    print(f"⚙️  Setting up {LANGUAGE} configuration...")

    template_file = PROJECT_DIR / "templates" / LANGUAGE / "tech_stack.md"
    if template_file.exists():
        shutil.copy(template_file, PROJECT_DIR / ".memory_bank" / "tech_stack.md")
        print(f"  ✓ Configured for {LANGUAGE}")
    else:
        print(f"  ⚠ No specific template for {LANGUAGE}, using generic")

    # Remove templates directory
    templates_dir = PROJECT_DIR / "templates"
    if templates_dir.exists():
        shutil.rmtree(templates_dir)


def setup_docker():
    """Set up Docker configuration if requested."""
    if USE_DOCKER.lower() != "y":
        print("🐳 Skipping Docker setup")
        return

    print("🐳 Setting up Docker...")
    # Dockerfile would be created by template based on language
    # This is a placeholder for future Docker template files
    print("  ⚠ Docker templates not yet implemented - add manually")


def setup_ci_cd():
    """Set up CI/CD configuration if requested."""
    if USE_CI_CD.lower() != "y":
        print("🔄 Skipping CI/CD setup")
        return

    print(f"🔄 Setting up {CI_PLATFORM}...")

    if CI_PLATFORM == "github_actions":
        # GitHub Actions would be set up from template
        workflows_dir = PROJECT_DIR / ".github" / "workflows"
        workflows_dir.mkdir(parents=True, exist_ok=True)
        print("  ✓ Created .github/workflows directory")
    elif CI_PLATFORM == "gitlab_ci":
        print("  ⚠ GitLab CI templates not yet implemented - add manually")
    elif CI_PLATFORM == "circleci":
        print("  ⚠ CircleCI templates not yet implemented - add manually")


def init_git():
    """Initialize git repository if requested."""
    if INIT_GIT.lower() != "y":
        print("📦 Skipping git initialization")
        return

    print("📦 Initializing git repository...")

    try:
        subprocess.run(["git", "init", "-q"], check=True, cwd=PROJECT_DIR)
        subprocess.run(
            ["git", "checkout", "-b", "main", "-q"], check=True, cwd=PROJECT_DIR
        )
        print("  ✓ Git initialized")

        # Initialize git-flow if requested
        if INIT_GIT_FLOW.lower() == "y":
            try:
                subprocess.run(
                    ["git", "flow", "init", "-d"],
                    check=True,
                    cwd=PROJECT_DIR,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                )
                print("  ✓ Git flow initialized")
            except (subprocess.CalledProcessError, FileNotFoundError):
                print("  ⚠ Git flow not available (install git-flow)")

        # Initial commit
        subprocess.run(["git", "add", "."], check=True, cwd=PROJECT_DIR)
        subprocess.run(
            [
                "git",
                "commit",
                "-q",
                "-m",
                f"""feat: Initialize {PROJECT_SLUG} with AI SWE methodology

Project: {{ cookiecutter.project_name }}
Language: {LANGUAGE}
Framework: {{ cookiecutter.framework }}

🤖 Generated with AI SWE Template
https://github.com/o2alexanderfedin/ai-swe-template
""",
            ],
            check=True,
            cwd=PROJECT_DIR,
        )
        print("  ✓ Initial commit created")

    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"  ✗ Git initialization failed: {e}")


def print_next_steps():
    """Print next steps for the user."""
    print("\n" + "=" * 60)
    print("✨ Project generated successfully! ✨")
    print("=" * 60)
    print(f"\nProject: {{ cookiecutter.project_name }}")
    print(f"Location: {PROJECT_DIR}")
    print(f"Language: {LANGUAGE}")
    print("\n📋 Next steps:")
    print(f"  1. cd {PROJECT_SLUG}")
    print("  2. Review .memory_bank/product_brief.md")
    print("  3. Customize .memory_bank/tech_stack.md")
    print("  4. Update .memory_bank/current_tasks.md")
    print("  5. Start Claude Code: claude")
    print("  6. Run: /refresh_context")
    print("\n📚 Documentation:")
    print("  - Memory Bank: cat .memory_bank/README.md")
    print("  - Quick start: cat QUICK_START.md")
    print("  - Template: https://github.com/o2alexanderfedin/ai-swe-template")
    print("\n🚀 Happy coding with AI assistance!\n")


if __name__ == "__main__":
    cleanup_template_files()
    setup_language_specific()
    setup_docker()
    setup_ci_cd()
    init_git()
    print_next_steps()
