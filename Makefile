all:
	echo "call 'make install' or 'make update'"

install:
	cd .vim/bundle && \
	rm -fr vundle && \
	git clone git://github.com/gmarik/vundle.git
	vim -c ":BundleInstall"
	make vimproc
	./mksymlinks

update:
	vim -c ":BundleInstall!"
	vim -c ":BundleClean"
	make vimproc
	./mksymlinks

vimproc:
	cd .vim/bundle/vimproc && \
	make -fmake_gcc.mak
