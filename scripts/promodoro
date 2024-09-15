#!/usr/bin/env bash

LOG_FILE="tasks.log"
PLANNING_FILE="plan.txt"
TODAY_TASKS_FILE="today_tasks.txt"
MENU_TMUX_FILE="\"$HOME\"/.local/bin/scripts/pomodoro_menu"
MENU_WEZTERM_FILE="\"$HOME\"/.local/bin/scripts/pomodoro_menu"

WORK_INTERVAL=25
SHORT_BREAK=5
LONG_BREAK=15
NUM_INTERVALS=4

# Determine the terminal environment
detect_os_and_terminal() {
    OS=$(uname)
    if [ "$OS" == "Darwin" ]; then
        OS_TYPE="mac"
    else
        OS_TYPE="linux"
    fi

    TERMINAL_TYPE=$(ps -o comm= $$)

    if [ "$TERMINAL_TYPE" == "tmux" ]; then
        if ! tmux has-session -t "$MENU_TMUX_FILE" 2>/dev/null; then
            tmux new-session -d -s "$MENU_TMUX_FILE" bash -c "$MENU_TMUX_FILE"
        fi
        tmux split-window -t "$MENU_TMUX_FILE" bash -c "$MENU_TMUX_FILE"
    elif [ "$TERMINAL_TYPE" == "wezterm" ]; then
        wezterm cli start --new-tab --cwd="$PWD" -- bash -c "$MENU_WEZTERM_FILE"
    fi
}

notify() {
    local message=$1
    local title="Pomodoro Timer"
    if [ "$OS_TYPE" == "mac" ]; then
        osascript -e "display notification \"$message\" with title \"$title\""
    else
        notify-send "$title" "$message"
    fi
}

print_timer() {
    local minutes=$1
    local task_name=$2
    local break_time=$3

    local interval=$((minutes * 60))
    local end_time=$((SECONDS + interval))

    notify "Starting task: $task_name"
    echo "Starting task: $task_name"

    while [ $SECONDS -lt $end_time ]; do
        local remaining=$((end_time - SECONDS))
        local mins=$((remaining / 60))
        local secs=$((remaining % 60))
        printf "\rTime left for task: %02d:%02d" $mins $secs
        sleep 1
    done

    notify "Time for break: $break_time minutes"
    echo -e "\nTime for break: $break_time minutes"
    sleep $((break_time * 60))
}

log_task() {
    local task_name=$1
    local start_time
    start_time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$start_time - $task_name" >>"$LOG_FILE"
}

plan_next_day() {
    echo "Plan for tomorrow:"
    read -rp "Enter tasks for tomorrow (separated by commas): " tasks

    if [ "$OS_TYPE" == "mac" ]; then
        date_fmt=$(date -j -v+1d +"%Y-%m-%d")
    else
        date_fmt=$(date -d tomorrow +"%Y-%m-%d")
    fi

    echo "Tasks for $date_fmt:" >"$PLANNING_FILE"
    IFS=',' read -ra TASK_ARRAY <<<"$tasks"
    for task in "${TASK_ARRAY[@]}"; do
        task=$(echo "$task" | xargs)
        echo "- $task" >>"$PLANNING_FILE"
    done

    echo "Tasks for tomorrow have been saved in $PLANNING_FILE."
}

handle_skip() {
    local pid=$1

    while [ -e "$skip_file" ]; do
        sleep 1
    done

    kill "$pid" 2>/dev/null
    wait "$pid" 2>/dev/null
}

cleanup() {
    if [ -n "$timer_pid" ]; then
        kill "$timer_pid" 2>/dev/null
        wait "$timer_pid" 2>/dev/null
    fi
}

trap cleanup EXIT

start_timer() {
    local current_task_name=""
    notify "Starting the Pomodoro Technique Timer"
    echo "Pomodoro Technique Timer"

    # Prompt for the name of the first task
    read -rp "Enter the name of the first task: " current_task_name
    log_task "$current_task_name"

    run_timer() {
        local task_name="$1"
        local work_interval="$2"
        local short_break="$3"

        skip_file="/tmp/skip_flag"
        [ -e "$skip_file" ] && rm "$skip_file"

        nohup bash -c "(print_timer $work_interval \"$task_name\" $short_break)" >/dev/null 2>&1 &
        timer_pid=$!

        handle_skip "$timer_pid" &
        wait "$timer_pid"
    }

    for ((i = 1; i <= NUM_INTERVALS; i++)); do
        run_timer "$current_task_name" $WORK_INTERVAL $SHORT_BREAK

        # Prompt for the next task if not on the last interval
        if ((i < NUM_INTERVALS)); then
            echo "Interval task: $current_task_name completed."

            if [ -z "$task_name_from_menu" ]; then
                read -rp "Enter the name of the next task: " current_task_name
                log_task "$current_task_name"
            fi
        fi
    done

    notify "Long break time: $LONG_BREAK minutes"
    echo "Take a long break now: $LONG_BREAK minutes"
    sleep $((LONG_BREAK * 60))

    notify "All tasks are completed!"
}

detect_os_and_terminal
start_timer

