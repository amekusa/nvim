# My NeoVim configuration

## Install
```sh
# Clone this repository
mkdir -p ~/.config/nvim/lua
cd ~/.config/nvim/lua
git clone git@github.com:amekusa/nvim.git custom

# Edit init.lua
nvim ~/.config/nvim/init.lua
```

`init.lua`:
```lua
require('custom')
```

----

## Appendix: Vim Notes

### Macros
`q` + any-char starts recording.
Pressing `q` again finishes the recording and registers it to the char you pressed after `q`.

`Q` plays the last recording.
`@` + char plays the recording registered to the char.

Macros works with any actions even for the ones you can't replay with `. (period)`.

