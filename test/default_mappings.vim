function! AddLine(str)
    put! =a:str
endfunction

let s:suite = themis#suite('default_mappings')
let s:assert = themis#helper('assert')

function! s:assert.cursor(l, c, ch)
    call s:assert.equals([line('.'), col('.'), getline('.')[col('.')-1]], [a:l, a:c, a:ch])
endfunction

function! s:suite.before_each(...)
    new
    call clever_f#reset()
endfunction

function! s:suite.after_each(...)
    close!
endfunction

function! s:suite.test_f()
    call AddLine('poge huga hiyo poyo')

    normal! 0
    let l = line('.')
    call s:assert.cursor(l,1,'p')

    normal fh
    call s:assert.cursor(l,6,'h')

    normal f
    call s:assert.cursor(l,11,'h')

    normal! e
    call s:assert.cursor(l,14,'o')

    normal fo
    call s:assert.cursor(l,17,'o')

    normal f
    call s:assert.cursor(l,19,'o')
endfunction

function! s:suite.test_F()
    call AddLine('poge huga hiyo poyo')

    normal! $
    let l = line('.')
    call s:assert.cursor(l,19,'o')

    normal Fo
    call s:assert.cursor(l,17,'o')

    normal f
    call s:assert.cursor(l,14,'o')

    normal! h

    normal Fh
    call s:assert.cursor(l,11,'h')

    normal f
    call s:assert.cursor(l,6,'h')
endfunction

function! s:suite.test_t()
    call AddLine('poge huga hiyo poyo')

    normal! 0
    let l = line('.')
    call s:assert.cursor(l,1,'p')

    normal th
    call s:assert.cursor(l,5,' ')

    normal t
    call s:assert.cursor(l,10,' ')

    normal! e
    call s:assert.cursor(l,14,'o')

    normal to
    call s:assert.cursor(l,16,'p')

    normal t
    call s:assert.cursor(l,18,'y')
endfunction

function! s:suite.test_T()
    call AddLine('poge huga hiyo poyo')

    normal! $
    let l = line('.')
    call s:assert.cursor(l,19,'o')

    normal To
    call s:assert.cursor(l,18,'y')

    normal t
    call s:assert.cursor(l,15,' ')

    normal! h

    normal Th
    call s:assert.cursor(l,12,'i')

    normal t
    call s:assert.cursor(l,7,'u')
endfunction

function! s:suite.test_different_context_between()
    call AddLine('poge huga hiyo poyo')

    let l = line('.')
    call s:assert.cursor(l, 1, 'p')

    normal fo
    call s:assert.cursor(l, 2, 'o')

    normal vfh
    call s:assert.cursor(l, 6, 'h')

    normal f
    call s:assert.cursor(l, 11, 'h')

    normal! d
    call s:assert.equals(getline('.'), "piyo poyo")
    call s:assert.cursor(l, 2, 'i')

    normal! dfp
    call s:assert.equals(getline('.'), "poyo")
    call s:assert.cursor(l, 2, 'o')
endfunction

function! s:suite.test_f_and_F_have_same_context()
    call AddLine('poge huga hiyo poyo')

    normal! 0
    let l = line('.')

    normal fh
    call s:assert.cursor(l,6,'h')
    normal f
    call s:assert.cursor(l,11,'h')
    normal F
    call s:assert.cursor(l,6,'h')
    normal f
    call s:assert.cursor(l,11,'h')
endfunction

function! s:suite.non_existent_char_makes_no_change()
    call AddLine('poge huga hiyo poyo')

    normal! 0
    let [l, c, ch] = [line('.'), col('.'), getline('.')[col('.')-1]]

    normal fd
    call s:assert.cursor(l, c, ch)
    normal f1
    call s:assert.cursor(l, c, ch)
    normal f)
    call s:assert.cursor(l, c, ch)
    normal f^
    call s:assert.cursor(l, c, ch)
    normal fm
    call s:assert.cursor(l, c, ch)
endfunction

function! s:suite.corsor_moves_forward_accross_lines()
    call AddLine('foo bar baz')
    call AddLine('poge huga hiyo poyo')

    normal! 0
    let l = line('.')
    call s:assert.equals(col('.'), 1)

    normal fa
    call s:assert.cursor(l, 9, 'a')

    normal f
    call s:assert.cursor(l+1, 6, 'a')

    normal f
    call s:assert.cursor(l+1, 10, 'a')

    normal F
    call s:assert.cursor(l+1, 6, 'a')

    normal F
    call s:assert.cursor(l, 9, 'a')
endfunction

function! s:suite.cursor_moves_backward_accross_lines()
    call AddLine('foo bar baz')
    call AddLine('poge huga hiyo poyo')

    normal! Gk$
    let l = line('.')
    call s:assert.equals(col('.'), 11)

    normal Fa
    call s:assert.cursor(l, 10, 'a')

    normal f
    call s:assert.cursor(l, 6, 'a')

    normal f
    call s:assert.cursor(l-1, 9, 'a')

    normal F
    call s:assert.cursor(l, 6, 'a')

    normal F
    call s:assert.cursor(l, 10, 'a')
endfunction

function! s:suite.test_multibyte_characters()
    call AddLine('ビムかわいいよzビムx')
    call AddLine('foo bar baz')

    normal! gg0
    let l = line('.')

    normal fz
    call s:assert.cursor(l, 11, 'z')

    normal f
    call s:assert.cursor(l+1, 22, 'z')

    normal! h
    normal fx
    call s:assert.cursor(l+1, 29, 'x')
endfunction

function! s:suite.test_special_keys()
    call AddLine('poge huga hiyo poyo')

    let pos = getpos('.')
    execute 'normal' "f\<F1>"
    execute 'normal' "f\<Left>"
    execute 'normal' "f\<BS>"
    execute 'normal' "f\<Esc>"
    call s:assert.equals(pos, getpos('.'))
endfunction
