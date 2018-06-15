#! /bin/sh

if [ x"$1" != x"" ]; then
  case "$1" in
    show-license)
	cat /OSS-CVC-MOD-ARTISTIC-LIC.TXT
	exit 0;;
    show-cvc_cmd)
	cat /cvc_cmd.sh
	exit 0;;
    show-cc_cmd)
	cat /cc_cmd.sh
	exit 0;;
    help)
	echo "show-license : display license of CVC"
	echo "show-cvc_cmd : show example of cvc script"
	echo "show-cc_cmd : show example of cc script for PLI"
	exit 0;;
  esac
fi

exec "$@"
