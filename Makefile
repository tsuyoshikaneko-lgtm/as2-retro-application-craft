RUNTIME ?= $(shell command -v docker 2>/dev/null || command -v podman 2>/dev/null)
MTASC_BUILDER_IMAGE ?= as2-retro-mtasc-builder:1.14
MTASC_PLATFORM ?= linux/amd64
SWF_SAMPLE ?= samples/boon-aa-threader
MTASC_BUILDER_DIR ?= operations/mtasc-builder
PORT ?= 8765
DIST_DIR ?= dist/boon-aa-threader
SITE_DIR ?= $(SWF_SAMPLE)/site
APP_SWF ?= boon-threader.swf
FONT_SWF ?= aa-font.swf

.PHONY: swf mtasc-builder-image mtasc-builder-shell check-container-runtime dist dist-demo dist-selfhosted clean-dist clean-swf serve

swf: mtasc-builder-image
	$(RUNTIME) run --rm --platform $(MTASC_PLATFORM) -v "$(CURDIR):/work" -w /work $(MTASC_BUILDER_IMAGE) make -C $(SWF_SAMPLE) -f mtasc/Makefile
	@test -f "$(SWF_SAMPLE)/$(APP_SWF)"
	@test -f "$(SWF_SAMPLE)/$(FONT_SWF)"

dist: dist-demo

dist-demo: swf
	mkdir -p "$(DIST_DIR)"
	cp "$(SWF_SAMPLE)/wrapper_cdn.html" "$(DIST_DIR)/index.html"
	cp "$(SWF_SAMPLE)/wrapper_config.js" "$(DIST_DIR)/wrapper_config.js"
	cp "$(SWF_SAMPLE)/$(APP_SWF)" "$(DIST_DIR)/$(APP_SWF)"
	cp "$(SWF_SAMPLE)/$(FONT_SWF)" "$(DIST_DIR)/$(FONT_SWF)"
	cp "$(SWF_SAMPLE)/OFL.txt" "$(DIST_DIR)/OFL.txt"
	@if [ -d "$(SITE_DIR)" ]; then cp -R "$(SITE_DIR)/." "$(DIST_DIR)/"; fi

dist-selfhosted: swf
	@test -f "$(SWF_SAMPLE)/ruffle/ruffle.js" || (echo "Place the Ruffle web package under $(SWF_SAMPLE)/ruffle/ before running make dist-selfhosted."; exit 1)
	mkdir -p "$(DIST_DIR)"
	cp "$(SWF_SAMPLE)/wrapper.html" "$(DIST_DIR)/index.html"
	cp "$(SWF_SAMPLE)/wrapper_config.js" "$(DIST_DIR)/wrapper_config.js"
	cp "$(SWF_SAMPLE)/$(APP_SWF)" "$(DIST_DIR)/$(APP_SWF)"
	cp "$(SWF_SAMPLE)/$(FONT_SWF)" "$(DIST_DIR)/$(FONT_SWF)"
	cp "$(SWF_SAMPLE)/OFL.txt" "$(DIST_DIR)/OFL.txt"
	cp -R "$(SWF_SAMPLE)/ruffle" "$(DIST_DIR)/ruffle"
	@if [ -d "$(SITE_DIR)" ]; then cp -R "$(SITE_DIR)/." "$(DIST_DIR)/"; fi

mtasc-builder-image: check-container-runtime
	$(RUNTIME) build --platform $(MTASC_PLATFORM) -t $(MTASC_BUILDER_IMAGE) $(MTASC_BUILDER_DIR)

mtasc-builder-shell: mtasc-builder-image
	$(RUNTIME) run --rm -it --platform $(MTASC_PLATFORM) -v "$(CURDIR):/work" -w /work $(MTASC_BUILDER_IMAGE) /bin/sh

check-container-runtime:
	@if [ -z "$(RUNTIME)" ]; then \
		echo "Docker or Podman is required for the isolated MTASC builder."; \
		echo "Install Docker Desktop or Podman, then run: make swf"; \
		exit 127; \
	fi

clean-swf:
	$(MAKE) -C $(SWF_SAMPLE) -f mtasc/Makefile clean

clean-dist:
	rm -rf dist

serve:
	python3 -m http.server $(PORT)
