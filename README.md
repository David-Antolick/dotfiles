# dotfiles

Bootstrap for Anvil Coder / dev workspaces. Coder clones this to `~/.dotfiles` on
workspace start and runs `install.sh`, which installs CLI tools and wires in
personal config.

## Tools installed
kubectl 1.34.7, kubeseal 0.36.6, helm, gh, uv, node (nvm LTS), Claude Code.

## Public on purpose
Coder clones this **before** your SSH key exists, so it must be public -> **no
secrets here**. Personal/secret config lives on the NAS and is symlinked in by
`install.sh`:

```
/hdd_nas/dev_config/
  CLAUDE.md         -> ~/.claude/CLAUDE.md      (your global Claude profile)
  settings.json     -> ~/.claude/settings.json  (permission allowlist, etc.)
  claude-rules/     -> ~/.claude/rules
  .gitconfig        -> ~/.gitconfig              (optional)
```

Seed that folder once (it persists + is shared across workspaces). Claude Code
**auth** is not stored here -- run `claude` and log in once per workspace.

## Wire it up
Coder -> Account Settings -> Dotfiles -> `https://github.com/David-Antolick/dotfiles`
(or set the "Dotfiles repo" param when creating a workspace).
