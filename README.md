# vim-fontsize

Change font size easily.

## Usage

1. Run `:Fontsize` to enter the state of changing font size.
2. Simply press `+` (or `=`) and `-` to increase and decrease the font size respectively. It changes font size by 0.5 in height or width every time.
3. Press `<Esc>` to quit the state.

It works by changing option `guifont`. Read `:help 'guifont'` to find if your system uses this option.
