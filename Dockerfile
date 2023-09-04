FROM ubuntu:22.04

RUN apt-get update

## setting timezone ##
RUN DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -y install tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "Asia/Tokyo" > /etc/timezone

## install packages ##
#RUN apt-get install -y zsh git curl vim
RUN apt-get install -y \
    build-essential  \
    cmake \
    curl \
    git \
    python3-pip \
    valgrind \
    vim \
    zsh
#    docker.io
#    docker-compose
#    lldb
#    llvm
#    qemu-system-arm
RUN rm -rf /var/lib/apt/lists/*

## zsh-autosuggestions ##
#RUN mkdir -p ~/.zsh
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
RUN echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

## git-prompt and git-completion ##
RUN mkdir -p ~/.zsh
RUN curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh && \
    curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
    curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

## zsh-syntax-highlighting #$
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
RUN echo "source \${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

## zshrc ##
# git-prompt
RUN echo "source ~/.zsh/git-prompt.sh" >> ~/.zshrc

# git-completion
RUN echo "fpath=(~/.zsh $fpath)" >> ~/.zshrc
RUN echo "zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash" >> ~/.zshrc
RUN echo "autoload -Uz compinit && compinit" >> ~/.zshrc

# prompt
RUN echo "GIT_PS1_SHOWDIRTYSTATE=true" >> ~/.zshrc
RUN echo "GIT_PS1_SHOWUNTRACKEDFILES=true" >> ~/.zshrc
RUN echo "GIT_PS1_SHOWSTASHSTATE=true" >> ~/.zshrc
RUN echo "GIT_PS1_SHOWUPSTREAM=auto" >> ~/.zshrc
RUN echo "setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f\\n\$ '" >> ~/.zshrc
#RUN echo "export PS1=\"%n@%m: %~ \\n%# \"" >> ~/.zshrc

# alias
RUN echo "alias la=\"ls -la\"" >> ~/.zshrc
RUN echo "alias ll=\"ls -l\"" >> ~/.zshrc
RUN echo "alias gccw=\"gcc -Wall -Wextra -Werror\"" >> ~/.zshrc
RUN echo "alias ga='git add .'" >> ~/.zshrc
RUN echo "alias gap='git add p'" >> ~/.zshrc
RUN echo "alias gac='git add .; git commit -m'" >> ~/.zshrc
RUN echo "alias gcm='git commit -m'" >> ~/.zshrc
RUN echo "alias gcl='git clone'" >> ~/.zshrc
RUN echo "alias gs='git status'" >> ~/.zshrc
RUN echo "alias gfp='git fetch --prune'" >> ~/.zshrc
RUN echo "alias gp='git push'" >> ~/.zshrc
RUN echo "alias gba='git branch -a'" >> ~/.zshrc
RUN echo "alias gf='git fetch -v'" >> ~/.zshrc
RUN echo "alias gck='git checkout'" >> ~/.zshrc
RUN echo "alias gd='git diff'" >> ~/.zshrc
RUN echo "alias gl='git log'" >> ~/.zshrc
RUN echo "alias gbD='git branch -D'" >> ~/.zshrc


## vim ##
RUN mkdir -p ~/.vim/colors
RUN git clone https://github.com/w0ng/vim-hybrid ~/.vim/colors/vim-hybrid && \
    mv ~/.vim/colors/vim-hybrid/colors/hybrid.vim ~/.vim/colors

# vimrc
RUN echo "syntax on" >> ~/.vimrc
RUN echo "set number" >> ~/.vimrc
RUN echo "set background=dark" >> ~/.vimrc
RUN echo "set cursorline" >> ~/.vimrc
RUN echo "set cursorcolumn" >> ~/.vimrc
RUN echo "set mouse=a" >> ~/.vimrc
RUN echo "colorscheme hybrid" >> ~/.vimrc


## workdir ##
WORKDIR /home/webserv
COPY . /home/webserv

## cmd ##
CMD ["zsh"]