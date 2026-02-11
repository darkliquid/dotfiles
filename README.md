# dotfiles

New [doot][1]-based dotfiles repo.

Not much here yet.

## Installation

Everything is driven via [mise][2]. Install that via:

```sh
curl https://mise.run | sh
```

Once [mise][2] is installed, you can have it install and run [doot][1] to
complete the rest of the setup, like so:

```sh
mise exec github:pol-rivero/doot -- doot bootstrap darkliquid/dotfiles ~/.dotfiles
```

[1]:https://github.com/pol-rivero/doot
[2]:https://mise.jdx.dev/
