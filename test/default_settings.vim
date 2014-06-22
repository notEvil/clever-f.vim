let s:suite = themis#suite('default_settings')
let s:assert = themis#helper('assert')

function! s:assert.exists_and_defaults_to(e, v)
    call self.exists(a:e)
    call self.equals({a:e}, a:v)
endfunction

function! s:suite.test_loaded()
    call s:assert.exists('g:loaded_clever_f')
endfunction

function! s:suite.test_mapping()
    call s:assert.equals(maparg('<Plug>(clever-f-f)', 'nv'), "clever_f#find_with('f')")
        call s:assert.equals(maparg('<Plug>(clever-f-F)', 'nv'), "clever_f#find_with('F')")
        call s:assert.equals(maparg('<Plug>(clever-f-t)', 'nv'), "clever_f#find_with('t')")
        call s:assert.equals(maparg('<Plug>(clever-f-T)', 'nv'), "clever_f#find_with('T')")
        call s:assert.equals(maparg('<Plug>(clever-f-reset)', 'nv'), 'clever_f#reset()')
        call s:assert.equals(maparg('<Plug>(clever-f-repeat-forward)', 'nv'), 'clever_f#repeat(0)')
        call s:assert.equals(maparg('<Plug>(clever-f-repeat-back)', 'nv'), 'clever_f#repeat(1)')
endfunction

function! s:suite.test_autoload_function()
    try
        " load autoload functions
        runtime autoload/clever_f.vim
        runtime autoload/clever_f/helper.vim
    catch
    endtry
    call s:assert.exists('*clever_f#find_with')
    call s:assert.exists('*clever_f#reset')
    call s:assert.exists('*clever_f#repeat')
    call s:assert.exists('*clever_f#helper#system')
    call s:assert.exists('*clever_f#helper#strchars')
    call s:assert.exists('*clever_f#helper#include_multibyte_char')
endfunction

function! s:suite.test_default_variables()
    call s:assert.exists_and_defaults_to ('g:clever_f_across_no_line', 0)
    call s:assert.exists_and_defaults_to ('g:clever_f_ignore_case', 0)
    call s:assert.exists_and_defaults_to ('g:clever_f_use_migemo', 0)
    call s:assert.exists_and_defaults_to ('g:clever_f_fix_key_direction', 0)
    call s:assert.exists_and_defaults_to ('g:clever_f_show_prompt', 0)
    call s:assert.exists_and_defaults_to ('g:clever_f_smart_case', 0)
    call s:assert.exists_and_defaults_to ('g:clever_f_chars_match_any_signs', '')
    call s:assert.exists_and_defaults_to ('g:clever_f_mark_cursor_color', 'Cursor')
    call s:assert.exists_and_defaults_to ('g:clever_f_mark_cursor', 1)
    call s:assert.exists_and_defaults_to ('g:clever_f_hide_cursor_on_cmdline', 1)
endfunction
