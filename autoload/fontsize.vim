function! fontsize#Change()

  if !has('gui_running')
    echohl Error
    echo 'You need to run the GUI version of Vim to use this function.'
    echohl None
    return
  endif

  " Extract font specifications from font list in &guifont as several lists.
  " Break each font specification down as "name:size:otheropt" while breaking
  " "size" down to "dimension" and "number".
  " Set default size for each font if not present.

  " Choose the separator carefully, as an escaped comma can be included in a
  " font name.
  let l:fontlist = split(&guifont, '[^\\]\zs,')
  let l:names = []
  let l:dimens = []
  let l:sizes = []
  let l:otherOpts = []
  let i = 0
  for l:font in l:fontlist
    let l:fontOpts = split(l:font, ':')
    if len(l:fontOpts) < 2
      let l:fontOpts = [l:font, 'h10']
    endif
    if l:fontOpts[1] !~ '\v^[hw]\d+(\.\d+)?'
      let l:fontOpts = [l:fontOpts[0], 'h10'] + l:fontOpts[1:]
    endif
    let l:fontSize = l:fontOpts[1]
    let l:fontSizeParts = split(fontSize, '[hw]\zs\ze')
    let l:names = l:names + [l:fontOpts[0]]
    let l:dimens = l:dimens + [l:fontSizeParts[0]]
    let l:sizes = l:sizes + [l:fontSizeParts[1]]
    let l:otherOpts = l:otherOpts + ['']
    if len(l:fontOpts) > 2
      let l:otherOpts[i] = join(l:fontOpts[2:], ':')
    endif
    let i = i + 1
  endfor

  echo "Press '+' to largen or '-' to shrink the font. '<Esc>' to quit."
  let l:step = 0.5

  " Request an operation circularly and apply the change to the size number of
  " every font in &guifont.
  " During this process, the full specification of each font is assembled
  " again from its name, size and other options.
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

