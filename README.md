# DATECALC 

Calculate date from another time.

(c) 2011-2015 [Roman Piták](http://pitak.net) roman@pitak.net

## SYNOPSIS

    datecalc [OPTIONS] 

## OPTIONS

    -p +STRING          : set print string
                        : default : +%Y-%m-%d %H:%M:%S
    -Y year             : set  Year    to be used as reference
    -M month            : set  Month   to be used as reference
    -D day              : set  Day     to be used as reference
    -h hour             : set  Hour    to be used as reference
    -s second           : set  Second  to be used as reference
    -m minute           : set  Minute  to be used as reference
    -h                  : print this help message
    --isLeapYear [year] : true if year is a leap year
    -l [month]          : print number of days in a month
    --man               : print full manual
    -number time_unit   : set negative time offset
    +number time_unit   : set positive time offset

## EXAMPLES

    datecalc -1d        : print yesterday`s date
    datecalc -100 seconds -s "+%Y"
                        : what was the year 100 seconds ago?
    datecalc -Y 1995 -M 08 -D 24 -h 0 -m 0 -s 0 +3M
                        : print the date 3 months after Win95 release
