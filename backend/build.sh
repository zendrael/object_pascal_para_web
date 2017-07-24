#!/bin/bash

# Compilando o sistema

fpc sistema.lpr -O3 -Ooregvar -Xg -Xs -XX \
-Fulib -Fumodel -Fuview -Fucontroller

case "$1" in
	'clean')
		echo "Limpando arquivos..."
		find ./ -name \*.a | xargs rm
		find ./ -name \*.o | xargs rm
		find ./ -name \*.ppu | xargs rm
		find ./ -name \*.or | xargs rm
		find ./ -name \*.compiled | xargs rm
		find ./ -name \*.tmp | xargs rm
	;;
#	'win')
#		echo "Building for Win..."
#		fpc ...
#	;;
#	'linux')
#		echo "Building for Linux..."
#		fpc ...
#	;;
	*)
		echo "Também pode usar como: $0 {clean|win|linux}"
esac