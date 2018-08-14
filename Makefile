UNAME := $(shell uname)
HOMESHICK := "$(HOME)/.homesick/repos/homeshick/bin/homeshick"

all:
	echo "call 'make install' or 'make update'"

.PHONY: install update _up vimplugins vimproc fisher_deps \
	install_anyenv install_gom install_xcode_themes install_xcode_plugins install_scripts

install:
	$(HOMESHICK) link --verbose dotfiles
	make fisher_deps
	make vimplugins
	make _up
	clear

update:
	$(HOMESHICK) link --verbose dotfiles
	make vimproc
	vim -c ":NeoBundleUpdate"
	vim -c ":NeoBundleClean"
	bundle update
	make _up

_up: fisher_deps install_scripts

vimplugins:
	cd .vim/bundle && \
	rm -fr neobundle.vim && \
	rm -fr vimproc && \
	rm -fr neocomplcache && \
	git clone git://github.com/Shougo/neobundle.vim.git && \
	git clone git://github.com/Shougo/vimproc.git
	make vimproc
	vim -c ":NeoBundleInstall"

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

fisher_deps:
	curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
	fish -c 'fisher'

install_anyenv:
	git clone https://github.com/riywo/anyenv ~/.anyenv
	mkdir -p $(anyenv root)/plugins
	git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

install_pyenv_virtualenv:
	git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.anyenv/envs/pyenv/plugins/pyenv-virtualenv

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

install_homeshick:
	git clone https://github.com/andsens/homeshick.git $(HOME)/.homesick/repos/homeshick
