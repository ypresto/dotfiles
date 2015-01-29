UNAME := $(shell uname)

all:
	echo "call 'make install' or 'make update'"

.PHONY: install update _up vimproc skkdict perldict gitsubmodules completions cleanlinks \
	install_anyenv install_gom install_xcode_themes install_xcode_plugins install_scripts

install:
	./mksymlinks
	cd .vim/bundle && \
	rm -fr neobundle.vim && \
	rm -fr vimproc && \
	rm -fr neocomplcache && \
	git clone git://github.com/Shougo/neobundle.vim.git && \
	git clone git://github.com/Shougo/vimproc.git
	make vimproc
	vim -c ":NeoBundleInstall"
	npm install
	bundle install --binstubs --path vendor/bundle
	make _up
	clear

update:
	./mksymlinks
	make vimproc
	vim -c ":NeoBundleUpdate"
	vim -c ":NeoBundleClean"
	npm update
	bundle update
	make _up
	./mksymlinks

_up: skkdict perldict gitsubmodules completions install_scripts

vimproc:
# build automatically by NeoBundle when vimproc updated
ifeq ($(UNAME),Linux)
	cd .vim/bundle/vimproc && \
	make -fmake_unix.mak clean && \
	make -fmake_unix.mak
endif
ifeq ($(UNAME),Darwin)
	cd .vim/bundle/vimproc && \
	make -fmake_mac.mak clean && \
	make -fmake_mac.mak
endif

skkdict:
	cd .vim/dict && \
	wget --timestamping http://openlab.jp/skk/dic/SKK-JISYO.L.gz && \
	gzip -df SKK-JISYO.L.gz || \
	echo "ring project servers often downs..."

perldict:
	cd .vim/dict && \
	wget --timestamping https://raw.github.com/Cside/dotfiles/master/.vim/dict/perl.dict

gitsubmodules:
	git submodule sync
	git submodule update --init
	git submodule foreach 'git checkout master; git pull; git submodule sync; git submodule update --init'

completions:
	cd .zsh/functions && \
		curl -LkO https://raw.github.com/git/git/master/contrib/completion/git-completion.bash && \
		curl -Lko _git https://raw.github.com/git/git/master/contrib/completion/git-completion.zsh && \
		curl -Lko _hub https://raw.github.com/github/hub/master/etc/hub.zsh_completion && \
		curl -Lko _brew https://raw.github.com/mxcl/homebrew/master/Library/Contributions/brew_zsh_completion.zsh
	cd bashcomp && \
		curl -LkO https://raw.github.com/jonas/tig/master/contrib/tig-completion.bash

cleanlinks:
# below also works with BSD find
	find -L ~ -maxdepth 5 -type l 2>/dev/null | xargs -L5000 -I"{}" sh -c 'rm -i "{}" < /dev/tty'

install_anyenv:
	git clone https://github.com/riywo/anyenv ~/.anyenv

install_gom:
	mkdir -p ~/go
	go get github.com/mattn/gom

install_xcode_themes:
	cd ~/Library/Developer/Xcode/UserData && \
		git clone https://github.com/hdoria/xcode-themes.git FontAndColorThemes

install_xcode_plugins:
	curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh

install_scripts:
	curl -Lo bin/git-getpull https://github.com/RapGenius/git-getpull/raw/master/git-getpull && chmod +x bin/git-getpull
	curl -Lo bin/mergepbx https://github.com/simonwagner/mergepbx/releases/download/v0.6/mergepbx && chmod +x bin/mergepbx
