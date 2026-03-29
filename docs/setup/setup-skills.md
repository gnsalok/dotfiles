## Setup Skills and Prompt Files

For Copilot Agent (VS Code), the closest equivalent is **Personal Agent Skills** + optional **User Prompt Files**.

### Recommended setup (works in any repo)

1. Put your reusable skills in Copilot’s personal skills path (or symlink to dotfiles):
```bash
mkdir -p ~/.copilot/skills
ln -sfn /Users/aloktripathi/codespace/dotfiles/skills/actions/agent/learn-this ~/.copilot/skills/learn-this
```


2. `~/.copilot/skills` should contain **skill folders directly** (each folder must contain `SKILL.md`, and `name` must match that folder name).  
Your symlink points to `actions/` and `knowledge/`, which are category folders, not skill folders.

Use this instead:

```bash
mkdir -p ~/.copilot/skills
ln -sfn /Users/aloktripathi/codespace/dotfiles/skills/actions/agent/learn-this ~/.copilot/skills/learn-this
```

Then in VS Code:

1. Ensure `chat.useAgentSkills` is enabled.
2. Run `/skills` in chat and confirm `learn-this` appears.
3. Reload window (`Developer: Reload Window`) and try `/learn-this`.

If you want to link **all** skills in your repo as top-level personal skills:

```bash
mkdir -p ~/.copilot/skills
find /Users/aloktripathi/codespace/dotfiles/skills -name SKILL.md -print0 | while IFS= read -r -d '' f; do
  d="$(dirname "$f")"
  n="$(basename "$d")"
  ln -sfn "$d" "$HOME/.copilot/skills/$n"
done
```

Also verify your `learn-this` frontmatter keeps:
- `name: learn-this`
- folder name: `learn-this`


3. In VS Code settings (User `settings.json`), ensure:
```json
{
  "chat.useAgentSkills": true,
  "chat.agentSkillsLocations": [
    "/Users/aloktripathi/codespace/dotfiles/skills"
  ]
}
```
(`chat.agentSkillsLocations` is optional if you already symlink into `~/.copilot/skills`.)

3. Reload VS Code window, open any repo (e.g. `/Users/aloktripathi/codespace/ttl-operator`), and run:
- `/learn-this` in Copilot Chat.

### Notes

- Your existing `SKILL.md`-based `learn-this` is the right format for Copilot Agent Skills.
- For prompt-style slash commands, Copilot uses `*.prompt.md` files; those can be stored as **user prompts** (global) or workspace prompts.
- `AGENTS.md` in Copilot is mainly workspace-root scoped; for truly global behavior, use personal skills/instructions.


### Sources
- VS Code Agent Skills docs: https://code.visualstudio.com/docs/copilot/customization/agent-skills  
- VS Code Prompt Files docs: https://code.visualstudio.com/docs/copilot/customization/prompt-files  
- VS Code Custom Instructions docs: https://code.visualstudio.com/docs/copilot/customization/custom-instructions  
- GitHub custom instructions overview: https://docs.github.com/en/copilot/concepts/about-customizing-github-copilot-chat-responses