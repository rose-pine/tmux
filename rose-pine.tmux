#!/usr/bin/env bash
PLUGIN_DIR="$HOME/.tmux/plugins/tmux"
#
# Rosé Pine - tmux theme
# 
# Inspired by powerline/powerline, catppucin/tmux & challenger-deep-theme/tmux
#


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
    theme="$(get_tmux_option "@rose_pine_flavour" "base")"

    # Aggregating all commands into a single array
    local tmux_commands=()

   # Pulling in the selected theme by the theme that's being set as local in .tmux.conf 
   # variables
  source /dev/stdin <<<"$(sed -e "/^[^#].*=/s/^/local /" "${PLUGIN_DIR}/palletes/rose-pine-${theme}.tmuxtheme")"

  # Status bar
  set status "on"
  set status-bg "$(thm_surface)"
  set status-justify "left"
  set status-left-length "120"
  set status-right-length "120"

  # Theoretically messages (need to figure out color placement) 
  set message-style "fg=${thm_surface},bg=${thm_overlay},align=centre"
  set message-command-style "fg=${thm_surface},bg=${thm_overlay},align=centre"

  # Pane styling
  set pane-border-style "fg=${thm_subtle}"
  set pane-active-border-style "fg=${thm_hl_high}"

  # Windows
  setw window-status-activity-style "fg=$(thm_hl_high),bg=${thm_hl_mid},none"
  setw window-status-separator ""
  setw window-status-style "fg=${thm_hl_low},bg=${thm_hl_mid}"


  # Statusline configuration

  # NOTE: Checking for the value of @rose_pine_window_tabs_enabled
  local wt_enabled
  wt_enabled="$(get_tmux_option "@rose_pine_window_tabs_enabled" "off")"
  readonly wt_enabled

  local right_separator
  right_separator="$(get_tmux_option "@rose_pine_right_separator" "<putseparatorhere")"


  local left_separator
  left_separator="$(get_tmux_option "@rose_pine_left_separator" "<putseparatorhere")"

  local user
  user="$(get_tmux_option "@rose_pine_user" "off")"
  readonly user

  local host
  host="$(get_tmux_option "@rose_pine_host" "off")"
  readonly host

  local date_time
  date_time="$(get_tmux_option "@rose_pine_date_time" "off")"
  readonly date_time

  # These variables are the defaults so that the setw and set calls are easier to parse

  local show_directory
  readonly show_directory="#[fg=$thm_rose,bg=$thm_bg,nobold,nounderscore,noitalics]$right_separator#[fg=$thm_bg,bg=$thm_pink,nobold,nounderscore,noitalics]  #[fg=$thm_fg,bg=$thm_gray] #{b:pane_current_path} #{?client_prefix,#[fg=$thm_red]"

  local show_window
  readonly show_window="#[fg=$thm_pink,bg=$thm_bg,nobold,nounderscore,noitalics]$right_separator#[fg=$thm_bg,bg=$thm_pink,nobold,nounderscore,noitalics] #[fg=$thm_fg,bg=$thm_gray] #W #{?client_prefix,#[fg=$thm_red]"

  local show_session
  readonly show_session="#[fg=$thm_green]}#[bg=$thm_gray]$right_separator#{?client_prefix,#[bg=$thm_red],#[bg=$thm_green]}#[fg=$thm_bg] #[fg=$thm_fg,bg=$thm_gray] #S "

  local show_directory_in_window_status
  readonly show_directory_in_window_status="#[fg=$thm_bg,bg=$thm_foam] #I #[fg=$thm_fg,bg=$thm_gray] #{b:pane_current_path} "

  local show_directory_in_window_status_current
  readonly show_directory_in_window_status_current="#[fg=$thm_bg,bg=$thm_orange] #I #[fg=$thm_fg,bg=$thm_bg] #{b:pane_current_path} "

  local show_window_in_window_status
  readonly show_window_in_window_status="#[fg=$thm_fg,bg=$thm_bg] #W #[fg=$thm_bg,bg=$thm_foam] #I#[fg=$thm_foam,bg=$thm_bg]$left_separator#[fg=$thm_fg,bg=$thm_bg,nobold,nounderscore,noitalics] "

  local show_window_in_window_status_current
  readonly show_window_in_window_status_current="#[fg=$thm_fg,bg=$thm_gray] #W #[fg=$thm_bg,bg=$thm_orange] #I#[fg=$thm_orange,bg=$thm_bg]$left_separator#[fg=$thm_fg,bg=$thm_bg,nobold,nounderscore,noitalics] "

  local show_user
  readonly show_user="#[fg=$thm_foam,bg=$thm_gray]$right_separator#[fg=$thm_bg,bg=$thm_foam] #[fg=$thm_fg,bg=$thm_gray] #(whoami) "

  local show_host
  readonly show_host="#[fg=$thm_foam,bg=$thm_gray]$right_separator#[fg=$thm_bg,bg=$thm_foam]󰒋 #[fg=$thm_fg,bg=$thm_gray] #H "

  local show_date_time
  readonly show_date_time="#[fg=$thm_foam,bg=$thm_gray]$right_separator#[fg=$thm_bg,bg=$thm_foam] #[fg=$thm_fg,bg=$thm_gray] $date_time "


  #Right column 1 shows, by default, the window name
  local right_column1=$show_window

  #Right column 2 shows, by default, the current session name
  local right_column2=$show_session

  # Window status by default shows the current directory basename
  local window_status_format=$show_directory_in_window_status
  local window_status_current_format=$show_directory_in_window_status_current

  # NOTE: With the @rose_pine_window_tabs_enabled set to on, we're going to
  # update the right_column1 and the window_status_* variables.
  if [[ "$wt_enabled" == "on" ]]; then
      right_column1=$show_directory
      window_status_format=$show_window_in_window_status
      window_status_current_format=$show_window_in_window_status
  fi

  if [[ "${user}" == "on" ]]; then
      right_column2=$right_column2$show_user
  fi

  if [[ "${host}" == "on" ]]; then
      right_column2=$right_column2$show_host
  fi

  if [[ "${show_date_time}" ]]; then
      right_column2=$right_column2$show_date_time
  fi


  set status-left ""

  set status-right "${right_column1},${right_column2}"

  setw window-status-format "${window_status_format}"

  setw window-status-current-format "${window_status_current_format}"

  # tmux integrated modes 

  setw clock-mode-colour "${thm_love}"
  setw mode-style "fg=${thm_gold}"

  tmux "${tmux_commands[@]}"

}

main "$@"
