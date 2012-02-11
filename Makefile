all:
	echo "call 'make install' or 'make update'"

install:
	cd .vim/bundle && \
	rm -fr vundle && \
	git clone git://github.com/gmarik/vundle.git
	vim -c ":BundleInstall"
	make _up

update:
	vim -c ":BundleInstall!"
	vim -c ":BundleClean"
	make _up

_up: vimproc skkdict
	./mksymlinks
	
vimproc:
	cd .vim/bundle/vimproc && \
	make -fmake_gcc.mak

skkdict:
	cd .vim/dict && \
	wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && \
	gzip -df SKK-JISYO.L.gz
