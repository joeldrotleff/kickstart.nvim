if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path "$HOME/.deno/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "/opt/homebrew/bin"

sh "$HOME/code/joya/mp-desktop-web/script/import.sh"
fish_add_path "/Applications/Windsurf.app/Contents/Resources/app/bin/"
fish_add_path "$HOME/.pyenv/shims/"

# See: https://github.com/pyenv/pyenv?tab=readme-ov-file#b-set-up-your-shell-environment-for-pyenv
pyenv init - fish | source

alias nv 'nvim'

# Print all path variables, each on a new line
alias printpath 'printf %s\n $PATH'

# Start a new document - let's do some writing!
alias writenow 'source $HOME/.config/nvim/lua/custom/fish/scripts/write_now.fish'

# Start a new daily note named after current date (usually for work)
alias goodmorning 'source $HOME/.config/nvim/lua/custom/fish/scripts/new_daily_note.fish'

# Old alternate neovim config
alias nvchad='NVIM_APPNAME="chad" nvim'

# Delete derivded data folder (Ah. xcode)
alias ddd='rm -rf ~/Library/Developer/Xcode/DerivedData/'

export AIDER_DARK_MODE=true

# Rerun xcode-build server for active projects
alias mpxlspbuild='cd ~/code/joya/mpx && xcode-build-server config -project ~/code/joya/mpx/MPX/*.xcodeproj -scheme "MPX"'
alias mplspbuild='cd ~/code/joya/marcopolo-app/ios && xcode-build-server config -workspace ~/code/joya/marcopolo-app/ios/*.xcworkspace -scheme "MarcoPolo Dev IAP"'
alias sdrlspbuild='cd ~/code/joya/sdr/client && xcode-build-server config -project *xcodeproj -scheme SDR'
alias tofu_test_lspbuild='cd ~/code/joya/sdr/client/no_backend/ && xcode-build-server config -project *xcodeproj -scheme SDRMobile'
alias tofu_mobile_lspbuild='cd ~/code/joya/sdr/client/real_backend/ && xcode-build-server config -project *xcodeproj -scheme "Tofu Mobile"'
alias tofu_desktop_lspbuild='cd ~/code/joya/sdr/client/real_backend/ && xcode-build-server config -project *xcodeproj -scheme "Tofu Desktop"'

# Command fixer utility 'fuck'
thefuck --alias | source

# Loads all the shell variables from a .env file
function envsource
  set -f envfile "$argv"
  if not test -f "$envfile"
    echo "Unable to load $envfile"
    return 1
  end
  while read line
    if not string match -qr '^#|^$' "$line"
      set item (string split -m 1 '=' $line)
      set -gx $item[1] $item[2]
      echo "Exported key $item[1]"
    end
  end < "$envfile"
end


function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color blue)(prompt_pwd)' '

    set_color -o
    if fish_is_root_user
        echo -n (set_color red)'# '
    end

		# Make prompt look like a little fish
		echo -n (set_color brblue)'⋊'(set_color brblue)'> '
    set_color normal
end

# Make sure right-side prompt is empty 
function fish_right_prompt
end


# Vi mode!
fish_vi_key_bindings

# Don't show pointless "[I]" before the prompt when in i.e. insert mode
function fish_mode_prompt
end

# Add the emacs-style "accept autocomplete" key binding (using vi mode disables it)
bind -M insert \cf accept-autosuggestion
 
set -gx ANDROID_HOME $HOME/Library/Android/sdk
