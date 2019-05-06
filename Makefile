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

themes    := corporate clean.code light.theme code.course
tex_files := $(patsubst %, %/src/example.tex, $(themes))
pdf_files := $(tex_files:%.tex=%.pdf)
png_files := $(patsubst %, %/screenshot-1.png, $(themes))

# }}
#
# Targets
# ------------------------------------------------------------------------------
# {{{

.PHONY: all
all: $(png_files)

.PHONY: clean
clean: \
	clean-corporate \
  clean-clean.code \
  clean-light.theme \
  clean-code.course

.PHONY: clean-corporate
clean-corporate:
	$(call clean-folder, corporate)

.PHONY: clean-clean.code
clean-clean.code:
	$(call clean-folder, clean.code)

.PHONY: clean-light.theme
clean-light.theme:
	$(call clean-folder, light.theme)

.PHONY: clean-code.course
clean-code.course:
	$(call clean-folder, code.course)

define clean-folder
	@rm -vrf $1/src/build
	@rm -vf $1/src/example.pdf
	@rm -vf $1/*.png
endef

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
