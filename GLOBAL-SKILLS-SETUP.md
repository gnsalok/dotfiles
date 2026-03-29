# Global Skills Setup (Codex + Copilot)

This guide explains how to set up this repo on a new Mac so dotfiles and AI skills are available everywhere.

## What this solves

Without a global setup, skills and prompts only work from this repo.
With this setup:

- Dotfiles (`.vimrc`, `.tmux.conf`, `.carbon-now.json`) are linked into your home directory.
- Codex can use your skills globally.
- Copilot Agent can use your skills globally.
- Prompt files are also linked globally for Copilot prompt slash commands.

All links point back to this repo, so updating this repo updates behavior everywhere.

## One-time setup

From the repo root:

```bash
make setup
```

This runs:

- `make setup-dotfiles`
- `make setup-skills-global`

## Target breakdown

- `make setup-dotfiles`
  - Links `.vimrc`, `.tmux.conf`, and `.carbon-now.json` into `$HOME`.

- `make setup-codex-skills`
  - Links `skills/actions`, `skills/knowledge`, and `.prompts` into `~/.codex/skills/personal`.
  - Why link prompts too: these are useful as a shared source/reference with skills.

- `make setup-copilot-skills`
  - Links each skill folder (each directory containing `SKILL.md`) into `~/.copilot/skills`.
  - Links `.prompts/*.md` into `~/.copilot/prompts/*.prompt.md` for prompt slash commands.

- `make setup-skills-global`
  - Runs both Codex and Copilot setup targets.

## Verify

```bash
ls -la ~/.codex/skills/personal
ls -la ~/.copilot/skills
ls -la ~/.copilot/prompts
```

In Copilot Chat:

- Run `/skills` and confirm your custom skills are visible.
- Try `/learn-this`.

In Codex:

- Start a session in any repo and invoke your custom skill by name.

## Important note on prompts vs skills

- Runtime behavior comes from `SKILL.md`.
- `.prompts/*.md` is the source/reference layer.
- The `metadata.source` field in `SKILL.md` is traceability metadata unless a tool explicitly consumes it.

This repo links both so you keep one place to edit and can still reuse prompts directly.

## Cleanup (remove global links)

```bash
make clean-codex-links
make clean-copilot-links
```

These remove only symlinks that point back to this repo.
