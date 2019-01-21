#!/bin/sh


# If ACPI was not installed, this probably is a battery-less computer.
ACPI_RES=$(acpi)
if [ $? -eq 0 ]
then
    # Get essential information.
    BAT_LEVEL=$(echo $ACPI_RES | egrep -o "[0-9][0-9]?[0-9]?%")
    TIME_LEFT=$(echo $ACPI_RES | egrep -o "[0-9]{2}:[0-9]{2}:[0-9]{2}")
    IS_CHARGING=$(echo $ACPI_RES | awk '{ printf("%s", substr($3, 0, length($3)-1) ) }')

    # If there is no 'time left' information (when almost fully charged) we 
    # provide information ourselvs.
    if [ -z "$TIME_LEFT" ]
    then
        TIME_LEFT="00:00:00"
    fi

    # Print full text. The charging data.
    BATTERY_EMOJI=$(echo -e "\U0001F50B")
    HOUR_GLASS_EMOJI=$(echo -e "\u23F3")
    TIME_LEFT=$(echo $TIME_LEFT | awk '{ printf("%s", substr($1, 0, 5)) }')
    echo "$BATTERY_EMOJI"$BAT_LEVEL: "$HOUR_GLASS_EMOJI"$TIME_LEFT ""

    # Print the short text.
    echo -e "BAT: $BAT_LEVEL"
    
    # Change the font color, depending on the situation.
    if [ $IS_CHARGING = "Charging" ]
    then
        # Charging yellow color.
        echo "#D0D000"
    else
        if [ ${BAT_LEVEL%?} -le 15 ]
        then
            # Battery very low. Red color.
            echo "#FA1E44"
        else
            # Battery not charging but at decent level. Green color.
            echo "#007872"
        fi
    fi
fi
