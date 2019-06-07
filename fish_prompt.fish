# name: Mish

set -g cyan (set_color 33FFFF)
set -g yellow (set_color -o yellow)
set -g red (set_color -o red)
set -g green (set_color -o green)
set -g white (set_color -o white)
set -g blue (set_color -o blue)
set -g magenta (set_color -o magenta)
set -g normal (set_color normal)
set -g purple (set_color -o purple)

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _git_ahead -d "git repository is ahead or behind origin"
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2> /dev/null)

  if [ $status != 0 ]
    return
  end

  set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
  set -l ahead (count (for arg in $commits; echo $arg; end | grep -v '^<'))

  switch "$ahead $behind"
  case '' # no upstream
    printf ""
  case '0 0' # equal to upstream
    printf ""
  case '* 0' # ahead of upstream
    echo -n " $green+ $ahead↑"
  case '0 *' # behind upstream
    echo -n " $blue- $behind↓"
  case '*' # diverged from upstream
    echo -n " ± $green$ahead↑ $blue$behind↓"
  end
end

function fish_prompt

  set -l cwd (basename (prompt_pwd))

  echo -n -s $yellow (whoami)
  echo -n -s $cyan ' ' $cwd $normal
  echo -n -s (_git_ahead) $normal

  if [ (_is_git_dirty) ]
    echo -s $red (__fish_git_prompt) $blue '* '
  else
    echo -s $green (__fish_git_prompt) ' '
  end

end
