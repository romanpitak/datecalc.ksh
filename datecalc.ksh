#!/usr/bin/ksh
############################################################
#
#               DATE CALCULATION
#
# This script performs date arithmetics
# eg.: add or subtract time from a date
#
# used in scripts to determine date and time some exact time ago
#
#      Author : Roman Pitak
#        date : 2011-04-04
#
# CHANGES : 
#
# 2011-11-25 : fixed the "-h", "-m" bug
#
# 2012-01-06 : fixed year change bug
#
#############################################################
#
# For more information on how to use it run : 
# datecalc --help
# datecalc --man
#
#############################################################


typeset -i10 currentYear currentMonth currentDay currentHour currentMinute currentSecond 
typeset -i10 number timeChangeIndex todayMaxDay
date '+%Y %m %d %H %M %S' | read currentYear currentMonth currentDay currentHour currentMinute currentSecond
set -A maxMonthLength 00 31 28 31 30 31 30 31 31 30 31 30 31
workMode='default'
typeset -i10 minDay=1
typeset -i10 minMonth=1
typeset -i10 maxMonth=12
typeset -i10 minYear=1860
typeset -i10 maxYear=3999
printString='+%Y-%m-%d %H:%M:%S'
timeChangeIndex=0

while (( $# ))
do
  case "${1}" in
  
    -D|--[Dd]ay)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge "${minDay}" && test "${2}" -le 31
      then
        currentDay="${2}"
        shift
      else
        echo 'ERROR : "-D" requires a valid parameter'
        return 1
      fi
      shift
      ;;      
  
    -h|--[Hh]our)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge 0 && test "${2}" -le 23
      then
        currentHour="${2}"
        shift
      else
        workMode='help'
      fi
      shift
      ;;

    -[Hh]elp|--[Hh]elp)
      workMode='help'
      shift
      ;;
      
    --isLeapYear)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge "${minYear}" && test "${2}" -le "${maxYear}"
      then
        currentYear="${2}"
        shift
      fi
      workMode='isLeapYear'
      shift
      ;;
      
    -l|--lastDay)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge "${minMonth}" && test "${2}" -le "${maxMonth}"
      then
        currentMonth="${2}"
        shift
      fi
      workMode='lastDayOfMonth'
      shift
      ;;
      
    -m|--[Mm]inute)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge 0 && test "${2}" -le 59
      then
        currentMinute="${2}"
        shift
      else
        echo 'ERROR : "-m" requires a valid parameter'
        return 1
      fi
      shift
      ;;
      
    -[Mm]an|--[Mm]an)
      workMode='print_manual'
      shift
      ;;

    -M|--[Mm]onth)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge "${minMonth}" && test "${2}" -le "${maxMonth}"
      then
        currentMonth="${2}"
        shift
      else
        echo 'ERROR : "-M" requires a valid parameter'
        return 1
      fi
      shift
      ;;
      
    -p)
      if test "$#" -gt 1
      then
        printString="${2}"
        shift
      else
        echo 'ERROR : "-p" requires a parameter'
        return 1
      fi
      shift
      ;;
      
    -s|--[Ss]econd)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge 0 && test "${2}" -le 59
      then
        currentSecond="${2}"
        shift
      else
        echo 'ERROR : "-s" requires a valid parameter'
        return 1
      fi
      shift
      ;;
      
  
    -Y|--[Yy]ear)
      if test "$#" -gt 1 && test "$( echo ${2} | sed -n -e 's/^\([0-9]*\)$/\1/p' )" != "" && test "${2}" -ge "${minYear}" && test "${2}" -le "${maxYear}"
      then
        currentYear="${2}"
        shift
      else
        echo 'ERROR : "-Y" requires a valid parameter'
        return 1
      fi
      shift
      ;;

    [+,-]*)
      plusMinus=$( echo "${1}" | sed -n -e 's/^\([+,-]\).*$/\1/p' )
      number=$( echo "${1}" | sed -n -e 's/^\([+,-][0-9]*\).*$/\1/p' )
      timeUnit=$( echo "${1}" | sed -n -e 's/^[+,-][0-9]*\(.*\)$/\1/p' )

      if test "${timeUnit}" = ''
      then
        shift
        timeUnit="${1}"
      fi
      
      case "${timeUnit}" in
        Y|[Yy]ear|[Yy]ears)      timeUnit='Y';;
        M|[Mm]onth|[Mm]onths)    timeUnit='M';;
        D|[Dd]ay|[Dd]ays)        timeUnit='D';;
        h|[Hh]our|[Hh]ours)      timeUnit='h';;
        m|[Mm]inute|[Mm]inutes)  timeUnit='m';;
        s|[Ss]econd|[Ss]econds)  timeUnit='s';;
        *)
          echo "ERROR - invalid time unit : \"${timeUnit}\""
          return 1
          ;;
      esac
      
      workMode='timeChange'
      timeChange[${timeChangeIndex}]="${number} ${timeUnit}"
      timeChangeIndex=$(( timeChangeIndex + 1 ))
      #echo "${plusMinus} ${number} ${timeUnit}"
      shift
      ;;
    
    *)
      echo "${1}"
      shift
      ;;
  esac
done


case "${workMode}" in
  'help')
    echo '
DATECALC ( calculate date from another time )

datecalc [OPTIONS]  : 

options :
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

examples :
datecalc -1d        : print yesterday`s date
datecalc -100 seconds -s "+%Y"
                    : what was the year 100 seconds ago?
datecalc -Y 1995 -M 08 -D 24 -h 0 -m 0 -s 0 +3M
                    : print the date 3 months after Win95 release

Implemented by Roman Pitak (roman@pitak.net)
Source available at https://github.com/romanpitak/datecalc.ksh
'
    return 0
    ;;
  
  'isLeapYear')
    isLeapYear='false'
    (( currentYear % 4 )) || isLeapYear='true'
    (( currentYear % 100 )) || isLeapYear='false'
    (( currentYear % 400 )) || isLeapYear='true'
    test "${isLeapYear}" = 'true' && return 0 || return 1
    ;;
   
  'lastDayOfMonth')
    if test "${currentMonth}" -eq 2
    then
      eval "${0}" --isLeapYear "\${currentYear}" && echo '29' || echo '28'
    else
      echo "${maxMonthLength[${currentMonth}]}"
    fi
    return 0
    ;;
    
  'print_manual')
    echo "SORRY manual not implemented yet"
    echo "try datecalc -help"
    return 1
    ;;
    
  'timeChange')
    i=0
    while test "${i}" -lt "${timeChangeIndex}"
    do
    
      echo "${timeChange[${i}]}" | read number timeUnit
      i=$(( i + 1 ))
      
      case "${timeUnit}" in
        Y)
          currentYear=$(( currentYear + number ))
          ;;
          
        M)
          if test "${number}" -lt 0
          then
            
            while test $(( currentMonth + number )) -lt "${minMonth}"
            do
              number=$(( currentMonth + number ))
              #echo "${0}" -Y "${currentYear}" -1Y -p '+%Y'
              currentYear=$( eval "${0}" -Y "\${currentYear}" -1Y -p '+%Y' )
              currentMonth="${maxMonth}"
            done
            
            currentMonth=$(( currentMonth + number ))
            
          else
            
            while test $(( currentMonth + number )) -gt "${maxMonth}"
            do
              number=$(( currentMonth + number - maxMonth -1 ))
              currentYear=$( eval "${0}" -Y "\${currentYear}" +1Y -p '+%Y' )
              currentMonth="${minMonth}"
            done
            
            currentMonth=$(( currentMonth + number ))
            
          fi          
          ;;
          
        D)
          if test "${number}" -lt 0
          then
          
            while test $(( currentDay + number )) -lt "${minDay}"
            do
              number=$(( currentDay + number ))
              echo $( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -1 Month -p \'+%Y %m\' ) | read currentYear currentMonth
              currentDay=$( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -l )
            done
            
            currentDay=$(( currentDay + number ))
              
          else
            
            while test $(( currentDay + number )) -gt $( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -l )
            do
              todayMaxDay=$( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -l )
              number=$(( currentDay + number - todayMaxDay - 1 ))
              echo $( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" +1 Month -p '+%Y %m' ) | read currentYear currentMonth
              currentDay="${minDay}"
            done
            
            currentDay=$(( currentDay + number ))
            
          fi
          ;;
          
        h)
          typeset -i10 daysChange=$(( number / 24 ))
          typeset -i10 hoursChange=$(( number % 24 ))

          currentHour=$(( currentHour + hoursChange ))
                      
          if test "${currentHour}" -lt 0
          then
            echo FFF
            daysChange=$(( daysChange - 1 ))
            currentHour=$(( currentHour + 24 ))
          elif test "${currentHour}" -ge 24
          then
            daysChange=$(( daysChange + 1 ))
            currentHour=$(( currentHour - 24 ))
          fi
          
          echo $( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -D "\${currentDay}" $( printf "%+d Days" "${daysChange}" ) -p \'+%Y %m %d\' ) | read currentYear currentMonth currentDay
          ;;
          
        m)
          typeset -i10 hoursChange=$(( number / 60 ))
          typeset -i10 minutesChange=$(( number % 60 ))
          
          currentMinute=$(( currentMinute + minutesChange ))
          if test "${currentMinute}" -lt 0
          then
            hoursChange=$(( hoursChange - 1 ))
            currentMinute=$(( currentMinute + 60 ))
          elif test "${currentMinute}" -ge 60
          then
            hoursChange=$(( hoursChange + 1 ))
            currentMinute=$(( currentMinute - 60 ))
          fi

          echo $( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -D "\${currentDay}" -h "\${currentHour}" $( printf "%+d Hours" "${hoursChange}" ) -p \'+%Y %m %d %H\' ) | read currentYear currentMonth currentDay currentHour
          ;;
          
        s)
          typeset -i10 minutesChange=$(( number / 60 ))
          typeset -i10 secondsChange=$(( number % 60 ))
          
          currentSecond=$(( currentSecond + secondsChange ))
          if test "${currentSecond}" -lt 0
          then
            minutesChange=$(( minutesChange - 1 ))
            currentSecond=$(( currentSecond + 60 ))
          elif test "${currentSecond}" -ge 60
          then
            minutesChange=$(( minutesChange + 1 ))
            currentSecond=$(( currentSecond - 60 ))
          fi
          
          echo $( eval "${0}" -Y "\${currentYear}" -M "\${currentMonth}" -D "\${currentDay}" -h "\${currentHour}" -m "\${currentMinute}" $( printf "%+d Minutes" "${minutesChange}" ) -p \'+%Y %m %d %H %M\' ) | read currentYear currentMonth currentDay currentHour currentMinute
          ;;
          
        *)
          echo 'ERROR - not implemented'
          ;;
          
      esac
      
    done
    ;;
  
esac

if test "${printString}" != ""
then
  
  echo "${printString}" | sed \
    -e 's/^+\(.*\)$/\1/' \
    -e $( printf "s/%%Y/%04d/g" "${currentYear}" ) \
    -e  $( printf "s/%%m/%02d/g" "${currentMonth}" ) \
    -e  $( printf "s/%%d/%02d/g" "${currentDay}" ) \
    -e  $( printf "s/%%H/%02d/g" "${currentHour}" ) \
    -e  $( printf "s/%%M/%02d/g" "${currentMinute}" ) \
    -e  $( printf "s/%%S/%02d/g" "${currentSecond}" )

fi

