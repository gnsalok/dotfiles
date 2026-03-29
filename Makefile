SHELL := /bin/sh

REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
HOME_DIR ?= $(HOME)

DOTFILES := .vimrc .tmux.conf .carbon-now.json

.PHONY: help setup setup-dotfiles setup-skills-global setup-codex-skills setup-copilot-skills clean-copilot-links clean-codex-links

help:
	@echo "Available targets:"
	@echo "  make setup               - Link dotfiles and install global skills/prompts"
	@echo "  make setup-dotfiles      - Link .vimrc, .tmux.conf, and .carbon-now.json into $$HOME"
	@echo "  make setup-skills-global - Install skills/prompts for Codex and Copilot"
	@echo "  make setup-codex-skills  - Install skills/prompts under ~/.codex"
	@echo "  make setup-copilot-skills - Install skills/prompts under ~/.copilot"
	@echo "  make clean-codex-links   - Remove links created by setup-codex-skills"
	@echo "  make clean-copilot-links - Remove links created by setup-copilot-skills"

setup: setup-dotfiles setup-skills-global

setup-dotfiles:
	@set -eu; \
	for file in $(DOTFILES); do \
		src="$(REPO_ROOT)/$$file"; \
		dst="$(HOME_DIR)/$$file"; \
		ln -sfn "$$src" "$$dst"; \
		printf "linked %s -> %s\n" "$$dst" "$$src"; \
	done

setup-skills-global: setup-codex-skills setup-copilot-skills

setup-codex-skills:
	@set -eu; \
	mkdir -p "$(HOME_DIR)/.codex/skills/personal"; \
	ln -sfn "$(REPO_ROOT)/skills/actions" "$(HOME_DIR)/.codex/skills/personal/actions"; \
	ln -sfn "$(REPO_ROOT)/skills/knowledge" "$(HOME_DIR)/.codex/skills/personal/knowledge"; \
	ln -sfn "$(REPO_ROOT)/.prompts" "$(HOME_DIR)/.codex/skills/personal/prompts"; \
	printf "codex links created under %s\n" "$(HOME_DIR)/.codex/skills/personal"

setup-copilot-skills:
	@set -eu; \
	mkdir -p "$(HOME_DIR)/.copilot/skills" "$(HOME_DIR)/.copilot/prompts"; \
	find "$(REPO_ROOT)/skills" -type f -name SKILL.md | sort | while IFS= read -r skill_file; do \
		skill_dir=$$(dirname "$$skill_file"); \
		skill_name=$$(basename "$$skill_dir"); \
		link_path="$(HOME_DIR)/.copilot/skills/$$skill_name"; \
		if [ -e "$$link_path" ] && [ ! -L "$$link_path" ]; then \
			printf "skip %s (exists and is not a symlink)\n" "$$link_path"; \
			continue; \
		fi; \
		ln -sfn "$$skill_dir" "$$link_path"; \
		printf "linked %s -> %s\n" "$$link_path" "$$skill_dir"; \
	done; \
	find "$(REPO_ROOT)/.prompts" -type f -name '*.md' | sort | while IFS= read -r prompt_file; do \
		prompt_name=$$(basename "$$prompt_file" .md); \
		link_path="$(HOME_DIR)/.copilot/prompts/$$prompt_name.prompt.md"; \
		if [ -e "$$link_path" ] && [ ! -L "$$link_path" ]; then \
			printf "skip %s (exists and is not a symlink)\n" "$$link_path"; \
			continue; \
		fi; \
		ln -sfn "$$prompt_file" "$$link_path"; \
		printf "linked %s -> %s\n" "$$link_path" "$$prompt_file"; \
	done; \
	printf "copilot links created under %s and %s\n" "$(HOME_DIR)/.copilot/skills" "$(HOME_DIR)/.copilot/prompts"

clean-codex-links:
	@set -eu; \
	for link_path in \
		"$(HOME_DIR)/.codex/skills/personal/actions" \
		"$(HOME_DIR)/.codex/skills/personal/knowledge" \
		"$(HOME_DIR)/.codex/skills/personal/prompts"; do \
		if [ -L "$$link_path" ]; then \
			target=$$(readlink "$$link_path" || true); \
			case "$$target" in \
				"$(REPO_ROOT)"/*) unlink "$$link_path"; printf "removed %s\n" "$$link_path" ;; \
				*) printf "skip %s (not linked to this repo)\n" "$$link_path" ;; \
			esac; \
		fi; \
	done

clean-copilot-links:
	@set -eu; \
	if [ -d "$(HOME_DIR)/.copilot/skills" ]; then \
		find "$(HOME_DIR)/.copilot/skills" -maxdepth 1 -type l | while IFS= read -r link_path; do \
			target=$$(readlink "$$link_path" || true); \
			case "$$target" in \
				"$(REPO_ROOT)"/*) unlink "$$link_path"; printf "removed %s\n" "$$link_path" ;; \
			esac; \
		done; \
	fi; \
	if [ -d "$(HOME_DIR)/.copilot/prompts" ]; then \
		find "$(HOME_DIR)/.copilot/prompts" -maxdepth 1 -type l | while IFS= read -r link_path; do \
			target=$$(readlink "$$link_path" || true); \
			case "$$target" in \
				"$(REPO_ROOT)"/*) unlink "$$link_path"; printf "removed %s\n" "$$link_path" ;; \
			esac; \
		done; \
	fi
