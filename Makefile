.PHONY: all clean mrproper doc depend

##############################
#       Configuration        #
##############################

# Programs to be built. No need to list dependent
# modules in the same directory, or sub directories.
PROGRAMS=tp1 tp2 tp3

# OCaml build tool.
BUILDER=ocamlbuild

# OCaml libraries outside of the stdlib.
LIBS=str,unix

# $(DOCFILE).odocl must exist in $(SRCDIR) and
# contain a list of module names (not file names)
# to be documented.
DOCFILE=oc

# Where everything is stored
SRCDIR=src
DOCDIR=docs
BUILDDIR=build

# Path separator for the current platform.
# Uncomment the next line for Windows platforms.
#/ := $(strip \)
# Uncomment the next line for UNIX platforms.
/=/

##############################
#    End of configuration    #
##############################

# Paths of the programs built by ocamlbuild
NATIVE_PROGRAMS = $(PROGRAMS:%=$(SRCDIR)$/%.native)
BYTE_PROGRAMS = $(PROGRAMS:%=$(SRCDIR)$/%.byte)

# Paths of the symlinks to these programs
NATIVE_SYMLINKS = $(PROGRAMS)
BYTE_SYMLINKS = $(PROGRAMS:%=%.byte)

all: docs $(BYTE_SYMLINKS) $(NATIVE_SYMLINKS)

docs:
	$(BUILDER) $(SRCDIR)$/$(DOCFILE).docdir/index.html -I $(SRCDIR) -build-dir $(BUILDDIR)
	ln -sf $(BUILDDIR)$/$(SRCDIR)$/$(DOCFILE).docdir $(DOCDIR)

byte:
	$(BUILDER).byte $(BYTE_PROGRAMS) -libs $(LIBS) -build-dir $(BUILDDIR)

native:
	$(BUILDER).native $(NATIVE_PROGRAMS) -libs $(LIBS) -build-dir $(BUILDDIR)

$(NATIVE_SYMLINKS): %: native
	ln -sf $(BUILDDIR)$/$(SRCDIR)$/$*.native $*

$(BYTE_SYMLINKS): %: byte
	ln -sf $(BUILDDIR)$/$(SRCDIR)$/$* $*

clean:
	$(BUILDER) -clean -build-dir $(BUILDDIR)
	rm -f $(NATIVE_SYMLINKS) $(BYTE_SYMLINKS) $(DOCDIR)
