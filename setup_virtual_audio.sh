#!/bin/bash

# Setup virtual audio for headless environments
echo "Setting up virtual audio devices..."

# Create a virtual audio device using ALSA
if [ ! -f /proc/asound/cards ]; then
    echo "No audio cards found. Setting up virtual audio..."
    
    # Load snd-dummy module for virtual audio
    modprobe snd-dummy || echo "Could not load snd-dummy module (may need privileged mode)"
    
    # Create ALSA configuration for virtual device
    cat > /etc/asound.conf << EOF
pcm.!default {
    type hw
    card 0
}
ctl.!default {
    type hw
    card 0
}
EOF
fi

# Setup PulseAudio for headless operation
mkdir -p /tmp/pulse
export PULSE_RUNTIME_PATH=/tmp/pulse
export PULSE_STATE_PATH=/tmp/pulse
export PULSE_COOKIE_FILE=/tmp/pulse/cookie

# Start PulseAudio in system mode
pulseaudio --system --disallow-exit --disallow-module-loading=false --daemonize || echo "PulseAudio already running or failed to start"

echo "Virtual audio setup complete." 