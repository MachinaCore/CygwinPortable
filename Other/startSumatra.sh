#!/bin/bash

# startSumatra.sh
# This script launches SumatraPDFPortable from Cygwin and automatically
# updates the inverse search command to reflect the current drive letter
# of the USB stick.

# The inspiration for this comes from cyg-wrapper.sh, using the
# --fork=2 option
comspec=$(cygpath -u $COMSPEC)

$comspec /c start $USBDRV/PortableApps/SumatraPDFPortable/SumatraPDFPortable.exe -inverse-search "\"$USBDRV\\PortableApps\\SublimeText2Portable\\sublime_text.exe\" \"%f:%l\"" $(cygpath -w $@)
