from libqtile.widget import base


class CustomBattery(base.ThreadPoolText):
    """Custom battery widget with configurable icons for different battery levels."""

    defaults = [
        ("low_icon", "", "Icon for low battery (0-33%)"),
        ("medium_icon", "", "Icon for medium battery (34-66%)"),
        ("high_icon", "", "Icon for high battery (67-100%)"),
        ("low_threshold", 33, "Threshold for low battery percentage"),
        ("high_threshold", 67, "Threshold for high battery percentage"),
        ("update_interval", 60, "Update interval in seconds"),
        ("battery", 0, "Battery number (0 for BAT0, 1 for BAT1, etc.)"),
    ]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(CustomBattery.defaults)

    def poll(self):
        """Poll battery status and return formatted string."""
        try:
            # Read battery percentage
            bat_path = f"/sys/class/power_supply/BAT{self.battery}"
            with open(f"{bat_path}/capacity", "r") as f:
                percent = int(f.read().strip())

            # Determine which icon to use
            if percent <= self.low_threshold:
                icon = self.low_icon
            elif percent <= self.high_threshold:
                icon = self.medium_icon
            else:
                icon = self.high_icon

            return f"{icon} {percent}%"
        except Exception as e:
            return f"Battery Error"
