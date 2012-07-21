UNAME := $(shell uname)

all:
	echo "call 'make install' or 'make update'"

install:
	./mksymlinks
	cd .vim/bundle && \
	rm -fr neobundle.vim && \
	git clone git://github.com/Shougo/neobundle.vim.git
	vim -c ":NeoBundleInstall Shougo/vimproc | :NeoBundleInstall Shougo/neocomplcache | :NeoBundleInstall Shougo/unite.vim"
	clear
	make vimproc
	vim -c ":Unite -here neobundle/install"
	make _up
	clear

update:
	./mksymlinks
	make vimproc
	vim -c ":Unite -here neobundle/update"
	clear
	vim -c ":NeoBundleClean"
	clear
	make _up
	./mksymlinks

_up: skkdict perldict gitsubmodules bashcompl
	
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
	git submodule foreach 'git checkout master; git pull'

bashcompl:
	cd bash-completion && \
	wget --timestamping https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
