#!/bin/sh
/usr/bin/wine winecfg
ln -sfn /var/tmp/VCForPython27.msi $HOME/.wine/drive_c
/usr/bin/wine msiexec /i C:/VCForPython27.msi /qn /log C:/install.log
ln -sfn .wine/drive_c/Program\ Files\ \(x86\)/Common\ Files/Microsoft/Visual\ C++\ for\ Python/9.0 $HOME/vcpython27
