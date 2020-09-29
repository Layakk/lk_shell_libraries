#!/bin/bash
########################
## lk_math.sh
##	Library module of bash functions that implement math utilities
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
##      program using ". lk_math.sh || exit 1". lk_math.sh can be in
##      the same directory of your program, in a directory accesible by your
##      environment PATH variable or you can also specify a full path for
##      lk_math.sh.
##
## COMMENTS:
##      (*) When a default value for a function parameter is defined, it is
##      assigned when the parameter is not passed or is "".
##
##      The following functions have been defined for use in your code:
##      get_random_uint
##              This function returns on the standard output 
##		a random uint number in a given range (default 0..100).
##		See parameter description below.
##      get_random_hex_digit
##		Returns (on the std output) a number of random 
##		hexadecimal digits. See parameter description below.
##	hex2dec
##		Returns on the standard output the hexadecimal to decimal
##		conversion of the passed valued. See parameter description
##		below.
########################
# FUNCTION SECTION
# ... get_random_uint ...
# ... $1 is the low limit (default value = 0)
# ... $2 is the upper limit (default value = 100)
# ... Returns result value on the standard output
# ...
function get_random_uint {
typeset -i _range
typeset -i _out
typeset -i _low
typeset -i _up

	if [[ ${#1} -eq 0 ]]
	then
		_low=0
	else
		_low=$1
	fi
	if [[ ${#2} -eq 0 ]]
	then
		_up=100
	else
		_up=$2
	fi
	
	_range=$_up-$_low
	[[ $_range -lt 0 ]] && return 1

	_out=`od -An -t u4 -N4 /dev/urandom`
	_out=$(( _out % _range + _low ))
	
	echo $_out
}

# ... get_random_hex_digit ...
# ... $1 is the number of digits (default = 1) 
# ... 
function get_random_hex_digits {
typeset -i _ndigits
typeset -i _nbytes
typeset -u _hex

	if [[ ${#1} -eq 0 ]]
	then
		_ndigits=1
	else
		_ndigits=$1
	fi
	_nbytes=$(( 1 + _ndigits / 2 ))
	
	_hex=`od -An -t x1 -N$_nbytes /dev/urandom`
	_hex=${_hex// /}
	echo ${_hex:0:$_ndigits}
}

# ... hex2dec ...
# ... $1 must be an hexadecimal number of any length supported by bc
# ... writes the equivalent decimal number on standard output
function hex2dec {
	echo "ibase=16; $1" | bc
}
