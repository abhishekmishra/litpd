.PHONY: all clean

PANDOC_CMD = lua ../litmd.lua 
PANDOC_OPTS = --to=html --standalone

TEST_FILES = $(wildcard *.md)

all: $(TEST_FILES:.md=.html)

%.html: %.md
	$(PANDOC_CMD) $< $(PANDOC_OPTS) -o $@

clean:
	rm -f *.html
	rm -f *.lua