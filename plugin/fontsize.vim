command! Fontsize call ChangeFontsize()
function! ChangeFontsize()

  if !has('gui_running')
    echohl Error
    echo 'You need to run the GUI version of Vim to use this function.'
    echohl None
    return
  endif

  " Extract font info from font list in &guifont as several lists.
  " Break each font down as "name:size:otheropt" while break "size" down to
  " "dimension" and "number".
  " Set default size for each font if not present.
  " An escaped comma can be included in a font name.
  let l:fontlist = split(&guifont, '[^\\]\zs,')
  let l:names = []
  let l:dimens = []
  let l:sizes = []
  let l:otherOpts = []
  let i = 0
  for l:font_ in l:fontlist
    let l:font_Opts = split(l:font_, ':')
    if len(l:font_Opts) < 2
      let l:font_Opts = [l:font_, 'h10']
    endif
    if l:font_Opts[1] !~ '\v^[hw]\d+(\.\d+)?'
      let l:font_Opts = [l:font_Opts[0], 'h10'] + l:font_Opts[1:]
    endif
    let l:font_Size = l:font_Opts[1]
    let l:font_SizeParts = split(font_Size, '[hw]\zs\ze')
    let l:names = l:names + [l:font_Opts[0]]
    let l:dimens = l:dimens + [l:font_SizeParts[0]]
    let l:sizes = l:sizes + [l:font_SizeParts[1]]
    let l:otherOpts = l:otherOpts + ['']
    if len(l:font_Opts) > 2
      let l:otherOpts[i] = join(l:font_Opts[2:], ':')
    endif
    let i = i + 1
  endfor

  echo "Press '+' to largen or '-' to shrink the font. '<Esc>' to quit."
  let l:step = 0.5

  " Query operation circularly and apply to every font in &guifont.
  let l:operator = nr2char(getchar())
  while l:operator != "\<Esc>"
    if l:operator == '+' || l:operator == '='
      let l:increment = l:step
    elseif l:operator == '-'
      let l:increment = -l:step
    else
      if l:operator == ':'
        " Press ':' to quit and enter command-line mode.
        call feedkeys("\<Esc>:", 'n')
      endif
      let l:operator = 'none'
    endif
    if l:operator != 'none'
      let i = 0
      for size in l:sizes
        let size = str2float(size) + l:increment
        " Must keep the data type of l:sizes' items as string so that
        " str2float can be used without fault.
        let l:sizes[i] = string(size)
        let l:fontlist[i] = l:names[i] . ':' . l:dimens[i] . l:sizes[i]
        if l:otherOpts[i] != ''
          let l:fontlist[i] = l:fontlist[i] . ':' . l:otherOpts[i]
        endif
        let i = i + 1
      endfor
      let &guifont = join(l:fontlist, ',')
      " Must redraw to make the change take effect.
      redraw
      set guifont?
    endif
    let l:operator = nr2char(getchar())
  endwhile
  redraw

endfunction
