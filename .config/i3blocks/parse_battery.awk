
/state/ {
    # charging, discharching, full, etc.
    state = $2
}

/percentage/ {
    # Ends with %
    percentage = $2
}

/to full/ {
    # NF - 1 = number, NF = units (minutes, hours, etc.)
    to_full = $(NF - 1) " " $NF
}

/to empty/ {
    to_empty = $(NF - 1) " " $NF
}

END {
    output = state " " percentage
    if(to_full != 0){
        output = output " (" to_full ")"
    } else if(to_empty != 0) {
        output = output " (" to_empty " left)"
    }

    warn_on_percentage = 10
    battery_info_file = ENVIRON["HOME"] "/.local/last_battery_percentage"

    # + 0 casts to int (no need to remove '%'
    getline last_percentage < battery_info_file
    if((last_percentage+0) >= warn_on_percentage && (percentage+0) < warn_on_percentage) {
        system("notify-send --urgency=critical 'LOW BATTERY' 'Battery level is low, please plug your laptop in'")
    }

    print percentage > battery_info_file

    print output
}
