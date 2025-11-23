" Configuration of buffer

:set textwidth=79 " quebra linhas com mais de 79 col.
:set shiftwidth=4 " ajusta as operações >> e << indentar e desindentar 4 col.
:set tabstop=4	" exibe uma TAB crua como 4 col.
:set expandtab	" insere espaços quando acionar a tecla TAB
:set softtabstop=4	" insere/remove 4 espaços com TAB/Backspace
:set shiftround	" arredonda a indentação para múltiplos dos shiftwidth especificados
:set autoindent

"Fold
:set foldmethod=marker
:set foldmarker=###,---

"setlocal foldignore=

"Functions
"Line function
:inoremap @ <ESC>i <+name+> = @(<+paramenters+>) <+arguments+>;

"Defautl function
:inoremap \fc <ESC>i function [<+output+>] = <+name+> (<+input+>)<ESC>oendfunction<ESC>O<tab>

"Funciton call 
:inoremap \cf <ESC>i [<+output+>] = <+name+> (<+parameter+>) 

"structure loop
"for
:inoremap <leader>sf <ESC>afor i = <ESC>oendfor<ESC>1k5la

"while
:inoremap <leader>sw <ESC>awhile ()<ESC>oendwhile<esc>1ki

"if
:inoremap <leader>if if()<ESC>oendif<ESC>1ki

"ifelse
:nnoremap <leader>il :<ESC>oif(<++>){<ESC>o}else{<ESC>o<++><ESC>o}<ESC>3k<ESC>z

"print 
:inoremap <leader>p printf("<+message+>%<+type+>\n",<+print+>);

"Atalhos
:inoremap [ []<ESC>i
:inoremap ( ()<ESC>i
:inoremap ) ();<ESC>i<ESC>i

"Compementation
:inoremap \c :<ESC>a<c-x><c-n>

"name
:inoremap -na <ESC>"%pa

"date
:inoremap -da <ESC>:pu = strftime('%c')<CR><ESC>i<BS><ESC>$a

"template
:nnoremap <leader>t1 :r /home/jefferson/template/m.txt <CR>
:nnoremap <F8> <ESC>:sp /home/jefferson/.vim/after/ftplugin/m.vim <CR>

:nnoremap <F2> <ESC>:!rxvt -e octave-cli & exit <CR><CR>
