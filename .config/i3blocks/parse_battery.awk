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

END {
    output = state " " percentage
    if(to_full != 0){
        output = output " | " to_full " to full"
    }

    print output
}
