#! /bin/sh
exec docker run -u $(id -u) -v "$(pwd):/work" --rm -it amura/open-src-cvc /usr/bin/gcc "$@"
