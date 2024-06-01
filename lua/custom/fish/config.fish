if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Print all path variables, each on a new line
alias printpath 'printf %s\n $PATH'

alias goodmorning 'source $HOME/.config/nvim/lua/custom/fish/scripts/new_daily_note.fish'

alias writenow 'source $HOME/.config/nvim/lua/custom/fish/scripts/write_now.fish'

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
