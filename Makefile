VERCMD  ?= git describe 2> /dev/null
VERSION := $(shell $(VERCMD) || cat VERSION)

CPPFLAGS += -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\"
CFLAGS   += -std=c99 -pedantic -Wall -Wextra
LDFLAGS  ?=
LDLIBS    = $(LDFLAGS) -lm -lxcb -lxcb-util -lxcb-keysyms -lxcb-icccm -lxcb-ewmh -lxcb-randr -lxcb-xinerama

PREFIX    ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin
MANPREFIX ?= $(PREFIX)/share/man
DOCPREFIX ?= $(PREFIX)/share/doc/bspwm
BASHCPL   ?= $(PREFIX)/share/bash-completion/completions
FISHCPL   ?= $(PREFIX)/share/fish/vendor_completions.d
ZSHCPL    ?= $(PREFIX)/share/zsh/site-functions

MD_DOCS    = README.md doc/CHANGELOG.md doc/CONTRIBUTING.md doc/INSTALL.md doc/MISC.md doc/TODO.md
XSESSIONS ?= $(PREFIX)/share/xsessions

WM_SRC   = bspwm.c helpers.c geometry.c jsmn.c settings.c monitor.c desktop.c tree.c stack.c history.c \
	 events.c pointer.c window.c messages.c parse.c query.c restore.c rule.c ewmh.c subscribe.c
WM_OBJ  := $(WM_SRC:.c=.o)
CLI_SRC  = bspc.c helpers.c
CLI_OBJ := $(CLI_SRC:.c=.o)

all: bspwm bspc

debug: CFLAGS += -O0 -g
debug: bspwm bspc

VPATH=src

include Sourcedeps

$(WM_OBJ) $(CLI_OBJ): Makefile

bspwm: $(WM_OBJ)

bspc: $(CLI_OBJ)

install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp  bspwm "$(DESTDIR)$(BINPREFIX)"
	cp  bspc "$(DESTDIR)$(BINPREFIX)"
	mkdir -p "$(DESTDIR)$(MANPREFIX)"/man1
	cp doc/bspwm.1 "$(DESTDIR)$(MANPREFIX)"/man1
	cp doc/bspc.1 "$(DESTDIR)$(MANPREFIX)"/man1
	mkdir -p "$(DESTDIR)$(BASHCPL)"
	cp contrib/bash_completion "$(DESTDIR)$(BASHCPL)"/bspc
	mkdir -p "$(DESTDIR)$(FISHCPL)"
	cp contrib/fish_completion "$(DESTDIR)$(FISHCPL)"/bspc.fish
	mkdir -p "$(DESTDIR)$(ZSHCPL)"
	cp contrib/zsh_completion "$(DESTDIR)$(ZSHCPL)"/_bspc
	mkdir -p "$(DESTDIR)$(DOCPREFIX)"
	cp $(MD_DOCS) "$(DESTDIR)$(DOCPREFIX)"
	mkdir -p "$(DESTDIR)$(DOCPREFIX)"/examples
	cp -r examples/* "$(DESTDIR)$(DOCPREFIX)"/examples
	mkdir -p "$(DESTDIR)$(XSESSIONS)"
	cp contrib/freedesktop/bspwm.desktop "$(DESTDIR)$(XSESSIONS)"

uninstall:
	rm -f "$(DESTDIR)$(BINPREFIX)"/bspwm
	rm -f "$(DESTDIR)$(BINPREFIX)"/bspc
	rm -f "$(DESTDIR)$(MANPREFIX)"/man1/bspwm.1
	rm -f "$(DESTDIR)$(MANPREFIX)"/man1/bspc.1
	rm -f "$(DESTDIR)$(BASHCPL)"/bspc
	rm -f "$(DESTDIR)$(FISHCPL)"/bspc.fish
	rm -f "$(DESTDIR)$(ZSHCPL)"/_bspc
	rm -rf "$(DESTDIR)$(DOCPREFIX)"
	rm -f "$(DESTDIR)$(XSESSIONS)"/bspwm.desktop

doc:
	a2x -v -d manpage -f manpage -a revnumber=$(VERSION) doc/bspwm.1.asciidoc

clean:
	rm -f $(WM_OBJ) $(CLI_OBJ) bspwm bspc

.PHONY: all debug install uninstall doc clean