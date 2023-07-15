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
    set monitor-activity "on"
    set status-justify "left"
    set status-left-length "100"
    set status-right-length "100"

    # Theoretically messages (need to figure out color placement) 
    set message-style "fg=$thm_muted,bg=$thm_base,align=centre"
    set message-command-style "fg=$thm_base,bg=$thm_gold,align=centre"

    # Pane styling
    set pane-border-style "fg=$thm_hl_high"
    set pane-active-border-style "fg=$thm_gold"
    set display-panes-active-colour "${thm_text}"
    set display-panes-colour "${thm_gold}"

    # Windows
    setw window-status-separator "  "
    setw window-status-style "fg=${thm_iris},bg=${thm_base}"
    setw window-status-activity-style "fg=${thm_base},bg=${thm_rose}"
    setw window-status-current-style "fg=${thm_gold},bg=${thm_base}"

    # Statusline base command configuration: No need to touch anything here
    # Placement is handled below

    # NOTE: Checking for the value of @rose_pine_window_tabs_enabled
    local window
    window="$(get_tmux_option "@rose_pine_current_window" "")"
    readonly window

    local user
    user="$(get_tmux_option "@rose_pine_user" "")"
    readonly user

    local host
    host="$(get_tmux_option "@rose_pine_host" "")"
    readonly host

    local date_time
    date_time="$(get_tmux_option "@rose_pine_date_time" "")"
    readonly date_time

    local directory
    directory="$(get_tmux_option "@rose_pine_directory" "")"

    local wt_enabled
    wt_enabled="$(get_tmux_option "@rose_pine_window_tabs_enabled" "off")"
    readonly wt_enabled

    local bar_bg_disable
    bar_bg_disable="$(get_tmux_option "@rose_pine_bar_bg_disable" "")"
    readonly bar_bg_disable

    local right_separator
    right_separator="$(get_tmux_option "@rose_pine_right_separator" "  ")"

    local left_separator
    left_separator="$(get_tmux_option "@rose_pine_left_separator" "  ")"

    local field_separator
    field_separator="$(get_tmux_option "@rose_pine_field_separator" " | " )"

    local spacer
    spacer=" "

    # These variables are the defaults so that the setw and set calls are easier to parse

    local show_window
    readonly show_window=" #[fg=$thm_subtle] #[fg=$thm_rose]#W$spacer "

    local show_window_in_window_status
    show_window_in_window_status="#[fg=$thm_iris]#I#[fg=$thm_iris,]$left_separator#[fg=$thm_iris]#W"

    local show_window_in_window_status_current
    show_window_in_window_status_current="#I#[fg=$thm_gold,bg=""]$left_separator#[fg=$thm_gold,bg=""]#W"

    local show_session
    readonly show_session=" #[fg=$thm_text] #[fg=$thm_text]#S "

    local show_user
    readonly show_user="#[fg=$thm_iris]#(whoami)#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]"

    local show_host
    readonly show_host=" #[fg=$thm_text]#H #[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]󰒋"

    local show_date_time
    readonly show_date_time="$field_separator#[fg=$thm_foam]$date_time#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]󰃰"

    local show_directory
    readonly show_directory=" #[fg=$thm_subtle] #[fg=$thm_rose]#{b:pane_current_path}"
    # TODO: Implement a mode to toggle the directory show style and remove thm_bg
    # The appended code that wasn't working and is the second style:
    # $spacer#[fg=${thm_love}]$right_separator#[fg=$thm_bg] $field_separator

    local show_directory_in_window_status
    readonly show_directory_in_window_status="#I$left_separator#[fg=$thm_gold,bg=""]#{b:pane_current_path}"

    local show_directory_in_window_status_current
    readonly show_directory_in_window_status_current="#I$left_separator#[fg=$thm_gold,bg=""]#{b:pane_current_path}"

    # Left column placement: Determined by the set status-left on line 231

    # Right columns organization:

    # Right column 1 shows, by default, the username
    local right_column1=$show_user

    # Right column 2 shows, by default, the current directory you're working on
    local right_column2=$spacer$show_directory

    # Window status by default shows the current directory basename
    local window_status_format=$show_directory_in_window_status
    local window_status_current_format=$show_directory_in_window_status_current

    # This if statement allows the bg colors to be null if the user decides so
    if [[ "$bar_bg_disable" == "on" ]]; then 
        set status-style "fg=$thm_pine,bg=0"
        show_window_in_window_status="#[fg=$thm_iris,bg=0]#I#[fg=$thm_iris,bg=0]$left_separator#[fg=$thm_iris,bg=0]#W"
        show_window_in_window_status_current="#[fg=$thm_gold,bg=0]#I#[fg=$thm_gold,bg=0]$left_separator#[fg=$thm_gold,bg=0]#W"
    fi

    # This option toggles between the default (current directory for the window's pane)
    # and the $wt_enabled option, which is the tmux default behaviour
    # Will make it 2 options instead of 1 :)
    if [[ "$wt_enabled" == "on" ]]; then
        window_status_format=$show_window_in_window_status
        window_status_current_format=$show_window_in_window_status_current
    fi

    if [[ "$host" == "on" ]]; then
        right_column1=$right_column1$show_host
    fi

    if [[ "$date_time" != "" ]]; then
        right_column1=$right_column1$show_date_time
    fi

    # if [[ "$user" == "on" ]]; then
    #     right_column1=$right_column1$show_user
    # fi
    #
    # if [[ "$directory" == "on" ]]; then
    #     right_column1=$right_column1$show_directory
    # fi

    set status-left "$show_session$show_window"

    set status-right "$right_column1$right_column2"

    # set -g status-interval 1

    setw window-status-format "$window_status_format"
    setw window-status-current-format "$window_status_current_format"

    # tmux integrated modes 

    setw clock-mode-colour "${thm_love}"
    setw mode-style "fg=${thm_gold}"

    # Call everything to action

    tmux "${tmux_commands[@]}"

}

main "$@"
