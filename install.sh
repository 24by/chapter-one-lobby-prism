#!/bin/sh
# SPDX-FileCopyrightText: 2026 24by
# SPDX-License-Identifier: CC0-1.0

set -eu

source_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
if [ "$#" -gt 0 ]; then
	prism_dir=$1
else
	case "$(uname -s)" in
	Darwin) prism_dir="$HOME/Library/Application Support/PrismLauncher" ;;
	Linux)
		flatpak_dir="$HOME/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher"
		native_dir="${XDG_DATA_HOME:-"$HOME/.local/share"}/PrismLauncher"
		if [ -d "$flatpak_dir" ] && [ ! -d "$native_dir" ]; then
			prism_dir=$flatpak_dir
		else
			prism_dir=$native_dir
		fi
		;;
	*)
		printf '%s\n' 'Pass your Prism data folder as the first argument.' >&2
		exit 1
		;;
	esac
fi

theme="$source_dir/themes/Chapter-One-Lobby"
icons="$source_dir/icons/Chapter-One-Lobby"
theme_target="$prism_dir/themes/Chapter-One-Lobby"
icon_target="$prism_dir/iconthemes/Chapter-One-Lobby"

for file in "$theme/theme.json" "$theme/themeStyle.css" "$theme/resources/"*.svg "$icons/index.theme" "$icons/scalable/"*.svg; do
	if [ ! -f "$file" ]; then
		printf '%s\n' 'Extract the entire ZIP before running install.sh.' >&2
		exit 1
	fi
done

mkdir -p "$theme_target/resources" "$icon_target/scalable"
cp "$theme/theme.json" "$theme/themeStyle.css" "$theme_target/"
cp "$theme/resources/"*.svg "$theme_target/resources/"
cp "$icons/index.theme" "$icon_target/"
cp "$icons/scalable/"*.svg "$icon_target/scalable/"
printf '%s\n' 'Restart Prism and select Chapter One Lobby for Widgets and Icons.'
