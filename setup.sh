#!/bin/bash
DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/config.fish" "$HOME/.config/fish/config.fish"
ln -sf "$DOTFILES/vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES/ghostty.config" "$HOME/.config/ghostty/config"
ln -sf "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

chmod +x "$DOTFILES/scripts/reap.sh"
CRON_LINE="0 4 * * * $DOTFILES/scripts/reap.sh"
if ! crontab -l 2>/dev/null | grep -qF "$CRON_LINE"; then
	(
		crontab -l 2>/dev/null
		echo "$CRON_LINE"
	) | crontab -
fi
