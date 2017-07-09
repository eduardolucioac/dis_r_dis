#!/bin/bash

# > -----------------------------------------
# Run that script with bash even if the user use sh/dash or any sh like 
# interpreter. This way it correctly works with either: 
# "sh ./my_script.bash" or "bash ./my_script.bash" or "./my_script.bash"

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

# < -----------------------------------------

# NOTE: Evita problemas com caminhos relativos! By Questor
SCRIPTDIR_V="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $SCRIPTDIR_V/ez_i.bash

# > --------------------------------------------------------------------------
# INÍCIO!
# --------------------------------------

read -d '' TITLE_F <<"EOF"
Dis_R_Dis - Display Resolution Discovery
EOF

read -d '' VERSION_F <<"EOF"
0.1.0.0
EOF

# NOTE: Para versionamento usar "MAJOR.MINOR.REVISION.BUILDNUMBER"! By Questor
# http://programmers.stackexchange.com/questions/24987/what-exactly-is-the-build-number-in-major-minor-buildnumber-revision

read -d '' ABOUT_F <<"EOF"
This script will try to DISCOVER THE MAXIMUM POSSIBLE RESOLUTIONS (*) for 
an EXTERNAL display connected on NOTEBOOKS with a NVIDIA GPU (OPTIMUS 
TECHNOLOGY) and the HDMI port WIRED to the GPU!

(*) Resolutions that do not "crash" the display and keep its proportions!

Have fun! =D
EOF

read -d '' WARNINGS_F <<"EOF"
THIS SCRIPT COMES WITH ABSOLUTELY NO WARRANTY! USE AT YOUR OWN RISK! 
WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOURSELF, HARDWARE OR CO-WORKERS.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!! YOUR DISPLAY MAY CRASH !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

READ THE INSTRUCTIONS ON THE SCREEN! =D
EOF

read -d '' COMPANY_F <<"EOF"
Copyright (c) 2017, Eduardo Lúcio Amorim Costa
EOF

f_begin "$TITLE_F" "$VERSION_F" "$ABOUT_F" "$WARNINGS_F" "$COMPANY_F"
ABOUT_F=""
WARNINGS_F=""

# < --------------------------------------------------------------------------

# > --------------------------------------------------------------------------
# TERMOS E LICENÇA!
# --------------------------------------

read -d '' TERMS_LICEN_F <<"EOF"
Copyright (c) 2017, Eduardo Lúcio Amorim Costa
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of its contributors may 
      be used to endorse or promote products derived from this software 
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL EDUARDO LÚCIO AMORIM COSTA BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
EOF

f_terms_licen "$TERMS_LICEN_F"
TERMS_LICEN_F=""

# < --------------------------------------------------------------------------

# > --------------------------------------------------------------------------
# INTRUÇÕES!
# --------------------------------------

read -d '' INSTRUCT_F <<"EOF"
Dis_R_Dis will try a SERIES OF RESOLUTIONS FROM THE MAXIMUM RESOLUTION 
SUPPORTED BY EXTERNAL DISPLAY.

The external display NEEDS TO BE CONNECTED TO THE NOTEBOOK.

WHEN THE FIRST FUNCTIONAL RESOLUTION IS REACHED ANSWER YES WHEN YOU ARE ASKED 
ABOUT THIS.

TO STOP THE PROCESS ANSWER YES WHEN YOU ARE ASKED ABOUT THIS!

THE FUNCTIONAL RESOLUTION IS REACHED WHEN YOUR PRIMARY AND SECONDARY (EXTERNAL) 
DISPLAY WORKS! SIMPLE!

DO NOT USE CTRL+C!

DO NOT USE ROOT USER!

PLACE THIS WINDOW ON YOUR PRIMARY DISPLAY!

These settings WILL NOT BE PERMANENT in case of "breakdown" restart your 
computer!

THIS SCRIPT WILL GUIDE YOU THROUGH THE PROCESS!
EOF

f_instruct "$INSTRUCT_F"
INSTRUCT_F=""

# < --------------------------------------------------------------------------

f_div_section
f_yes_no "The external display is working? Can you see your desktop or something like this?"
if [ ${YES_NO_R} -eq 0 ] ; then
    f_div_section
    f_yes_no "Is the external display connected to the HDMI port and switched on?"
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_div_section
        f_yes_no "Try activating external HDMI display?"
        if [ ${YES_NO_R} -eq 1 ] ; then
            intel-virtual-output && xrandr -q &>/dev/null
            sleep 7
            f_div_section
            f_yes_no "The external HDMI display is working now?
* Will not work if it is disabled in the display/monitor settings;
* You can make some adjustments in the display/monitor settings."
            if [ ${YES_NO_R} -eq 0 ] ; then
                f_okay_exit "The external HDMI display NEEDS TO BE WORKING!"
            fi
        else
            f_okay_exit "The external HDMI display NEEDS TO BE ACTIVATED!"
        fi
    else
        f_okay_exit "The external display NEEDS TO BE CONNECTED TO THE HDMI PORT AND SWITCHED ON!"
    fi
fi

clear
f_get_stderr_stdout "xrandr -q"
f_div_section
f_get_usr_input "Enter the external display name!
* Check BELOW. It's connected.
 > --------------
$F_GET_STDOUT_R
 < --------------
"
DISP_NAME=$GET_USR_INPUT_R

OKAY_XY_RES=""
f_split "$F_GET_STDOUT_R" "$DISP_NAME "
f_split "${F_SPLIT_R[1]}" "\n"
SPLIT_LEN=${#F_SPLIT_R[*]}
for (( i=0; i<=$(( $SPLIT_LEN -1 )); i++ )) ; do
    if [[ "${F_SPLIT_R[$i]}" == *"*"* ]] ; then
        f_split "${F_SPLIT_R[$i]}" "x"
        OKAY_X_RES=${F_SPLIT_R[0]}
        OKAY_Y_RES=${F_SPLIT_R[1]}
        f_split "$OKAY_X_RES"
        OKAY_X_RES=${F_SPLIT_R[@]}
        f_split "$OKAY_Y_RES"
        OKAY_Y_RES=${F_SPLIT_R[0]}
        OKAY_XY_RES=$OKAY_X_RES"x"$OKAY_Y_RES
        if [ -z "$OKAY_XY_RES" ] ; then
            f_error_exit "Could not set a \"safe\" resolution for the \"$DISP_NAME\" external display!"
        fi
        f_div_section
        f_yes_no "The \"secure\" resolution for the \"$DISP_NAME\" display appears to be \"$OKAY_XY_RES\". IS THIS OKAY?
* Check ABOVE. It's marked with a \"*\"."
        if [ ${YES_NO_R} -eq 0 ] ; then
            f_error_exit
        fi
        break
    fi
done

if [ -z "$OKAY_XY_RES" ] ; then
    f_error_exit "Could not set a \"safe\" resolution for the \"$DISP_NAME\" external display!"
fi

clear
f_div_section
f_get_usr_input "Enter the máximum X value suported by your external display resolution (in 1400x900 will be 1400)!
* If necessary consult the manufacturer!"
MAX_X_RES=$GET_USR_INPUT_R

f_div_section
f_get_usr_input "Enter the máximum Y value suported by your external display resolution (in 1400x900 will be 900)!
* If necessary consult the manufacturer!"
MAX_Y_RES=$GET_USR_INPUT_R

f_div_section
f_get_usr_input "Enter the máximum REFRESH RATE suported by your external display!
* If necessary consult the manufacturer;
* \"60\" may be a good value."
MAX_REF_RATE=$GET_USR_INPUT_R

MAX_RES_FACTOR=$(awk '{printf("%.16f\n",($1/$2))}' <<<" $MAX_X_RES $MAX_Y_RES ")

ATTEMPTS=100
LAST_MODELINE=""
for (( i=0; i<$(( $ATTEMPTS )); i++ )) ; do
    NEW_MAX_X_RES=$(( $MAX_X_RES - $i ))
    if [ ${i} -gt 0 ] ; then
        NEW_MAX_Y_RES=$(awk '{printf("%.5f\n",($1/$2))}' <<<" $NEW_MAX_X_RES $MAX_RES_FACTOR ")
        NEW_MAX_Y_RES=$(awk '{printf("%.0f\n", $1);}' <<<" $NEW_MAX_Y_RES ")
    else
        NEW_MAX_Y_RES=$MAX_Y_RES
    fi
    f_get_stderr_stdout "cvt $NEW_MAX_X_RES $NEW_MAX_Y_RES $MAX_REF_RATE"
    if [ "$F_GET_STDOUT_R" == "$LAST_MODELINE" ] ; then
        LAST_MODELINE="$F_GET_STDOUT_R"
        continue
    fi
    LAST_MODELINE="$F_GET_STDOUT_R"
    f_split "$F_GET_STDOUT_R" "\n"
    f_split "${F_SPLIT_R[1]}" "Modeline "
    XRANDR_NEWMODE=${F_SPLIT_R[1]}
    eval "xrandr --newmode $XRANDR_NEWMODE"
    f_split "${F_SPLIT_R[1]}" "\"  "
    f_split "${F_SPLIT_R[0]}" "\""
    XRANDR_ADD_OUT=${F_SPLIT_R[1]}
    f_get_stderr_stdout "xrandr -q | egrep -i ${F_SPLIT_R[1]}"
    f_split "$F_GET_STDOUT_R" "("
    f_split "${F_SPLIT_R[1]}" ")"
    XRANDR_NEWMODE_REM=${F_SPLIT_R[0]}
    eval "xrandr --addmode $DISP_NAME $XRANDR_ADD_OUT"
    eval "xrandr --output $DISP_NAME --mode $XRANDR_ADD_OUT"
    f_div_section
    f_yes_no "IS THIS CONFIGURATION OKAY? 
[CURRENT VALUE: $XRANDR_ADD_OUT]" 7 0
    if [ ${YES_NO_R} -eq 0 ] ; then
        eval "xrandr --delmode $DISP_NAME $XRANDR_ADD_OUT &>/dev/null"
        eval "xrandr --rmmode $XRANDR_NEWMODE_REM"
        eval "xrandr --output $DISP_NAME --mode $OKAY_XY_RES"
        f_div_section
        echo "Returning the display \"$DISP_NAME\" to the valid configuration \"$OKAY_XY_RES\"!"
        f_div_section
        f_yes_no "DO YOU WANT TO CONTINUE TESTING?" 5 1
        if [ ${YES_NO_R} -eq 0 ] ; then
            f_okay_exit
        fi
    else
        INSTRUCTIONS_OP="
 -> YOUR VALID DISPLAY CONFIGURATION IS: 

    $XRANDR_NEWMODE

 -> TO APPLY THESE SETTINGS AGAIN USE THE FOLLOWING COMMANDS:

    xrandr --newmode $XRANDR_NEWMODE
    xrandr --addmode $DISP_NAME $XRANDR_ADD_OUT
    xrandr --output $DISP_NAME --mode $XRANDR_ADD_OUT

 -> TIPS:

    1 - To make the settings above persistent you can use one of these 
suggestions:
        . Use (cretate) the \"$HOME/.xprofile\" file, put the commands above 
    inside and it will run at startup.
        . Create some shell/bash script file, put the commands above inside and 
    run when you need it;

    2 - You can make some adjustments in the display/monitor settings.

    THANKS! =D
"
        echo "$INSTRUCTIONS_OP"
        break
    fi
done

exit 0
