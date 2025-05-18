.PHONY: all clean test luaenv docs dist

VERSION = v0_1_0-alpha_1

PANDOC_CMD = lua ./bootstrap/litpd.lua
PANDOC_OPTS_HTML = --to=html --standalone --toc
PANDOC_OPTS_PDF = --to=pdf --standalone --toc
#
# see https://gist.github.com/sighingnow/deee806603ec9274fd47
# for details on the following snippet to get the OS
# (removed the flags about arch as it is not needed for now)
OSFLAG :=
ifeq ($(OS),Windows_NT)
	OSFLAG = WIN32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OSFLAG = LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
		OSFLAG = OSX
	endif
endif

BUILD_DIR = build

DIST_DIR = dist

DOCS_DIR = docs

all: $(BUILD_DIR) $(BUILD_DIR)/litpd.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# TODO: since the lua files are currently generated in the current folder,
# we need to move them to the build folder. This should not be necessary.

$(BUILD_DIR)/%.html: %.md
ifeq ($(OSFLAG),WIN32)
	pwsh -Command ".luaenv/bin/activate.ps1 ; $(PANDOC_CMD) $< $(PANDOC_OPTS_HTML) -o $@"
else
	bash -c "source .luaenv/bin/activate; $(PANDOC_CMD) $< $(PANDOC_OPTS_HTML) -o $@"
endif
	mv litpd.lua $(BUILD_DIR)/
	mv mdtangle.lua $(BUILD_DIR)/
	mv codeidextract.lua $(BUILD_DIR)/
	cp HLDDiagram.png $(BUILD_DIR)/
	cp litpd.ps1 $(BUILD_DIR)/

$(BUILD_DIR)/%.pdf: %.md
	$(PANDOC_CMD) $< $(PANDOC_OPTS_PDF) -o $@
	mv litpd.lua $(BUILD_DIR)/
	mv mdtangle.lua $(BUILD_DIR)/
	mv codeidextract.lua $(BUILD_DIR)/

test:
ifeq ($(OSFLAG),WIN32)
	pwsh -Command ".luaenv/bin/activate.ps1 ; lua run_tests.lua"
else
	bash -c "source .luaenv/bin/activate ; lua run_tests.lua"
endif

luaenv:
	@echo "Setting up luaenv... "
	@echo "IMPORTANT: RUN this from x64 Native Tools Command Prompt for VS"
	hererocks .luaenv --lua 5.4 --luarocks latest
ifeq ($(OSFLAG),WIN32)
	pwsh -Command ".luaenv/bin/activate.ps1 ; luarocks install busted"
else
	bash -c "source .luaenv/bin/activate; luarocks install busted"
endif

docs:
# copy litpd.html to docs folder
	mkdir -p $(DOCS_DIR)
	cp $(BUILD_DIR)/litpd.html $(DOCS_DIR)/index.html

dist: all
# zip the contents of the dist directory
# and call it litpd-<version>.zip
# where <version> is the value of VERSION
	cd $(BUILD_DIR) && \
	zip -r ../$(DIST_DIR)/litpd-$(VERSION).zip * && \
	cd ..

clean:
	rm -f $(BUILD_DIR)/*.html
	rm -f $(BUILD_DIR)/*.pdf
	rm -f $(BUILD_DIR)/*.lua
	rm -f $(BUILD_DIR)/*.ps1
