all:
	echo "call 'make install' or 'make update'"

install:
	./mksymlinks
	cd .vim/bundle && \
	rm -fr vundle && \
	git clone git://github.com/gmarik/vundle.git
	vim -c ":BundleInstall"
	make _up

update:
	vim -c ":BundleInstall!"
	vim -c ":BundleClean"
	make _up
	./mksymlinks

_up: vimproc skkdict
	
vimproc:
	cd .vim/bundle/vimproc && \
	make -fmake_unix.mak

skkdict:
	cd .vim/dict && \
	wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && \
	gzip -df SKK-JISYO.L.gz

perldict:
	cd .vim/dict && \
	wget https://raw.github.com/Cside/dotfiles/master/.vim/dict/perl.dict
