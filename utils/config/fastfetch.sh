# Set fastfetch configuration
# Usage: setup_fastfetch
# Returns: 0 on success, 1 on failure
setup_fastfetch() {
  logger info "setting up fastfetch configuration..."

	local real_user
	real_user="$(get_real_user)"
	
	local real_home
	real_home="$(getent passwd "$real_user" | cut -d: -f6)"

  if [ -z "$real_home" ]; then
		logger error "could not resolve home directory for user: $real_user"
		return 1
	fi

	local fastfetch_dir="$real_home/.config/fastfetch"
	local config_file="$fastfetch_dir/config.jsonc"
	
	# create directory if it doesn't exist
	if [ ! -d "$fastfetch_dir" ]; then
		mkdir -p "$fastfetch_dir" || {
			logger error "failed to create fastfetch directory"
			return 1
		}
	fi
	
	# create the configuration file
	cat > "$config_file" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "data",
    "source": "\u001b[97m  ▄▀▄▀▀▀▀▄▀▄\n  █        ▀▄      ▄\n █  ▀  ▀     ▀▄▄  █ █\n █ ▄ █▀ ▄       ▀▀  █\n █  ▀▀▀▀            █\n █                  █\n █                  █\n  █  ▄▄  ▄▄▄▄  ▄▄  █\n  █ ▄▀█ ▄▀  █ ▄▀█ ▄▀\n   ▀   ▀     ▀   ▀\u001b[0m",
    "padding": {
      "top": 1,
      "left": 1
    }
  },
  "display": {
    "color": {
      "keys": "90",
      "title": "90"
    }
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "wm",
    "terminal",
    "cpu",
    "gpu",
    "memory",
    "swap",
    "disk",
    "localip",
    "battery",
    "locale"
  ]
}
EOF
	
  echo -e "fastfetch config file: ${BRIGHT_GRAY}${config_file}${RESET}"

	if [ $? -eq 0 ]; then
		logger done "fastfetch configuration updated"
		return 0
	else
		logger error "failed to update fastfetch configuration"
		return 1
	fi
}
