""""""""""""
" Load guard
""""""""""""

if exists('g:loaded_recipes_ctrlp') && g:loaded_recipes_ctrlp
    finish
endif

let g:loaded_recipes_ctrlp = 1

call recipes#load()

""""""
" Vars
""""""

call add(g:ctrlp_ext_vars, {
\   'init': 'recipes#ctrlp#init()',
\   'accept': 'recipes#ctrlp#accept',
\   'lname': 'recipes',
\   'sname': 'rcp',
\   'type': 'path',
\   'sort': 0,
\   'nolim': 1,
\})

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

""""""""
" Public
""""""""

function! recipes#ctrlp#init()

    setlocal filetype=recipes.vim encoding=utf-8 scrolloff=0 nolist
    setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 cursorline

    return g:recipes_list
endf

function! recipes#ctrlp#accept(mode, choice)

    call ctrlp#exit()

    let choice = substitute(a:choice, g:recipes_mrk_ptr, '', '')
    let action = g:recipes_cmds[choice]
    let cmd    = {
    \   'h':      ':bo ' . action.help,
    \   't':     ':tab ' . action.help,
    \   'v': ':bo vert ' . action.help,
    \   'e': action.keycode
    \ }[a:mode]

    let type = cmd =~ '^[:/?]' ? cmd[0] : '@'
    let hist = cmd !~ '^[:/?]' ? cmd : cmd =~ "\r$" ? cmd[1:-2] : ''

    call feedkeys(cmd)
    call histadd(type, hist)
endf

function! recipes#ctrlp#id()

    return s:id
endf
