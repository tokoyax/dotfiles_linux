#
# https://github.com/junegunn/fzf/wiki/examples
#

# ghq管理下のリポジトリ選択して移動
fzf-ghq() {
  local repo=$(ghq list | fzf --preview "ghq list --full-path --exact {} | xargs exa -h --long --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2")
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact $repo)
    BUFFER="cd ${repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq
bindkey '^[g' fzf-ghq

# プルリク検索してbranch switch
fzf-pullreq() {
  local pullreq=$(CLICOLOR_FORCE=1 GH_FORCE_TTY=100% gh pr list | tail -n+4 | fzf --ansi --bind "change:reload:CLICOLOR_FORCE=1 GH_FORCE_TTY=100% gh pr list -S {q} | tail -n+4 || true" --disabled --preview "CLICOLOR_FORCE=1 GH_FORCE_TTY=100% gh pr view {1} | bat --color=always --style=grid --file-name a.md")
  if [ -n "$pullreq" ]; then
    pullreq=$(echo $pullreq | awk '{ print $1 }')
    BUFFER="gh pr checkout \"${pullreq}\""
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-pullreq
bindkey '^[p' fzf-pullreq

# ブランチを選択して switch する
fzf-branch() {
  local format="\
%(color:yellow)%(refname:short)%(color:reset)|\
%(color:bold red)%(objectname:short)%(color:reset) \
%(color:bold green)(%(committerdate:relative))%(color:reset) \
%(color:bold blue)%(authorname)%(color:reset) \
%(color:yellow)%(upstream:track)%(color:reset)|\
%(contents:subject)"

  local branch=$(git for-each-ref --color=always --sort=-committerdate "refs/heads/" --format="$format" | column -ts "|" | fzf --preview "git log --color {1}")
  if [ -n "$branch" ]; then
    branch=$(echo $branch | awk '{ print $1 }')
    BUFFER="git switch ${branch}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-branch
bindkey '^[b' fzf-branch

# cdrの履歴からディレクトリを移動する
fzf-cdr(){
    local dir=$(cdr -l | fzf --preview 'f(){ zsh -c "exa -h --long --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2 $1" }; f {2}')
    if [ -n "$dir" ]; then
        dir=$(echo $dir | awk '{ print $1 }')
        BUFFER="cdr ${dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-cdr
bindkey '^[r' fzf-cdr

# tmuxのセッションにアタッチ
fzf-attach-tmux-session () {
  local selected_buffer=$(tmux list-session  | fzf --prompt 'select tmux session> ' | head -n 1 )
  if [ -n "$selected_buffer" ]
  then
    local tmux_session_id=$(echo $selected_buffer | awk -F: '{print $1}')
    BUFFER="tmux attach -t ${tmux_session_id}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-attach-tmux-session
bindkey '^[t' fzf-attach-tmux-session

