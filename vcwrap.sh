#!/bin/sh
if ! test -d $HOME/.wine; then
    echo >&2 "Please run vcinstall.sh first to setup your compiler and ~/.wine!!"
    exit 2
fi
set -e
TMP=$HOME/.wine/drive_c/windows/temp/$$.bat
cat > "$TMP" <<EOF
@set VC=%CommonProgramFiles%\\Microsoft\\Visual C++ for Python\\9.0\\
@call "%VC%vcvarsall.bat" amd64
$(basename $0) %*
EOF
export WINEDEBUG=-all
set +e
wine cmd.exe /c "C:\\Windows\\Temp\\$(basename $TMP)" "$@"
rc=$?
rm -f "$TMP"
exit $rc
