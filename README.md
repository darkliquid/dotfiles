# dotfiles

New doot-based dotfiles repo.

Not much here yet.

## Installation

Everything is driven via mise. Install that via:

```sh
curl https://mise.run | sh
```

Once mise is installed, you can have it install and run doot to
complete the rest of the setup, like so:

```sh
mise exec github:pol-rivero/doot -- doot bootstrap darkliquid/dotfiles ~/.dotfiles
```