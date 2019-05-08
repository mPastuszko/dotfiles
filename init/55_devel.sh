# Don't setup dev environment on Raspberry Pi
[[ "$(uname -a)" =~ armv ]] && return 1

# Load npm_globals, add the default node into the path.
source ~/.dotfiles/source/55_devel.sh

# Install Node.js.
 if [[ "$(type -P nave)" ]]; then
  nave_stable="$(nave stable)"
  if [[ "$(node --version 2>/dev/null)" != "v$nave_stable" ]]; then
    e_header "Installing Node.js $nave_stable"
    # Install most recent stable version.
    nave install stable >/dev/null 2>&1
  fi
  if [[ "$(nave ls | awk '/^default/ {print $2}')" != "$nave_stable" ]]; then
    # Alias the stable version of node as "default".
    nave use default stable true
  fi
fi

# Load npm_globals, add the default node into the path, initialize rbenv.
source ~/.dotfiles/source/55_devel.sh

# Install Npm modules.
if [[ "$(type -P npm)" ]]; then
  e_header "Updating Npm"
  npm update -g npm

  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
  list="$(to_install "${npm_globals[*]}" "${installed[*]}")"
  if [[ "$list" ]]; then
    e_header "Installing Npm modules: $list"
    npm install -g $list
  fi
fi


# Install RVM
if [[ -z "$(type -P rvm)" ]]; then
  e_header "Installing RVM"
  curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ignore-dotfiles
  # we need to link RVM config before the rubies compilation
  ln -sf ~/.dotfiles/link/.rvmrc ~/
  # Load RVM into a shell session *as a function*
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi

# Setup global gems
global_gems=(
  rubygems-bundler
  bundler
  rake
  rvm
  wirble
  pry
  awesome_print
)
e_header "Setting up global gems: ${global_gems[*]}"
echo "${global_gems[*]}" | tr ' ' '\n' > $HOME/.rvm/gemsets/global.gems

# Install Ruby interpreters
versions=(2 1.9.3)
if [[ "$versions" ]]; then
  e_header "Installing Ruby versions: $versions"
  for version in ${versions[*]}; do rvm install "$version"; done
  [[ "$(echo "$versions" | grep -w "${versions[0]}")" ]] && rvm --default use 2 "${versions[0]}"
fi
