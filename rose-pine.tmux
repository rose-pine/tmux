#!/usr/bin/env bash
#
# Rosé Pine - tmux theme
#
# Almost done, any bug found file a PR to rose-pine/tmux
#
# Inspired by dracula/tmux, catppucin/tmux & challenger-deep-theme/tmux
#
#
export TMUX_ROSEPINE_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"

get_tmux_option() {
    local option value default
    option="$1"
    default="$2"
    value="$(tmux show-option -gqv "$option")"

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

set() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
    local option=$1
    local value=$2
    tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

unset_option() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gu "$option" ";")
}


main() {
    local theme
    theme="$(get_tmux_option "@rose_pine_variant" "")"

    # INFO: Not removing the thm_hl_low and thm_hl_med colors for posible features
    # INFO: If some variables appear unused, they are being used either externally
    # or in the plugin's features
    if [[ $theme == main ]]; then

        thm_base="#191724";
        thm_surface="#1f1d2e";
        thm_overlay="#26233a";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ebbcba";
        thm_pine="#31748f";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#21202e";
        thm_hl_med="#403d52";
        thm_hl_high="#524f67";

    elif [[ $theme == dawn ]]; then

        thm_base="#faf4ed";
        thm_surface="#fffaf3";
        thm_overlay="#f2e9e1";
        thm_muted="#9893a5";
        thm_subtle="#797593";
        thm_text="#575279";
        thm_love="#b4367a";
        thm_gold="#ea9d34";
        thm_rose="#d7827e";
        thm_pine="#286983";
        thm_foam="#56949f";
        thm_iris="#907aa9";
        thm_hl_low="#f4ede8";
        thm_hl_med="#dfdad9";
        thm_hl_high="#cecacd";

    elif [[ $theme == moon ]]; then

        thm_base="#232136";
        thm_surface="#2a273f";
        thm_overlay="#393552";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ea9a97";
        thm_pine="#3e8fb0";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#2a283e";
        thm_hl_med="#44415a";
        thm_hl_high="#56526e";

    fi

    # Aggregating all commands into a single array
    local tmux_commands=()

    # Status bar
    set "status" "on"
    set status-style "fg=$thm_pine,bg=$thm_base"
    # set monitor-activity "on"
    # Leave justify option to user
    # set status-justify "left"
    set status-left-length "200"
    set status-right-length "200"


    # Theoretically messages (need to figure out color placement)
    set message-style "fg=$thm_muted,bg=$thm_base"
    set message-command-style "fg=$thm_base,bg=$thm_gold"

    # Pane styling
    set pane-border-style "fg=$thm_hl_high"
    set pane-active-border-style "fg=$thm_gold"
    set display-panes-active-colour "${thm_text}"
    set display-panes-colour "${thm_gold}"

    # Windows
    setw window-status-style "fg=${thm_iris},bg=${thm_base}"
    setw window-status-activity-style "fg=${thm_base},bg=${thm_rose}"
    setw window-status-current-style "fg=${thm_gold},bg=${thm_base}"

    # Statusline base command configuration: No need to touch anything here
    # Placement is handled below

    # Shows username of the user the tmux session is run by
    local user
    user="$(get_tmux_option "@rose_pine_user" "")"
    readonly user

    # Shows hostname of the computer the tmux session is run on
    local host
    host="$(get_tmux_option "@rose_pine_host" "")"
    readonly host

    # Date and time command: follows the date UNIX command structure
    local date_time
    date_time="$(get_tmux_option "@rose_pine_date_time" "")"
    readonly date_time

    # Shows truncated current working directory
    local directory
    directory="$(get_tmux_option "@rose_pine_directory" "")"

    local disable_active_window_menu
    disable_active_window_menu="$(get_tmux_option "@rose_pine_disable_active_window_menu" "")"

    local show_current_program
    show_current_program="$(get_tmux_option "@rose_pine_show_current_program" "")"
    readonly show_current_program

    local window_directory
    window_directory="$(get_tmux_option "@rose_pine_show_pane_directory" "")"
    readonly window_directory

    local window_separator 
    window_separator="$(get_tmux_option "@rose_pine_window_separator" "")"
    readonly window_separator 

    local default_window_behavior
    default_window_behavior="$(get_tmux_option "@rose_pine_default_window_behavior" "")"
    readonly default_window_behavior

    # Changes the background color for the current active window
    # TODO: Together with line 251-269, end development for this feature
    # local active_window_color
    # active_window_color="$(get_tmux_option "@rose_pine_active_window_color" "")"
    # readonly active_window_color

    # Transparency enabling for status bar
    local bar_bg_disable
    bar_bg_disable="$(get_tmux_option "@rose_pine_bar_bg_disable" "")"
    readonly bar_bg_disable

    # Transparent option for status bar
    local bar_bg_disabled_color_option
    bar_bg_disabled_color_option="$(get_tmux_option "@rose_pine_bar_bg_disabled_color_option" "0")"
    readonly bar_bg_disabled_color_option

    # Shows hostname of the computer the tmux session is run on
    local only_windows
    only_windows="$(get_tmux_option "@rose_pine_only_windows" "")"
    readonly only_windows

    # Allows user to set a few custom sections (for integration with other plugins)
    # Before the plugin's left section
    local status_left_prepend_section
    status_left_prepend_section="$(get_tmux_option "@rose_pine_status_left_prepend_section" "")"
    readonly status_left_prepend_section
    #
    # after the plugin's left section
    local status_left_append_section
    status_left_append_section="$(get_tmux_option "@rose_pine_status_left_append_section" "")"
    readonly status_left_append_section
    # Before the plugin's right section
    local status_right_prepend_section
    status_right_prepend_section="$(get_tmux_option "@rose_pine_status_right_prepend_section" "")"
    readonly status_right_prepend_section
    #
    # after the plugin's right section
    local status_right_append_section
    status_right_append_section="$(get_tmux_option "@rose_pine_status_right_append_section" "")"
    readonly status_right_append_section

    # Settings that allow user to choose their own icons and status bar behaviour
    # START
    local current_window_icon
    current_window_icon="$(get_tmux_option "@rose_pine_current_window_icon" "")"
    readonly current_window_icon

    local current_session_icon
    current_session_icon="$(get_tmux_option "@rose_pine_session_icon" "")"
    readonly current_session_icon

    local username_icon
    username_icon="$(get_tmux_option "@rose_pine_username_icon" "")"
    readonly username_icon

    local hostname_icon
    hostname_icon="$(get_tmux_option "@rose_pine_hostname_icon" "󰒋")"
    readonly hostname_icon

    local hostname_short
    hostname_short="$(get_tmux_option "@rose_pine_hostname_short" "")"
    readonly hostname_short

    local date_time_icon
    date_time_icon="$(get_tmux_option "@rose_pine_date_time_icon" "󰃰")"
    readonly date_time_icon

    local current_folder_icon
    current_folder_icon="$(get_tmux_option "@rose_pine_folder_icon" "")"
    readonly current_folder_icon

    # Changes the icon / character that goes between each window's name in the bar
    local window_status_separator
    window_status_separator="$(get_tmux_option "@rose_pine_window_status_separator" "  ")"

    # This setting does nothing by itself, it enables the 2 below it to toggle the simplified bar
    local prioritize_windows
    prioritize_windows="$(get_tmux_option "@rose_pine_prioritize_windows" "")"

    # Allows the user to set a min width at which most of the bar elements hide, or
    local user_window_width
    user_window_width="$(get_tmux_option "@rose_pine_width_to_hide" "")"

    # A number of windows, when over it, the bar gets simplified
    local user_window_count
    user_window_count="$(get_tmux_option "@rose_pine_window_count" "")"

    # Custom window status that goes between the number and the window name
    local custom_window_sep="#[fg=$thm_iris]#I#[fg=$thm_iris,]$window_separator#[fg=$thm_iris]#W"
    local custom_window_sep_current="#I#[fg=$thm_gold,bg=""]$window_separator#[fg=$thm_gold,bg=""]#W"

    local right_separator
    right_separator="$(get_tmux_option "@rose_pine_right_separator" "  ")"

    local left_separator
    left_separator="$(get_tmux_option "@rose_pine_left_separator" "  ")"

    local field_separator
    # NOTE: Don't remove
    field_separator="$(get_tmux_option "@rose_pine_field_separator" " | " )"

    # END

    local spacer
    spacer=" "
    # I know, stupid, right? For some reason, spaces aren't consistent

    # These variables are the defaults so that the setw and set calls are easier to parse

    local show_window
    readonly show_window=" #[fg=$thm_subtle]$current_window_icon #[fg=$thm_rose]#W$spacer"

    local show_window_in_window_status
    show_window_in_window_status="#[fg=$thm_iris]#I#[fg=$thm_iris,]$left_separator#[fg=$thm_iris]#W"

    local show_window_in_window_status_current
    show_window_in_window_status_current="#I#[fg=$thm_gold,bg=""]$left_separator#[fg=$thm_gold,bg=""]#W"

    local show_session
    readonly show_session=" #[fg=#{?client_prefix,$thm_love,$thm_text}]$current_session_icon #[fg=$thm_text]#S "

    local show_user
    readonly show_user="#[fg=$thm_iris]#(whoami)#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$username_icon "

    local show_host
    local hostname
    if [[ "$hostname_short" == "on" ]]; then
        hostname="#h"
    else
        hostname="#H"
    fi
    readonly hostname
    readonly show_host="$spacer#[fg=$thm_text]$hostname#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$hostname_icon "

    local show_date_time
    readonly show_date_time=" #[fg=$thm_foam]$date_time#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$date_time_icon "

    local show_directory
    readonly show_directory="$spacer#[fg=$thm_subtle]$current_folder_icon #[fg=$thm_rose]#{b:pane_current_path} "

    local show_directory_in_window_status
    # BUG: It doesn't let the user pass through a custom window name
    show_directory_in_window_status="#I$left_separator#[fg=$thm_gold,bg=""]#{b:pane_current_path}"

    local show_directory_in_window_status_current
    show_directory_in_window_status_current="#I$left_separator#[fg=$thm_gold,bg=""]#{b:pane_current_path}"

    # TODO: This needs some work and testing, rn I can't figure it out
    # if [[ "$active_window_color" == "love" ]]; then
    #     show_window_in_window_status_current="#[bg=$thm_love,bg=$thm_base]#I$left_separator#W"
    # fi
    # if [[ "$active_window_color" == "gold" ]]; then
    #     show_window_in_window_status_current="#[bg=$thm_gold,bg=$thm_base]#I$left_separator#W"
    # fi
    # if [[ "$active_window_color" == "rose" ]]; then
    #     show_window_in_window_status_current="#bg=$thm_rose,bg=$thm_base#I$left_separator#W"
    # fi
    # if [[ "$active_window_color" == "pine" ]]; then
    #     show_window_in_window_status_current="#[bg=$thm_pine,bg=$thm_base]#I$left_separator#W"
    # fi
    # if [[ "$active_window_color" == "foam" ]]; then
    #     show_window_in_window_status_current="#[bg=$thm_foam,bg=$thm_base]#I$left_separator#W"
    # fi
    # if [[ "$active_window_color" == "iris" ]]; then
    #     show_window_in_window_status_current="#[bg=$thm_iris,bg=$thm_base]#I$left_separator#W"
    # fi

    # Left status: Now moved to a variable called left_column
    # (we can append / prepend things to it)
    local left_column

    # Right status and organization:
    # Right status shows nothing by default
    local right_column

    # This if statement allows the bg colors to be null if the user decides so
    # It sets the base colors for active / inactive, no matter the window appearence switcher choice
    # TEST: This needs to be tested further
    if [[ "$bar_bg_disable" == "on" ]]; then
        set status-style "fg=$thm_pine,bg=$bar_bg_disabled_color_option"
        show_window_in_window_status="#[fg=$thm_iris,bg=$bar_bg_disabled_color_option]#I#[fg=$thm_iris,bg=$bar_bg_disabled_color_option]$left_separator#[fg=$thm_iris,bg=$bar_bg_disabled_color_option]#W"
        show_window_in_window_status_current="#[fg=$thm_gold,bg=$bar_bg_disabled_color_option]#I#[fg=$thm_gold,bg=$bar_bg_disabled_color_option]$left_separator#[fg=$thm_gold,bg=$bar_bg_disabled_color_option]#W"
        show_directory_in_window_status="#[fg=$thm_iris,bg=$bar_bg_disabled_color_option]#I#[fg=$thm_iris,bg=$bar_bg_disabled_color_option]$left_separator#[fg=$thm_iris,bg=$bar_bg_disabled_color_option]#{b:pane_current_path}"
        show_directory_in_window_status_current="#[fg=$thm_gold,bg=$bar_bg_disabled_color_option]#I#[fg=$thm_gold,bg=$bar_bg_disabled_color_option]$left_separator#[fg=$thm_gold,bg=$bar_bg_disabled_color_option]#{b:pane_current_path}"
        set window-status-style "fg=$thm_iris,bg=$bar_bg_disabled_color_option"
        set window-status-current-style "fg=$thm_gold,bg=$bar_bg_disabled_color_option"
        set window-status-activity-style "fg=$thm_rose,bg=$bar_bg_disabled_color_option"
        set message-style "fg=$thm_muted,bg=$bar_bg_disabled_color_option"
    fi

    # Window appearence switcher: 3 options for the user
    if [[ "$window_separator" != "" ]] ; then
        window_status_format=$custom_window_sep
        window_status_current_format=$custom_window_sep_current
        setw window-status-format "$window_status_format"
        setw window-status-current-format "$window_status_current_format"

    elif [[ "$show_current_program" == "on" ]]; then
        window_status_format=$show_window_in_window_status
        window_status_current_format=$show_window_in_window_status_current
        setw window-status-format "$window_status_format"
        setw window-status-current-format "$window_status_current_format"
    # See line 268
    elif [[ "$window_directory" ]]; then
        local window_status_format=$show_directory_in_window_status
        local window_status_current_format=$show_directory_in_window_status_current
        setw window-status-format "$window_status_format"
        setw window-status-current-format "$window_status_current_format"
        #
    # Base behaviour, but whit cool colors
    elif [[ "$default_window_behavior" == "on" || "$default_window_behavior" == "" ]]; then
        unset_option window-status-format
        unset_option window-status-current-format
    fi

    if [[ "$user" == "on" ]]; then
        right_column=$right_column$show_user
    fi

    if [[ "$host" == "on" ]]; then
        right_column=$right_column$show_host
    fi

    if [[ "$date_time" != "" ]]; then
        right_column=$right_column$show_date_time
    fi

    if [[ "$directory" == "on" ]]; then
        right_column=$right_column$show_directory
    fi

    # The append and prepend sections are for inter-plugin compatibility
    # and extension
    if [[ "$disable_active_window_menu" == "on" ]]; then
        left_column=$show_session
    else
        left_column=$show_session$show_window
    fi
    #
    # Appending / Prepending custom user sections to
    if [[ "$status_left_prepend_section" != "" ]]; then
        left_column=$status_left_prepend_section$left_column
    fi
    if [[ "$status_left_append_section" != "" ]]; then
        left_column=$left_column$status_left_append_section$spacer
    fi
    if [[ "$status_right_prepend_section" != "" ]]; then
        right_column=$status_right_prepend_section$right_column
    fi
    if [[ "$status_right_append_section" != "" ]]; then
        right_column=$right_column$status_right_append_section
    fi

    # We set the sections
    set status-left "$left_column"
    set status-right "$right_column"

    # Variable logic for the window prioritization
    local current_window_count
    local current_window_width

    current_window_count=$(tmux list-windows | wc -l)
    current_window_width=$(tmux display -p "#{window_width}")

    # NOTE: Can possibly integrate the $only_windows mode into this
    if [[ "$prioritize_windows" == "on" ]]; then
        if [[ "$current_window_count" -gt "$user_window_count" || "$current_window_width" -lt "$user_window_width" ]]; then
            set status-left "$left_column$show_directory"
            # set status-right "$show_directory"
            set status-right ""
        fi
    else
        set status-right "$right_column"
    fi

    # Defaults to a NerdFont icon, user can change through an option
    if [[ "$window_status_separator" != "  " ]]; then
        setw window-status-separator "$window_status_separator"
    else
        setw window-status-separator "  "
    fi

    # Leaves only the window list on the left side
    if [[ "$only_windows" == "on" ]]; then
        set status-left ""
        set status-right ""
    fi


    # NOTE: Dont remove this, it can be useful for references
    # setw window-status-format "$window_status_format"
    # setw window-status-current-format "$window_status_current_format"

    # tmux integrated modes

    setw clock-mode-colour "${thm_love}"
    setw mode-style "fg=${thm_gold}"

    # Call everything to action

    tmux "${tmux_commands[@]}"

}

main "$@"
