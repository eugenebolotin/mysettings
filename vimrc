syntax on
set cindent
set smartindent
set autoindent
set expandtab
set bs=2
set tabstop=4
set shiftwidth=4
" Переключение директории в текущий открытый файл
set autochdir
" Список команд с данным началом по Ctrl+D, а также список файлов по Tab
set wildmenu
set wildmode=longest,list
set wcm=<TAB>
" Поиск во время набирания строки
set incsearch
set nohlsearch

" Поиск без учета регистра (smartcase - если шаблон поиска написан маленькими буквами)
set ignorecase
set smartcase

" Автоматическая загрузка изменений файла с диска
set autoread

" F9 - Клавиша переключения режима замены таба на пробелы 
function TabToggle()
    if &expandtab
        set noexpandtab
    else
        set expandtab
    endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

" F12 - Клавиша переключения режима вставки (его стоит ключить, чтобы при вставке не сбивалось форматирование)
set pastetoggle=<F12>
colorscheme peachpuff

" Если файл измениться где-то вне редактора, появиться сообщение об изменении файла
autocmd CursorMoved * exec( ':checktime' )

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

autocmd BufReadPre wscript set filetype=python
autocmd BufReadPre wscript set filetype=python

" F8 - Меню выбора кодировки
menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=unix<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=unix<CR>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>

map <S-F3> :%!astyle -D -p -b -v<cr>

function AddHeaderGuard()

    let s:uppercase_filename = tr(toupper(expand("%:t:r")), ".", "_" )
    let s:uppercase_extension = toupper(expand("%:t:e"))

    " The current file might not have been saved, hence it wouldn't have a
    " filename. In this case s:uppercase_filename would be empty. The
    " function will only do stuff if uppercase_filename is nonempty

    if strlen( s:uppercase_extension ) == 0
        return
    endif

    if s:uppercase_extension != "h" && s:uppercase_extension != "hpp"
        return
    endif

    if strlen(s:uppercase_filename) != 0
        
        let s:header_guard = s:uppercase_filename . "_H"

        " It's possible the user has already created ifndef guard code
        " (or called this function on this file), so we need to check
        " for that... in a later version. >:)
        
        " Add the text to the start and end of the file.

        call append(0, "#ifndef ".s:header_guard)
        call append(1, "#define ".s:header_guard)

        let s:last_line = line('$')

        call append(s:last_line, "#endif")

    endif

endfunction

autocmd BufNewFile * exec( ':call AddHeaderGuard()' )
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

function! PyflakesCheck()
    cclose
    setlocal makeprg=pyflakes\ %
    silent make
    cwindow
    redraw!
endfunction

function! PylintCheck()
    cclose
    setlocal makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
    setlocal errorformat=%f:%l:\ %m
    silent make
    copen
    redraw!
endfunction


nmap <S-F6> :call PyflakesCheck()<CR>
nmap <S-F7> :call PylintCheck()<CR>
nmap <S-F12> :!chmod +x %<CR><CR>

set noswapfile 


function StartPyclewn()
    :Pyclewn
    :Cmapkeys
endfunction    

nnoremap <F11> :call StartPyclewn()<CR>
