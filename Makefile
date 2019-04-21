# Environment variables
# ------------------------------------------------------------------------------
# {{{

themedir := themedir
PDFTEX   := xelatex

# }}
#
# Files and dependencies
# ------------------------------------------------------------------------------
# {{{

themes    := corporate clean.code light.round light.square code.course
tex_files := $(patsubst %, %/src/example.tex, $(themes))
pdf_files := $(tex_files:%.tex=%.pdf)
png_files := $(patsubst %, %/screenshot-1.png, $(themes))

# }}
#
# Targets
# ------------------------------------------------------------------------------
# {{{

.PHONY: all clean

 all: $(png_files)

clean:
	@rm -vrf $(patsubst %, %/src/build, $(themes))
	@rm -vf $(pdf_files)
	@rm -vf $(patsubst %, %/*.png, $(themes))

# }}
#
# Rules
# ------------------------------------------------------------------------------
# {{{

$(png_files): %/screenshot-1.png: %/src/example.pdf | Makefile
	@echo "(COMPILE.png) $<"
	@pdftoppm $< screenshot -png
	@mv screenshot*.png $(dir $@)

$(pdf_files): %.pdf: %.tex
	@echo "(COMPILE.pdf) $<"
	@mkdir -p $(dir $<)/build
	@TEXINPUTS=themedir//:$$TEXINPUTS $(PDFTEX) -output-directory=$(dir $<)/build $< && \
	TEXINPUTS=themedir//:$$TEXINPUTS $(PDFTEX) -output-directory=$(dir $<)/build $<
	@mv -f $(dir $<)/build/$(notdir $@) $@

# }}
