.PHONY: all clean test luaenv

PANDOC_CMD = lua ./bootstrap/litpd.lua 
PANDOC_OPTS_HTML = --to=html --standalone --toc
PANDOC_OPTS_PDF = --to=pdf --standalone --toc

BUILD_DIR = dist

all: $(BUILD_DIR) $(BUILD_DIR)/litpd.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# TODO: since the lua files are currently generated in the current folder,
# we need to move them to the build folder. This should not be necessary.

$(BUILD_DIR)/%.html: %.md
	$(PANDOC_CMD) $< $(PANDOC_OPTS_HTML) -o $@
	mv litpd.lua $(BUILD_DIR)/
	mv mdtangle.lua $(BUILD_DIR)/
	mv codeidextract.lua $(BUILD_DIR)/
	cp HLDDiagram.png $(BUILD_DIR)/

$(BUILD_DIR)/%.pdf: %.md
	$(PANDOC_CMD) $< $(PANDOC_OPTS_PDF) -o $@
	mv litpd.lua $(BUILD_DIR)/
	mv mdtangle.lua $(BUILD_DIR)/
	mv codeidextract.lua $(BUILD_DIR)/

test:
	lua run_tests.lua

luaenv:
	@echo "Setting up luaenv... "
	@echo "IMPORTANT: RUN this from x64 Native Tools Command Prompt for VS"
	hererocks .luaenv --lua 5.4 --luarocks latest
	powershell ".luaenv/bin/activate.ps1 ; luarocks install busted"

clean:
	rm -f $(BUILD_DIR)/*.html
	rm -f $(BUILD_DIR)/*.pdf
	rm -f $(BUILD_DIR)/*.lua