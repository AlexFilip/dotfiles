
BEGIN {
    after_level = ""
    printed_on_history = 0

    battery_info_file = ENVIRON["HOME"] "/.local/last_battery_percentage"
    getline last_percentage < battery_info_file

    # (+0) casts to int (no need to remove '%')
    last_percentage = last_percentage+0
    warn_on_percentage = 10
}

function print_all_details(print_exit_message) {
    output = state " " current_percentage
    if(state != "fully-charged" ) {
        if(after_level == "to_full"){
            output = output " (" to_full ")"
        } else if(after_level == "to_empty") {
            output = output " (" to_empty " left)"
        }
    }

    if(print_exit_message && printed_on_history) {
        output = output " (Monitor exited)"
    }

    if(last_percentage >= warn_on_percentage && current_percentage < warn_on_percentage) {
        system("notify-send --urgency=critical 'LOW BATTERY (" current_percentage ")' 'Battery level is low, please plug your laptop in'")
    }

    last_percentage = current_percentage

    print current_percentage > battery_info_file
    close(battery_info_file)

    if(output != old_output) {
        print output
        fflush() # Needed for persist mode in i3blocks
    }

    old_output = output
    output = ""

}

/state/ {
    # charging, discharging, full, etc.
    state = $2
}

/to full/ {
    # NF - 1 = number, NF = units (minutes, hours, etc.)
    to_full = $(NF - 1) " " $NF
    after_level = "to_full"
}

/to empty/ {
    to_empty = $(NF - 1) " " $NF
    after_level = "to_empty"
}

/percentage/ {
    # Ends with %, so you have to cast to int with +0
    current_percentage = ($2)+0
}

# NOTE: History is the last section in the entire block that is written. It's a good marker for when we are at the end of the output
# Also, there are multiple blocks output, so internally, you get multiple lines for each change. This might not be a big problem, but worth keeping in mind.

/^$/ {
    printed_on_history = 1 # In case this is run once, while waiting for the monitor to start we should display something
    print_all_details(0)
}

END {
    print_all_details(1)
}

