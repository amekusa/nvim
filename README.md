# Amekusa's Neovim Configuration
Tested Neovim version: 0.9.5

## Install
```sh
# Clone this repository
mkdir -p ~/.config/nvim/lua
git clone git@github.com:amekusa/nvim.git ~/.config/nvim/lua/custom

# Require the repo from init.lua
echo "require('custom')" >> ~/.config/nvim/init.lua
```

> NOTE: The folder name isn't required to be `custom`, since it's not hardcoded.

## Customize
```sh
cd ~/.config/nvim/lua/custom

# Copy config-default.lua as config.lua
cp config-default.lua config.lua

# Edit it howerver you want
nvim config.lua
```

----

## Appendix: Vim Notes

### Macros
`q` + `any-char` starts recording.  
Pressing `q` again finishes the recording and registers it to the `char`.

`Q` plays the last recording.  
`@` + `char` plays the recording registered to the `char`.

Macros work with any actions even for the ones you can't replay with `.`.

### Repeat for each line
1. Select the lines you want to modify with visual mode.
2. Enter command mode with `:`.
3. Execute `:'<,'>norm ` + `any-command`.

Example: Play macro `a` for each line:
`:'<,'>norm @a`

### Marks
`m` + `any-char` registers the current line to the jumplist of the current buffer.  
`'` + `char` makes the cursor jump to the mark.  
`'"` jumps to the last mark.  

### Motions
`f` + `any-char` jumps to the first matched `char` in the current line.  
`;` jumps to the next matched `char`.  
`,` jumps back to the previous one.

### Advanced Editing
`dt` + `any-char` deletes the string between the current position and the `char`.

### Running shell commands
`:!<command>`

### Setting the language (filetype) of the current buffer manually
`:setf <filetype>`

