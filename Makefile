.PHONY: all clean test docs dist

VERSION = 0.3.1-beta.0

PANDOC_CMD = pandoc --lua-filter=./bootstrap/litpd_filter.lua --from=markdown
PANDOC_OPTS_HTML = --to=html --standalone --toc --css=litpd.css
PANDOC_OPTS_PDF = --to=pdf --standalone --toc
#
# see https://gist.github.com/sighingnow/deee806603ec9274fd47
# for details on the following snippet to get the OS
# (removed the flags about arch as it is not needed for now)
OSFLAG :=
ifeq ($(OS),Windows_NT)
	OSFLAG = WIN32
	PYTHON ?= py
else
	PYTHON ?= python3
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

RELEASE_FILES = litpd.py litpd_filter.lua litpd.html litpd.css HLDDiagram.png helloworld.md

all: $(BUILD_DIR)/litpd.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.html: %.md litpd.css bootstrap/litpd_filter.lua | $(BUILD_DIR)
	$(PANDOC_CMD) $< $(PANDOC_OPTS_HTML) -o $@
	mv litpd.py $(BUILD_DIR)/
	mv litpd_filter.lua $(BUILD_DIR)/
	cp HLDDiagram.png $(BUILD_DIR)/
	cp litpd.css $(BUILD_DIR)/
	cp helloworld.md $(BUILD_DIR)/

$(BUILD_DIR)/%.pdf: %.md bootstrap/litpd_filter.lua | $(BUILD_DIR)
	$(PANDOC_CMD) $< $(PANDOC_OPTS_PDF) -o $@
	mv litpd.py $(BUILD_DIR)/
	mv litpd_filter.lua $(BUILD_DIR)/

test: all
	$(PYTHON) -m unittest discover -s test -p "test_*.py" -v

docs: all
# copy litpd.html to docs folder
	mkdir -p $(DOCS_DIR)
	cp $(BUILD_DIR)/litpd.html $(DOCS_DIR)/index.html
	cp $(BUILD_DIR)/litpd.css $(DOCS_DIR)/litpd.css

dist: all
	mkdir -p $(DIST_DIR)
ifeq ($(OSFLAG),WIN32)
# Create the Windows release zip.
	cd $(BUILD_DIR) && \
	zip -r ../$(DIST_DIR)/litpd.zip $(RELEASE_FILES) && \
	cd ..
else
# Create the Unix release tarball.
	cd $(BUILD_DIR) && \
	tar -czf ../$(DIST_DIR)/litpd.tar.gz $(RELEASE_FILES) && \
	cd ..
endif

clean:
	rm -rf $(BUILD_DIR)/__pycache__
	rm -f $(BUILD_DIR)/* $(DIST_DIR)/*
