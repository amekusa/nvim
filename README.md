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

`~/.config/nvim/init.lua`:
```lua
require('custom')
```

> NOTE: The folder name isn't required to be `custom`, since it's not hardcoded.

----

## Appendix: Vim Notes

### Macros
`q` + `any-char` starts recording.  
Pressing `q` again finishes the recording and registers it to the char you pressed after `q`.

`Q` plays the last recording.  
`@` + `char` plays the recording registered to the char.

Macros work with any actions even for the ones you can't replay with `.`.

### Marks
`m` + `any-char` registers the current line to the jumplist of the current buffer.  
`'` + `char` makes the cursor jump to the mark.  
`'"` jumps to the last mark.  

### Motions
`f` + `any-char` jumps to the first matched char in the current line.  
`;` jumps to the next matched char.  
`,` jumps back to the previous one.

### Advanced Editing
`dt` + `any-char` deletes the string between the current position and the `char`.

