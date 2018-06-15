#! /bin/sh
exec docker run -u $UID -v "$(pwd):/work" --rm -it amura/open-src-cvc /usr/bin/gcc "$@"
