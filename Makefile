UNAME := $(shell uname)

all:
	echo "call 'make install' or 'make update'"

install:
	./mksymlinks
	cd .vim/bundle && \
	rm -fr neobundle.vim && \
	git clone git://github.com/Shougo/neobundle.vim.git
	vim -c ":NeoBundleInstall"
	make _up

update:
	./mksymlinks
	vim -c ":NeoBundleInstall!"
	vim -c ":NeoBundleClean"
	make _up
	./mksymlinks

_up: vimproc skkdict perldict gitsubmodules
	
vimproc:
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
	wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && \
	gzip -df SKK-JISYO.L.gz

perldict:
	cd .vim/dict && \
	wget https://raw.github.com/Cside/dotfiles/master/.vim/dict/perl.dict

gitsubmodules:
	git submodule sync
	git submodule update --init
	git submodule foreach 'git checkout master; git pull'
