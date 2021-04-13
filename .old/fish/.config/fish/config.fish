
alias vim=nvim
alias lock="xset s activate"

set -gx PATH "$HOME/.cargo/bin" $PATH;
set -gx GEM_HOME (ruby -e 'puts Gem.user_dir');
set -gx PATH "$GEM_HOME/bin" $PATH;
