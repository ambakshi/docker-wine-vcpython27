#!/bin/sh
TMP=$HOME/.wine/drive_c/windows/temp/$$.bat
cat > "$TMP" <<EOF
@set VC=C:\\Program Files (x86)\\Common Files\\Microsoft\\Visual C++ for Python\\9.0"
@call "%VC%\\vcvarsall.bat"
$(basename $0) %*
EOF
wine cmd.exe /c "C:\\Windows\\Temp\\$(basename $TMP)" "$@"
rc=$?
rm -f "$TMP"
exit $rc
