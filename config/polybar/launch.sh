#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch example
echo "---" | tee -a /tmp/polybar_example.log
polybar example 2>&1 | tee -a /tmp/polybar_example.log & disown

echo "Bars launched..."
