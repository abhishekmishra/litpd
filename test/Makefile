.PHONY: all clean

TANGLE_FILTER = ../mdtangle.lua
PANDOC_CMD = pandoc --lua-filter=$(TANGLE_FILTER) --from=markdown --to=html --standalone

TEST_FILES = $(wildcard *.md)

all: $(TEST_FILES:.md=.html)

%.html: %.md
	$(PANDOC_CMD) $< -o $@

clean:
	rm -f *.html
	rm -f *.lua