"Load template in *c
au BufNewFile,BufRead *.nxc :set filetype=nxc
au BufNewFile *.nxc :r $HOME/.config/nvim/after/template/template.nxc
au BufNewFile *.nxc :normal ggdd


