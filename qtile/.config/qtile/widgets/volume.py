from libqtile.widget.pulse_volume import PulseVolume


class CustomPulseVolume(PulseVolume):
    """Custom PulseVolume widget with configurable icons for different volume levels."""

    defaults = [
        ("mute_icon", "", "Icon for muted state"),
        ("low_icon", "", "Icon for low volume (0-50%)"),
        ("high_icon", "", "Icon for high volume (51-100%)"),
        ("threshold", 50, "Threshold for low/high volume percentage"),
    ]

    def __init__(self, **config):
        PulseVolume.__init__(self, **config)
        self.add_defaults(CustomPulseVolume.defaults)

    def _get_volume_icon(self):
        """Determine which icon to use based on volume level and mute status."""
        if self.is_mute:
            return self.mute_icon
        elif self.volume == -1:
            return "?"
        elif self.volume <= self.threshold:
            return self.low_icon
        else:
            return self.high_icon

    def _update_drawer(self):
        """Update the text with icon and volume percentage."""
        # Set the text with our custom format
        if self.is_mute:
            self.text = f"{self.mute_icon} ---"
        elif self.volume == -1:
            self.text = f"{self._get_volume_icon()} --"
        else:
            icon = self._get_volume_icon()
            self.text = f"{icon} {self.volume}%"
        # Don't call parent's _update_drawer as it would overwrite our text
