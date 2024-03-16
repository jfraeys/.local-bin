#!/usr/bin/env bats

cleanup_session() {
  # Remove the test session
  tmux kill-session -t "$SESSION_NAME"
}

trap 'cleanup_session' EXIT

@test "Script creates a new tmux window with the correct branch name" {
  BRANCH_NAME="test_branch"
  SESSION_NAME="test_session"

  # Get the original session name
  ORIGINAL_SESSION=$(tmux display-message -p "#S")

  # Check if the created session exists
  run tmux has-session -t "$SESSION_NAME"

  if [ "$status" -ne 0 ]; then
    # Create a new tmux session if it doesn't exist
    tmux new-session -d -s "$SESSION_NAME"
  fi

  # Rename window to branch name regardless of session creation
  tmux rename-window -t "$SESSION_NAME" "$BRANCH_NAME"

  # Run your script with predefined branch name and session name
  run ./tmux_windownizer "$BRANCH_NAME"

  # Check if the script exited successfully
  [ "$status" -eq 0 ]

  # Check if tmux window was created
  tmux list-windows -t="$SESSION_NAME" | grep -q "$BRANCH_NAME"
  [ "$?" -eq 0 ]

  # Remove the created tmux window
  run tmux kill-window -t "$SESSION_NAME:$BRANCH_NAME"
  [ "$status" -eq 0 ]

  # Return to the original session
  tmux switch-client -n -t "$ORIGINAL_SESSION"
}
