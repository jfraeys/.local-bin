#!/usr/bin/env bats

cleanup_session() {
  tmux kill-session -t "$SESSION_NAME"
}

trap 'cleanup_session' EXIT

@test "Script creates a tmux session" {
  TMP_DIR=$(mktemp -d)
  ORIGINAL_SESSION=$(tmux display-message -p "#S")
  SESSION_NAME="test_session"

  # Run your script with predefined selection
  run ./tmux_sessionizer "$TMP_DIR/$SESSION_NAME"

  # Check if the script exited successfully
  [ "$status" -eq 0 ]

  # Check if tmux session was created
  run tmux has-session -t=$SESSION_NAME

  # Check if the tmux session exists
  [ "$status" -eq 0 ]

  # Return to the original session
  tmux switch-client -n -t="$ORIGINAL_SESSION"

  # Clean up (Note: This line is no longer necessary)
  # tmux kill-session -t="$SESSION_NAME"
  rm -r "$TMP_DIR"
}
