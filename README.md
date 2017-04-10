# vim-fontsize

Change font size incrementally by one-key typing.

Currently only works on Windows and Mac OS X (not tested).

## Usage

1. Run `:Fontsize` to enter the state of changing font size.
2. Press `+`/`=` and `-` to increase and decrease the font size respectively,
   by 0.5 in height, if width is not the only dimension found in the 'guifont'
   setting, or width every time.
3. Press `<Esc>` to quit the state.

It works by changing option `guifont`. Refer to `:help 'guifont'` to find if
your system uses this option.
