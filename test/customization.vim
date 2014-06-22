function! AddLine(str)
    put! =a:str
endfunction

let s:assert = themis#helper('assert')
function! s:assert.cursor(l, c, ch)
    call s:assert.equals([line('.'), col('.'), getline('.')[col('.')-1]], [a:l, a:c, a:ch])
endfunction

function! s:assert.not_moves_cursor(cmd)
    let p = deepcopy(getpos('.'))
    execute a:cmd
    call s:assert.equals(getpos('.'), p)
endfunction

function! s:assert.moves_cursor(cmd)
    let p = deepcopy(getpos('.'))
    execute a:cmd
    call s:assert.not_equals(getpos('.'), p)
endfunction

let s:suite = themis#suite('customization')

function! s:suite.before_each(...)
    new
    call clever_f#reset()
endfunction

function! s:suite.after_each(...)
    let g:clever_f_ignore_case = 0
    let g:clever_f_use_migemo = 0
    let g:clever_f_fix_key_direction = 0
    let g:clever_f_smart_case = 0
    let g:clever_f_chars_match_any_signs = ''
    let g:clever_f_mark_cursor = 1
    let g:clever_f_hide_cursor_on_cmdline = 1
    close!
endfunction

function! s:suite.ignore_case()
    let g:clever_f_ignore_case = 1
    call AddLine('poge Guga hiyo Go;yo;')

    normal! gg0
    let l = line('.')

    normal fg
    call s:assert.cursor(l, 3, 'g')

    normal f
    call s:assert.cursor(l, 6, 'G')

    normal f
    call s:assert.cursor(l, 8, 'g')

    normal F
    call s:assert.cursor(l, 6, 'G')
endfunction

function! s:suite.ignore_case_makes_no_effect_on_searching_signs()
    let g:clever_f_ignore_case = 1
    call AddLine('poge Guga hiyo Go;yo;')

    normal! 0
    normal f;
    call s:assert.equals(col('.'), 18)
    normal f
    call s:assert.equals(col('.'), 21)
    call s:assert.not_moves_cursor('normal f')
endfunction

function! s:suite.test_migemo_f_F()
    let g:clever_f_use_migemo = 1
    call AddLine('はー，ビムかわいいよビム')
    normal! gg0

    normal fb
    call s:assert.equals(col('.'), 10)
    normal f
    call s:assert.equals(col('.'), 31)
    normal F
    call s:assert.equals(col('.'), 10)
    normal $
    normal Fb
    call s:assert.equals(col('.'), 31)
    normal f
    call s:assert.equals(col('.'), 10)
    normal F
    call s:assert.equals(col('.'), 31)
endfunction

function! s:suite.test_migemo_t_T()
    let g:clever_f_use_migemo = 1
    call AddLine('はー，ビムかわいいよビム')
    normal! gg0

    normal tb
    call s:assert.equals(col('.'), 7)
    normal t
    call s:assert.equals(col('.'), 28)
    normal T
    call s:assert.equals(col('.'), 13)
    normal $
    normal Tb
    call s:assert.equals(col('.'), 13)
    normal T
    call s:assert.equals(col('.'), 28)
    normal t
    call s:assert.equals(col('.'), 13)
endfunction

function! s:suite.fix_key_direction_f_F()
    let g:clever_f_fix_key_direction = 1
    call AddLine('poge huga hiyo poyo')
    normal! gg0

    normal fofff
    call s:assert.equals(col('.'), 19)
    normal F
    call s:assert.equals(col('.'), 17)
    normal F
    call s:assert.equals(col('.'), 14)
    normal F
    call s:assert.equals(col('.'), 2)
    normal $
    normal Fo
    call s:assert.equals(col('.'), 17)
    normal F
    call s:assert.equals(col('.'), 14)
    normal F
    call s:assert.equals(col('.'), 2)
endfunction

function! s:suite.fix_key_direction_t_T()
    let g:clever_f_fix_key_direction = 1
    call AddLine('poge huga hiyo poyo')
    normal! gg0

    normal tott
    call s:assert.equals(col('.'), 18)
    normal T
    call s:assert.equals(col('.'), 15)
    normal T
    call s:assert.equals(col('.'), 3)
    normal $
    normal To
    call s:assert.equals(col('.'), 18)
    normal T
    call s:assert.equals(col('.'), 15)
    normal T
    call s:assert.equals(col('.'), 3)
endfunction

function! s:suite.smart_case_f()
    call AddLine('poHe huga Hiyo hoyo: poyo();')
    normal! gg0
    let g:clever_f_smart_case = 1

    normal fh
    call s:assert.equals(col('.'), 3)
    normal f
    call s:assert.equals(col('.'), 6)
    normal f
    call s:assert.equals(col('.'), 11)
    normal f
    call s:assert.equals(col('.'), 16)
    normal F
    call s:assert.equals(col('.'), 11)

    normal 0
    normal fH
    call s:assert.equals(col('.'), 3)
    normal f
    call s:assert.equals(col('.'), 11)
    normal f
    call s:assert.equals(col('.'), 11)
    normal F
    call s:assert.equals(col('.'), 3)
endfunction

function! s:suite.smart_case_t()
    call AddLine('poHe huga Hiyo hoyo: poyo();')
    normal! gg0
    let g:clever_f_smart_case = 1

    normal! $
    normal Th
    call s:assert.equals(col('.'), 17)
    normal t
    call s:assert.equals(col('.'), 12)
    normal t
    call s:assert.equals(col('.'), 7)
    normal t
    call s:assert.equals(col('.'), 4)
    normal T
    call s:assert.equals(col('.'), 5)

    normal! $
    normal TH
    call s:assert.equals(col('.'), 12)
    normal t
    call s:assert.equals(col('.'), 4)
    normal T
    call s:assert.equals(col('.'), 10)
endfunction

function! s:suite.smart_case_makes_no_effect_on_searching_signs()
    call AddLine('poHe huga Hiyo hoyo: poyo();')
    normal! gg0
    let g:clever_f_smart_case = 1

    normal! 0
    normal f;
    call s:assert.equals(col('.'), 28)
    normal! 0
    call s:assert.not_moves_cursor('normal f"')
endfunction

function! s:suite.chars_match_any_signs()
    call AddLine(' !"#$%&''()=~|\-^\@`[]{};:+*<>,.?_/')
    let g:clever_f_chars_match_any_signs = ';'
    normal! gg0

    normal f;
    call s:assert.equals(col('.'), 2)
    for i in range(3, 34)
        normal f
        call s:assert.equals(col('.'), i)
    endfor

    call s:assert.not_moves_cursor('normal f')

    for i in reverse(range(2, 33))
        normal F
        call s:assert.equals(col('.'), i)
    endfor

    call s:assert.not_moves_cursor('normal F')
endfunction

function! s:suite.test_mark_cursor()
    let g:clever_f_mark_cursor = 1
    call AddLine('poge huga hiyo poyo')

    normal fh
    call s:assert.equals(filter(getmatches(), 'v:val.group!="CleverFCursor"'), [])
    normal fq
    call s:assert.equals(filter(getmatches(), 'v:val.group!="CleverFCursor"'), [])
endfunction

function! s:suite.test_hiding_cursor()
    let g:clever_f_mark_cursor = 1
    let g:clever_f_hide_cursor_on_cmdline = 1
    call AddLine('poge huga hiyo poyo')
    normal! gg0

    let guicursor = &guicursor
    let t_ve = &t_ve
    normal fh
    call s:assert.equals(guicursor, &guicursor)
    call s:assert.equals(t_ve, &t_ve)
    normal fq
    call s:assert.equals(guicursor, &guicursor)
    call s:assert.equals(t_ve, &t_ve)
endfunction
