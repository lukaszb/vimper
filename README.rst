======
vimper
======

vimper is yet another vim plugins configuration manager.


Installation
------------

As with usual Python package, simply run::

    $ pip install vimper


Once vimper is installed just run::

    $ vimper update


This would backup existing vim files installation and create links to the
vimper lair's repository. Vimper lair is simple repository that contains
very simple vim + pathogen_ setup + some basic .vimrc and .gvimrc configs.

Want an one liner?

    git clone git://github.com/lukaszb/vimper.git ~/.vimper && cd ~/.vimper && python bootstrap.py


Configuration
-------------

You may want to configure some parts of your vim, i.e. default background style
or directory path where nerd tree should open by default. Guess what? It's
extremely easy to accomplish!

There are 4 files that might be created for that:

- *.vimrc.before* - configuration file loaded before vimper's *.vimrc*
- *.vimrc.local* - confiuration file loaded after vimper's *.vimrc*
- *.gvimrc.before* - as above but for gui vim
- *.gvimrc.local* - as above but for gui vim

So, let's say you want to change default NERDTree path and set background style
to *light*:

    $ cat - > .gvimrc.before
    set bg=light
    let GUI_NERDTREE_DEFAULT_PATH="~/develop/workspace/"

It needs to be *.gvimrc.before* as *GUI_NERDTREE_DEFAULT_PATH* is checked
during *.gvimrc* configuration.

.. _macvim: http://code.google.com/p/macvim/
.. _pathogen: https://github.com/tpope/vim-pathogen
