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

if [[ $theme == main ]]; then

    thm_base="#191724"; # Used for
    thm_surface="#1f1d2e"; # Used for
    thm_overlay="#26233a"; # Used for
    thm_muted="#6e6a86"; # Used for
    thm_subtle="#908caa"; # Used for
    thm_text="#e0def4"; # Used for
    thm_love="#eb6f92"; # Used for
    thm_gold="#f6c177"; # Used for
    thm_rose="#ebbcba"; # Used for
    thm_pine="#31748f"; # Used for
    thm_foam="#9ccfd8"; # Used for
    thm_iris="#c4a7e7"; # Used for
    thm_hl_low="#21202e"; # Used for
    thm_hl_med="#403d52"; # Used for
    thm_hl_high="#524f67"; # Used for

    elif [[ $theme == dawn ]]; then

        thm_base="#faf4ed"; # Used for
        thm_surface="#fffaf3"; # Used for
        thm_overlay="#f2e9e1"; # Used for
        thm_muted="#9893a5"; # Used for
        thm_subtle="#797593"; # Used for
        thm_text="#575279"; # Used for
        thm_love="#b4367a"; # Used for
        thm_gold="#ea9d34"; # Used for
        thm_rose="#d7827e"; # Used for
        thm_pine="#286983"; # Used for
        thm_foam="#56949f"; # Used for
        thm_iris="#907aa9"; # Used for
        thm_hl_low="#f4ede8"; # Used for
        thm_hl_med="#dfdad9"; # Used for
        thm_hl_high="#cecacd"; # Used for

    elif [[ $theme == moon ]]; then

        thm_base="#191724"; # Used for
        thm_surface="#1f1d2e"; # Used for
        thm_overlay="#26233a";# Used for
        thm_muted="#6e6a86"; # Used for
        thm_subtle="#908caa"; # Used for
        thm_text="#e0def4"; # Used for
        thm_love="#eb6f92"; # Used for
        thm_gold="#f6c177"; # Used for
        thm_rose="#ebbcba"; # Used for
        thm_pine="#31748f"; # Used for
        thm_foam="#9ccfd8"; # Used for
        thm_iris="#c4a7e7"; # Used for
        thm_hl_low="#21202e"; # Used for
        thm_hl_med="#403d52"; # Used for
        thm_hl_high="#524f67"; # Used for

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

  local right_separator
  right_separator="$(get_tmux_option "@rose_pine_right_separator" " ")"

  local left_separator
  left_separator="$(get_tmux_option "@rose_pine_left_separator" "  ")"

  local field_separator
  field_separator="$(get_tmux_option "@rose_pine_field_separator" " | " )"

  local spacer
  spacer=" "


  # These variables are the defaults so that the setw and set calls are easier to parse

  local show_window
  readonly show_window=" #[fg=$thm_subtle] #[fg=$thm_rose]#W$left_separator"

  local show_window_in_window_status
  readonly show_window_in_window_status="#[fg=$thm_fg,bg=$thm_bg] #W #[fg=$thm_bg,bg=$thm_foam] #I#[fg=$thm_foam,bg=$thm_bg]$left_separator#[fg=$thm_fg,bg=$thm_bg,nobold,nounderscore,noitalics] "

  local show_window_in_window_status_current
  readonly show_window_in_window_status_current="#[fg=$thm_fg] #W #[fg=$thm_bg] #I#[fg=$thm_orange,bg=$thm_bg]$left_separator#[fg=$thm_fg,bg=$thm_bg,nobold,nounderscore,noitalics] "

  local show_session
  readonly show_session=" #[fg=$thm_text] #[fg=$thm_text]#S "

  local show_user
  readonly show_user="#[fg=$thm_iris]#(whoami) #[fg=$thm_subtle]$right_separator#[fg=$thm_subtle] "

  local show_host
  readonly show_host=" #[fg=$thm_text]#H #[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]󰒋"

  local show_date_time
  readonly show_date_time="$field_separator#[fg=$thm_foam]$date_time #[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]󰃰"

  local show_directory
  readonly show_directory=" #[fg=$thm_subtle] #[fg=$thm_rose]#{b:pane_current_path} #{?client_prefix,$spacer#[fg=${thm_love}]$right_separator#[fg=$thm_bg] $field_separator"

  local show_directory_in_window_status
  readonly show_directory_in_window_status="#[fg=$thm_bg] #I #[fg=$thm_fg] #{b:pane_current_path} "

  local show_directory_in_window_status_current
  readonly show_directory_in_window_status_current=" #I #[fg=$thm_iris,bg=$thm_bg] #{b:pane_current_path}"


  # Left column placement: Determined by the set status-left on line 236

  
  #Right columns organization:
  
  # Right column 1 shows, by default, the username
  local right_column1=$show_user

  # Right column 2 shows, by default, the current directory you're working on
  local right_column2=$spacer$show_directory

  # Window status by default shows the current directory basename
  local window_status_format=$show_directory_in_window_status
  local window_status_current_format=$show_directory_in_window_status_current


  if [[ "$wt_enabled" == "on" ]]; then
      window_status_format=$show_window_in_window_status
      window_status_current_format=$show_window_in_window_status
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

  set status-interval 1

  setw window-status-format "$window_status_format"

  setw window-status-current-format "$window_status_current_format"

  
  # tmux integrated modes 

  setw clock-mode-colour "${thm_love}"
  setw mode-style "fg=${thm_gold}"

  # Call everything to action

  tmux "${tmux_commands[@]}"

}

main "$@"
