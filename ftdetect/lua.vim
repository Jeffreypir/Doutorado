"Load template in *py
"au BufNewFile,BufRead *.py :set filetype=py
"
au BufNewFile,BufRead *.lua normal gg=G 
au BufNewFile *.lua :r $HOME/.config/nvim/after/template/template.lua
au BufNewFile *.lua normal ggdd


