#!/bin/bash
########################
## lk_net.sh
##	Library module of bash functions that implement network utilities
##
## Copyright (C) 2014 LAYAKK - www.layakk.com
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
## USAGE:
##      To use the functions defined in this code, source this file in your
##      program using ". lk_net.sh || exit 1". lk_net.sh can be in
##      the same directory of your program, in a directory accesible by your
##      environment PATH variable or you can also specify a full path for
##      lk_net.sh.
##	This library depends on lk_math.sh, so you have to install it as well.
##
##      The following functions have been defined for use in your code:
##	is_mac_address
##		This function verifies whether parameter 1 is a MAC addr.
##		It returns 0 on positive match and 1 otherwise.
##	generate_rand_mac
##		generates a totally random "FULL" (6 bytes) or "HALF" 
##		(3 bytes) unicast MAC address (see below for argument specs).
########################
. lk_math.sh || return 1

# FUNCTION SECTION
# ... is_mac_address ...
# ... $1 is the string containing a mac address (mandatory)
# ... Returns result value (0 = is mac)
# ...
function is_mac_address {
	typeset -l _mac
	_mac=${1:-"NULL"}
	if echo $_mac | grep -E "^([0-9a-f]{2}:){5}([0-9a-f]){2}$" 1>/dev/null 2>&1
	then
		return 0
	else
		return 1
	fi
}

#... generate_rand_mac
#... $1 must be "FULL" (or ommitted) or "HALF"
#... return the generated unicast MAC on the command line
function generate_rand_mac {
typeset _i _nbytes
typeset -i _byte_index
typeset -u _mac_digits

        _mode=${1:-"FULL"}
        if [[ $1 == "FULL" ]]
        then
                _nbytes=6
        else
                _nbytes=3
        fi

        _mac=""
        _byte_index=0

        while (( _byte_index < _nbytes ))
        do
                if (( _byte_index > 0 ))
                then
                        _mac=$_mac":"`get_random_hex_digits 2`
                else
			_is_even=0
			while ! (( $_is_even ))
			do
				_mac_digits=`get_random_hex_digits 2`
				if (( `hex2dec "$_mac_digits"`%2==0 ))
				then
					_is_even=1
				fi
			done
                        _mac=$_mac_digits
                fi
                _byte_index=_byte_index+1
        done

        echo $_mac
}
