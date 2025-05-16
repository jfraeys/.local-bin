#!/usr/bin/env bash

MAX_VOLUME=50
ONLY_ON_HEADPHONES=false
NOTIFICATION_TITLE="Volume Limiter"
HEADPHONES_CONNECTED=false
DELAY=3

# Function to get the current volume on macOS
get_current_volume_macos() {
	osascript -e "output volume of (get volume settings)"
}

# Function to set the volume on macOS
set_volume_macos() {
	osascript -e "set volume output volume $1"
}

# Function to display notification on macOS if not already displayed
display_notification_macos() {
	local title="$1"
	local subtitle="$2"
	local notification_file="/tmp/volume_notification"

	if [[ -f "$notification_file" ]]; then
		local last_notification
		last_notification=$(cat "$notification_file")
		if [[ "$last_notification" == "$subtitle" ]]; then
			return 0 # Notification already displayed
		fi
	fi

	osascript -e "display notification \"$subtitle\" with title \"$title\""
	echo "$subtitle" >"$notification_file"
}

# Function to display notification on Linux if not already displayed
display_notification_linux() {
	local title="$1"
	local subtitle="$2"
	local notification_file="/tmp/volume_notification"

	if [[ -f "$notification_file" ]]; then
		local last_notification
		last_notification=$(cat "$notification_file")
		if [[ "$last_notification" == "$subtitle" ]]; then
			return 0 # Notification already displayed
		fi
	fi

	notify-send "$title" "$subtitle"
	echo "$subtitle" >"$notification_file"
}

# Function to check if output is on internal speakers on macOS
on_speaker_macos() {
	local output_source
	output_source=$(/usr/sbin/system_profiler SPAudioDataType | awk '/Output Source/ {print $NF}')

	# Check if 'Default' is found in the output source
	if echo "$output_source" | grep -q 'Default'; then
		return 1
	else
		return 0
	fi
}

# Function to check if output is on internal speakers on Linux
on_speaker_linux() {
	pacmd list-sinks | grep -q 'active port.*analog-output-speaker'
}

# Function to get the current volume on Linux
get_current_volume_linux() {
	amixer get Master | grep -oP '\d+%' | head -1 | tr -d '%'
}

# Function to set the volume on Linux
set_volume_linux() {
	amixer set Master "$1%"
}

# Function to check if headphones are connected
check_headphones() {
	if [ "$ONLY_ON_HEADPHONES" = true ]; then
		if $on_speaker; then
			if [ "$HEADPHONES_CONNECTED" = true ]; then
				HEADPHONES_CONNECTED=false
				$display_notification "$NOTIFICATION_TITLE" "Volume limiter is stopped, be careful"
			fi
		else
			if [ "$HEADPHONES_CONNECTED" = false ]; then
				HEADPHONES_CONNECTED=true
				limit_volume
				$display_notification "$NOTIFICATION_TITLE" "Limiting your 🎧 headphones to $MAX_VOLUME% to protect your ears"
			fi
		fi
	fi
}

# Function to limit volume
limit_volume() {
	local current_volume
	current_volume=$($get_current_volume)
	if [ "$ONLY_ON_HEADPHONES" = true ]; then
		if [ "$HEADPHONES_CONNECTED" = true ] && [ "$current_volume" -gt "$MAX_VOLUME" ]; then
			$set_volume "$MAX_VOLUME"
		fi
	else
		if [ "$current_volume" -gt "$MAX_VOLUME" ]; then
			$set_volume "$MAX_VOLUME"
		fi
	fi
}

# Main logic
if [[ "$OSTYPE" == "darwin"* ]]; then
	# macOS
	get_current_volume="get_current_volume_macos"
	set_volume="set_volume_macos"
	display_notification="display_notification_macos"
	on_speaker="on_speaker_macos"
else
	# Linux
	get_current_volume="get_current_volume_linux"
	set_volume="set_volume_linux"
	display_notification="display_notification_linux"
	on_speaker="on_speaker_linux"
fi

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
	--headphones-only)
		ONLY_ON_HEADPHONES=true
		shift
		;;
	--max-volume)
		if [[ "$2" =~ ^[0-9]+$ && "$2" -ge 0 && "$2" -le 100 ]]; then
			MAX_VOLUME="$2"
			shift 2
		else
			echo "Error: --max-volume must be followed by a valid percentage (0-100)."
			exit 1
		fi
		;;
	--delay)
		if [[ "$2" =~ ^[0-9]+$ && "$2" -gt 0 ]]; then
			DELAY="$2"
			shift 2
		else
			echo "Error: --delay must be followed by a valid positive integer."
			exit 1
		fi
		;;
	*)
		echo "Usage: $0 [--headphones-only] [--max-volume <percentage>] [--delay <seconds>] [--macos | --linux]"
		exit 1
		;;
	esac
done

for ((i = 1; i <= $((60 / DELAY)); i++)); do
	check_headphones
	limit_volume

	sleep "$DELAY"
done
