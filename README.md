# bspwm-cygwin
Bspwm 0.9.5 compiled for Cygwin, under Windows 7 using gcc compiler version 7.3.0

Original Bspwm repository by baskerville:
https://github.com/baskerville/bspwm

Tested with 64-bit Cygwin version 2.10.0. 

**I made this repo to backup my compiled cygwin, this is not an official Cygwin package!**

## My adjustments ##
Makefile was modified, if you run Cygwin without administrator rights (for instance under corporate Windows) you might run into all sorts of errors for instance the Chmod is not working beceause the file owner groups are not default Windows groups. None of the workarounds I have found worked for me so I have completely removed the Chmod actions from the Makefile which makes it **much less secure!!**. I recommed compiling the bspwm from the source if you are able to.


**Here are some examples how to make chmod work, maybe it can work for you:**
https://stackoverflow.com/questions/17091972/chmod-cannot-change-group-permission-on-cygwin
http://alexeymk.com/permission-denied-for-chmod-cygwin-on-windows/

I don't use Cygwin for sensitive stuff so I don't mind it is more a testing environment for me. If Chmod works under your cygwin you can replace the Install part in the Makefile with the original:

`install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp -pf bspwm "$(DESTDIR)$(BINPREFIX)"
	cp -pf bspc "$(DESTDIR)$(BINPREFIX)"
	mkdir -p "$(DESTDIR)$(MANPREFIX)"/man1
	cp -p doc/bspwm.1 "$(DESTDIR)$(MANPREFIX)"/man1
	cp -Pp doc/bspc.1 "$(DESTDIR)$(MANPREFIX)"/man1
	mkdir -p "$(DESTDIR)$(BASHCPL)"
	cp -p contrib/bash_completion "$(DESTDIR)$(BASHCPL)"/bspc
	mkdir -p "$(DESTDIR)$(FISHCPL)"
	cp -p contrib/fish_completion "$(DESTDIR)$(FISHCPL)"/bspc.fish
	mkdir -p "$(DESTDIR)$(ZSHCPL)"
	cp -p contrib/zsh_completion "$(DESTDIR)$(ZSHCPL)"/_bspc
	mkdir -p "$(DESTDIR)$(DOCPREFIX)"
	cp -p $(MD_DOCS) "$(DESTDIR)$(DOCPREFIX)"
	mkdir -p "$(DESTDIR)$(DOCPREFIX)"/examples
	cp -pr examples/* "$(DESTDIR)$(DOCPREFIX)"/examples
	mkdir -p "$(DESTDIR)$(XSESSIONS)"
	cp -p contrib/freedesktop/bspwm.desktop "$(DESTDIR)$(XSESSIONS)"
  `
  
## Dependencies ##
You will need this libraries for bspwm to work, you can install them via Cygwin setup or via apt-cyg if you have it:
 - libxcb-util-devel
 - libxcb-keysms-devel
 - libxcb-iccm-devel
 - libxcb-ewmh-devel
 - libxcb-randr-devel
 - libxcb-xinerama-devel

**This is the line from Makefile:**
`LDLIBS    = $(LDFLAGS) -lm -lxcb -lxcb-util -lxcb-keysyms -lxcb-icccm -lxcb-ewmh -lxcb-randr -lxcb-xinerama`

In case you run into some issues, you can try to compile the bspwm by yourself from the original repository:
https://github.com/baskerville/bspwm

Feel free to ask me any questions, I will try to help you as much as I can.

## Other tips ##
I recommend using xterm instead of rxvt, I had problems with really bad sxhdk perfromance with rxvt. Xterm is nice and smooth. I was not able to find the cause.
  
