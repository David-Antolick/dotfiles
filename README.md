# dotfiles

Bootstrap for Anvil Coder / dev workspaces. Coder clones this to `~/.dotfiles` on
workspace start and runs `install.sh` (must stay executable: `git update-index --chmod=+x install.sh`).

## Tools installed
kubectl 1.34.7, kubeseal 0.36.6, helm, gh, uv, node (nvm LTS), Claude Code.

## Public on purpose -> NO secrets here
Coder clones this **before** your SSH key exists, so it must be public. Personal
and secret config live on the NAS and are symlinked in by `install.sh`:

```
/hdd_nas/dev_config/
  CLAUDE.md         -> ~/.claude/CLAUDE.md       (global Claude profile)
  settings.json     -> ~/.claude/settings.json   (permission allowlist, hooks)
  claude-rules/     -> ~/.claude/rules
  claude-skills/    -> ~/.claude/skills           (your custom skills)
  claude-plugins/   -> ~/.claude/plugins
  .gitconfig        -> ~/.gitconfig               (optional)
```

Seed that folder once (persists + shared across workspaces). Claude Code **auth**
is NOT stored here -- run `claude` and log in once per workspace. MCP servers:
re-add with `claude mcp add ...` or a project-level `.mcp.json` (mind any tokens).

## Wire it up
Set the **"Dotfiles repo" parameter when creating a workspace**
(`https://github.com/David-Antolick/dotfiles`), or run once in an existing one:
`coder dotfiles https://github.com/David-Antolick/dotfiles`.
