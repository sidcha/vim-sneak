
func! sneak#hl#removehl() "remove highlighting
  silent! call matchdelete(w:sneak_hl_id)
  silent! call matchdelete(w:sneak_sc_hl)
endf

" gets the 'links to' value of the specified highlight group, if any.
func! sneak#hl#links_to(hlgroup)
  redir => hl | exec 'silent highlight '.a:hlgroup | redir END
  let s = substitute(matchstr(hl, 'links to \zs.*'), '\s', '', 'g')
  return empty(s) ? 'NONE' : s
endf

func! sneak#hl#get(hlgroup) "gets the definition of the specified highlight
  if !hlexists(a:hlgroup)
    return ""
  endif
  redir => hl | exec 'silent highlight '.a:hlgroup | redir END
  return matchstr(hl, '\%(.*xxx\)\?\%(.*cleared\)\?\s*\zs.*')
endf

func! s:init()
  let magenta = (&t_Co < 256 ? "magenta" : "201")

  if 0 == hlID("SneakTarget") || "" == sneak#hl#get("SneakTarget")
    exec "highlight SneakTarget guifg=white guibg=magenta ctermfg=white ctermbg=".magenta
  endif

  if 0 == hlID("SneakLabelMask") || "" == sneak#hl#get("SneakLabelMask")
    exec "highlight SneakLabelMask guifg=magenta guibg=magenta ctermfg=".magenta." ctermbg=".magenta
  endif

  if 0 == hlID("SneakScope") || "" == sneak#hl#get("SneakScope")
    if &background ==# 'dark'
      highlight SneakScope guifg=black guibg=white ctermfg=black ctermbg=white
    else
      highlight SneakScope guifg=white guibg=black ctermfg=white ctermbg=black
    endif
  endif

  if 0 == hlID("SneakLabelTarget") || "" == sneak#hl#get("SneakLabelTarget")
    exec "highlight SneakLabelTarget guibg=magenta guifg=white gui=bold ctermbg=".magenta." ctermfg=white cterm=bold"
  endif

  if has('gui_running') || -1 != match(sneak#hl#get('Cursor'), 'ctermbg')
    highlight link SneakCursor Cursor
  else
    highlight link SneakCursor SneakScope
  endif
endf

augroup sneak_colorscheme " re-init if :colorscheme is changed at runtime. #108
  autocmd!
  autocmd ColorScheme * call <sid>init()
augroup END

call s:init()
