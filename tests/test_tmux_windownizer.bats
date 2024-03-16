#!/usr/bin/env bats

@test "Script creates a new tmux window with the correct branch name" {
  BRANCH_NAME="test_branch"
  SESSION_NAME="test_session"

  # Check if the created session exists
  run tmux has-session -t "$SESSION_NAME"

  if [ "$status" -ne 0 ]; then
    # Create a new tmux session if it doesn't exist
    run tmux new-session -d -s "$SESSION_NAME"
    # Check if the session was created successfully
    [ "$status" -eq 0 ]

    # Switch into the new test session
    if [ "$status" -eq 0 ]; then
      run tmux switch-client -t "$SESSION_NAME"
      [ "$status" -eq 0 ]
    fi
  fi

  # Run your script with predefined branch name and session name
  run ./tmux_windownizer "$BRANCH_NAME"

  # Check if the script exited successfully
  [ "$status" -eq 0 ]

  # Check if tmux window was created
  run tmux list-windows -t="$SESSION_NAME" | grep "$BRANCH_NAME"
  [ "$status" -eq 0 ]

  # Remove the created tmux window
  run tmux kill-window -t "$SESSION_NAME:$BRANCH_NAME"
  [ "$status" -eq 0 ]

  # Remove the test session
  run tmux kill-session -t "$SESSION_NAME"
  [ "$status" -eq 0 ]
}
