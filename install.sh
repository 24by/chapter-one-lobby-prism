#!/bin/sh
# SPDX-FileCopyrightText: 2026 24by
# SPDX-License-Identifier: CC0-1.0

set -eu

source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
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
        *) printf '%s\n' 'Pass your Prism data folder as the first argument.' >&2; exit 1 ;;
    esac
fi

mkdir -p "$prism_dir/themes/Chapter-One-Lobby" "$prism_dir/iconthemes/Chapter-One-Lobby/scalable"
cp "$source_dir/themes/Chapter-One-Lobby/theme.json" \
   "$source_dir/themes/Chapter-One-Lobby/themeStyle.css" \
   "$prism_dir/themes/Chapter-One-Lobby/"
cp "$source_dir/icons/Chapter-One-Lobby/index.theme" "$prism_dir/iconthemes/Chapter-One-Lobby/"
cp "$source_dir/icons/Chapter-One-Lobby/scalable/"*.svg "$prism_dir/iconthemes/Chapter-One-Lobby/scalable/"
printf '%s\n' 'Restart Prism and select Chapter One Lobby for Widgets and Icons.'
