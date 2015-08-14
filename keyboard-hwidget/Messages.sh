#! /usr/bin/env bash

$XGETTEXT *.cpp -o $podir/plasma_applet_keyboardclient.pot
rm -f rc.cpp
