#!/usr/bin/env bash

TODAY_TASKS_FILE="today_tasks.txt"
PLANNING_FILE="plan.txt"
skip_file="/tmp/skip_flag"

add_task() {
    local file=$1
    local task_description

    echo "Enter the task description:"
    read -r task_description
    echo "- $task_description" >>"$file"
    echo "Task added to $file."
}

delete_task() {
    local file=$1

    echo "Current tasks in $file:"
    cat "$file"
    echo "Enter the number of the task to delete (starting from 1):"
    read -r task_number

    if [ "$task_number" -le 0 ]; then
        echo "Invalid task number."
        return
    fi

    # Delete the specific task line
    awk -v num="$task_number" 'NR!=num' "$file" >"${file}.tmp" && mv "${file}.tmp" "$file"
    echo "Task $task_number deleted from $file."
}

update_today_tasks() {
    echo "Updating today's tasks:"
    echo "Current tasks for today:"
    if [ -f "$TODAY_TASKS_FILE" ]; then
        cat "$TODAY_TASKS_FILE"
    else
        echo "No tasks for today."
    fi

    echo "Would you like to add or delete a task?"
    echo "1. Add Task"
    echo "2. Delete Task"
    read -rp "Enter choice [1-2]: " choice

    case $choice in
    1)
        add_task "$TODAY_TASKS_FILE"
        ;;
    2)
        delete_task "$TODAY_TASKS_FILE"
        ;;
    *)
        echo "Invalid option."
        ;;
    esac
}

update_planning_file() {
    echo "Updating planning file:"
    echo "Current tasks in planning file:"
    if [ -f "$PLANNING_FILE" ]; then
        cat "$PLANNING_FILE"
    else
        echo "No tasks in planning file."
    fi

    echo "Would you like to add or delete a task?"
    echo "1. Add Task"
    echo "2. Delete Task"
    read -rp "Enter choice [1-2]: " choice

    case $choice in
    1)
        add_task "$PLANNING_FILE"
        ;;
    2)
        delete_task "$PLANNING_FILE"
        ;;
    *)
        echo "Invalid option."
        ;;
    esac
}

menu() {
    while true; do
        echo "Select an option:"
        echo "1. Skip Current Task/Break"
        echo "2. Update Today's Tasks"
        echo "3. Update Planning File"
        echo "4. Exit"
        read -rp "Enter choice [1-4]: " choice

        case $choice in
        1)
            touch "$skip_file"
            echo "Skipping current task or break..."
            ;;
        2)
            update_today_tasks
            ;;
        3)
            update_planning_file
            ;;
        4)
            echo "Exiting menu..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
        esac
    done
}

# Run the menu
menu

