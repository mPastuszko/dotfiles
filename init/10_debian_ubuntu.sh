# Debian and Ubuntu-only stuff. Abort if not Debian or Ubuntu.
[[ "$(uname -a)" =~ Debian ]] || [[ "$(uname -a)" =~ Ubuntu ]] || return 1

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  build-essential libssl-dev
  git mercurial
  tree sl tmux vim ctags bash-completion
  nmap telnet links dnsutils
  htop sysv-rc-conf rcconf denyhosts
  libxslt-dev libxml2-dev # nokogiri dependencies
)

list=()
for package in "${packages[@]}"; do
  if [[ ! "$(dpkg -l "$package" 2>/dev/null | grep "^ii  $package")" ]]; then
    list=("${list[@]}" "$package")
  fi
done

if (( ${#list[@]} > 0 )); then
  e_header "Installing APT packages: ${list[*]}"
  for package in "${list[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi

# Install Git Extras
if [[ ! "$(type -P git-extras)" ]]; then
  e_header "Installing Git Extras"
  (
    cd ~/.dotfiles/libs/git-extras &&
    sudo make install
  )
fi
