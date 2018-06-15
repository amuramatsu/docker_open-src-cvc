#! /bin/sh
docker run -u $UID -v "$(pwd):/work" --rm -it amura/open-src-cvc /usr/bin/cvc64 "$@"
if [ -f cvcsim ]; then
    mv cvcsim cvcsim.bin
    cat <<'EOF' > cvcsim
#! /bin/sh
exec docker run -u $UID -v "$(pwd):/work" --rm -it amura/open-src-cvc ./cvcsim.bin "$@"
EOF
    chmod +x cvcsim
fi
