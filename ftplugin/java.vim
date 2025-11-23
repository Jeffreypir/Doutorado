"Java compile 

"Atalhos
:inoremap { {}<ESC>i
:inoremap ( ()<ESC>i
:inoremap [ []<ESC>i
:inoremap " ""<ESC>i

"main
:nnoremap <leader>ma :<ESC>ipublic static void main(String[] args){<ESC>o<++><ESC>o}<ESC>
:nnoremap <leader>Ma :<ESC>ipublic class Main {<ESC>o<++><ESC>o}<ESC>

 
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

"print 
:inoremap <leader>pr System.out.printf("<++Message++>");<ESC>

 "Compementation
:inoremap \c :<ESC>a<c-x><c-n>
"name
:inoremap -na <ESC>"%pa

"date
:inoremap -da <ESC>:pu = strftime('%a %d %b %Y %H:%M')<CR><ESC>i<BS><ESC>$a


