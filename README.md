# vim-c2view

Color code preview in vim popup

## :sparkles:Features

- [CSS color](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value) preview (not support color keyword)

![screen](https://raw.githubusercontent.com/sabiz/vim-c2view/doc/screen.gif)

## :egg:Requirement

- Vim 8.1.1391 or later 
  - must be compiled with `+popupwin` feature

## :hatching_chick:Installation

### Vim Packages

~~~shell
cd $HOME/.vim/pack/plugin
git clone https://github.com/sabiz/vim-c2view
~~~

You can use  plugin manager (e.g. [vim-plug](https://github.com/junegunn/vim-plug)

## :hatched_chick:Getting started

1. Open style sheet file
2. Keep cursor on color code (wait for  [[updatetime](https://vimhelp.org/options.txt.html#%27updatetime%27)])



## :chicken:TODO

- Support Real-valued function syntax (e.g. rgba(1e2, .5e1, .5e0, +.25e2%) 
- Support other file types
- Support SASS functions

## License

[MIT License](LICENSE) :copyright: [sAbIz](https://github.com/sabiz):jp:


