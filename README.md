dlx-ls
======

an implementation of Knuth's [DLX algorithm][dancing-links] in [LoomScript][loom-sdk]

- [installation](#installation)
- [usage](#usage)
- [building](#building)
- [contributing](#contributing)


## installation

Download the library into its matching sdk folder:

    $ curl -L -o ~/.loom/sdks/sprint34/libs/DLX.loomlib \
        https://github.com/pixeldroid/dlx-ls/releases/download/v1.0.0/DLX-sprint34.loomlib

To uninstall, simply delete the file:

    $ rm ~/.loom/sdks/sprint34/libs/DLX.loomlib


## usage

_TODO_


## building

first, install [loomtasks][loomtasks] and the [spec-ls library][spec-ls]

### compiling from source

    $ rake lib:install

this will build the DLX library and install it in the currently configured sdk

### running tests

    $ rake test

this will build the DLX library, install it in the currently configured sdk, build the test app, and run the test app.


## contributing

Pull requests are welcome!


[dancing-links]: https://www.ocf.berkeley.edu/~jchu/publicportal/sudoku/0011047.pdf "Dancing Links, Donald E. Knuth"
[loom-sdk]: https://github.com/LoomSDK/LoomSDK "a native mobile app and game framework"
[loomtasks]: https://github.com/pixeldroid/loomtasks "Rake tasks for working with loomlibs"
[spec-ls]: https://github.com/pixeldroid/spec-ls "a simple spec framework for Loom"
