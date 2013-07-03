function home_pwd --description 'Print the current working directory, abbreviated with ~ when possible'
  echo $PWD | sed -e "s|^$HOME|~|"
end

function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

  # User
  set_color $fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n ' at '

  # Host
  set_color $fish_color_host
  echo -n (hostname -s)
  set_color normal

  echo -n ' in '

  # PWD
  set_color $fish_color_cwd
  echo -n (home_pwd)
  set_color normal

  echo -n ' '

  __terlar_git_prompt
  echo

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  echo -n '$ '
  set_color normal
end
