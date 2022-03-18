#!/bin/bash

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

BONOCOIND=${BONOCOIND:-$SRCDIR/bonocoind}
BONOCOINCLI=${BONOCOINCLI:-$SRCDIR/bonocoin-cli}
BONOCOINTX=${BONOCOINTX:-$SRCDIR/bonocoin-tx}
BONOCOINQT=${BONOCOINQT:-$SRCDIR/qt/bonocoin-qt}

[ ! -x $BONOCOIND ] && echo "$BONOCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
BNCVER=($($BONOCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for bitcoind if --version-string is not set,
# but has different outcomes for bitcoin-qt and bitcoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$BONOCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $BONOCOIND $BONOCOINCLI $BONOCOINTX $BONOCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${BNCVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${BNCVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m