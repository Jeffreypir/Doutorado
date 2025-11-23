" Configuration of buffer

:set textwidth=79 " quebra linhas com mais de 79 col.
:set shiftwidth=4 " ajusta as operações >> e << indentar e desindentar 4 col.
:set tabstop=4	" exibe uma TAB crua como 4 col.
:set expandtab	" insere espaços quando acionar a tecla TAB
:set softtabstop=4	" insere/remove 4 espaços com TAB/Backspace
:set shiftround	" arredonda a indentação para múltiplos dos shiftwidth especificados
:set autoindent


" Comment block code
:inoremap /* /* */<ESC>bi
:noremap co <ESC>j<c-v>/\/<ENTER>k:s/^/*<CR>:nohl<CR>
" Comment color
:highlight Comment ctermfg=blue 

"Line Number
:highlight LineNr ctermfg=red

"Number color
:highlight Number ctermfg=red

"Fold
:highlight Folded ctermfg=green
:highlight Folded ctermbg=black

"Color type
:highlight Type ctermfg=green

"Search color
:highlight Search ctermbg=blue 
:highlight Search ctermfg=white 

"Syntax function color
:syntax keyword cFunction printf  abs fabs puts scanf 
:highlight link cFunction Function 
:highlight Function ctermfg=11 cterm=bold

"Fold
"setlocal foldmethod=syntax
"setlocal foldignore=

"plugin for C
:function! Lst()
  :call append('0','#include <stdio.h>')
  :call append('1','#define EXIT_SUCESS 0')
endfunction

"function define
:function! Def()
 :call append('2','#define <++>')
:endfunction

"function define
:function! Inc()
 :call append('2','#include <++>')
:endfunction

" macro
:nnoremap <F4> viw~<ESC>A<space>
"call Library 
:nnoremap <leader>lb :call Lst()<CR>

"define
:nnoremap <silent><leader>de :call Def()<CR> 

"include
:nnoremap <silent><leader>ic :call Inc()<CR> 

"fucntions 
:nnoremap <leader>fun :r /home/jefferson/.config/nvim/after/template/C/function.txt <CR> 

"main
:nnoremap <leader>t1 :r /home/jefferson/template/template.c <CR> <bar>ggdd3j
:nnoremap <leader>mv :<ESC>iint main(void){<ESC>oreturn EXIT_SUCESS;<ESC>o}<ESC>
:nnoremap <leader>ma :<ESC>iint main(int argc, char *argv[]){<ESC>oreturn EXIT_SUCESS;<ESC>o}<ESC>
 
"structure loop
"for
:inoremap <leader>for for (int i = 0; i <= n; i++){<ESC>o}<ESC>O
"while
:inoremap <leader>wh while (){<ESC>o}<ESC>1k6la

"Do while
:inoremap <leader>do do{<+Arguments+>}<ESC>owhile (<+Condicion+>)<ESC>01k

"if
:inoremap <leader>if if(){<ESC>o <+Arguments+> <ESC>o}<ESC>2k2la

"ifelse
":inoremap <leader>il :<ESC>oif(<++>){<ESC>o}else{<ESC>o<++><ESC>o}<ESC>3k<ESC>z
:inoremap <leader>il if(<++>){<ESC>o}else{<ESC>o<++><ESC>o}<ESC>3k<ESC>z


"Atalhos
:inoremap { {}<ESC>i
:inoremap ( ()<ESC>i
:inoremap [ []<ESC>i
:inoremap " ""<ESC>i

"Compementation
:inoremap \c :<ESC>a<c-x><c-n>
"name
:inoremap -na <ESC>"%pa

"date
:inoremap -da <ESC>:pu = strftime('%a %d %b %Y %H:%M')<CR><ESC>i<BS><ESC>$a

"gcc
:nnoremap  <F2> :!nbc -b %  <CR>
:nnoremap  <F3> :!nbc -d -S=usb %  <CR>
:nnoremap  <F4> :!nbc -r -S=usb %  <CR>

if (&ft!='c')
    finish
endif

set path+=/usr/include/

