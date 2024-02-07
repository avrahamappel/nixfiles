# autoload colors && colors

user_name() {
  echo "%B%F{yellow}%n@%m%f%b"
}

directory_name() {
  echo "%B%F{cyan}%~%f%b"
}

shell_level() {
  # Using nix-shell --run zsh increments SHLVL by 2
  lvl=$(( "$SHLVL" / 2 ))
  echo "%(3L. %B%F{#808080}($lvl)%f%b.)"
}

last_error() {
  echo "%(?..%B%F{red}! %?%f%b)"
}

prompt_arrow() {
  echo "%B%F{#808080}%(!.#.\$)%f%b"
}

stash_count() {
  # xargs is a quick and dirty way to trim strings in shell scripts
  count=$(git stash list 2> /dev/null | wc -l | xargs)

  if ! test $count = 0
  then
    echo "%B%F{blue}($count%)%f%b "
  else
    echo ''
  fi
}

tmux_count() {
  # xargs is a quick and dirty way to trim strings in shell scripts
  count=$(tmux ls 2> /dev/null | wc -l | xargs)

  if ! test $count = 0
  then
    echo "%B%F{white}($count%)%f%b "
  else
    echo ''
  fi
}

jobs_count() {
  echo "%(1j.%B%F{green}(%j%)%f%b .)"
}

cur_time () {
  echo "%B%F{#808080}%D{%a %b %d, %I:%M%p}%f%b"
}

set_prompt() {
  setopt PROMPT_SUBST
  export PROMPT=$'\n$(user_name) $(directory_name)$(shell_level)\n$(last_error)\n$(prompt_arrow) '
  export RPROMPT=$'$(stash_count)$(tmux_count)$(jobs_count)$(cur_time)'
}

precmd() {
  set_prompt
}
