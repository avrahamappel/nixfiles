# autoload colors && colors

user_name() {
  echo "%B%F{yellow}%n@%m%f%b"
}

directory_name() {
  echo "%B%F{cyan}%~%f%b"
}

last_error() {
  echo "%(?..%B%F{red}! %?%f%b)"
}

prompt_arrow() {
  echo "%B%F%(!.#.\$)%f%b"
}

stash_count() {
  # xargs is a quick and dirty way to trim strings in shell scripts
  count=$(git stash list 2> /dev/null | wc -l | xargs)

  if ! test $count = 0
  then
    echo "%F%F{blue}($count%)%f%b"
  else
    echo ''
  fi
}

jobs_count() {
  echo "%(1j.%B%F{green}(%j%)%f%b.)"
}

cur_time () {
  echo "%B%F%D{%a, %b %d, %I:%M%p}%f%b"
}

set_prompt() {
  setopt PROMPT_SUBST
  export PROMPT=$'\n$(user_name) $(directory_name)\n$(last_error)\n$(prompt_arrow) '
  export RPROMPT=$'$(stash_count) $(jobs_count) $(cur_time)'
}

precmd() {
  set_prompt
}
