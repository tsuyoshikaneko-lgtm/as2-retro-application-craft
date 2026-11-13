OUT=boon-threader.swf
FONT_OUT=aa-font.swf
SRC=mtasc/src/BoonThreader.as
FRAME_SCRIPTS=frame_scripts.as
FONT_BUILDER=../../operations/as2-swf-debug-pipeline/scripts/build-ruffle-font-swf
FONT_SOURCES=$(SRC) $(FRAME_SCRIPTS)

.PHONY: all clean

all: $(OUT) $(FONT_OUT)

$(OUT): $(SRC)
	mtasc -cp mtasc/src -main -swf $(OUT) -header 390:640:30:ffffff -version 8 $(SRC)

$(FONT_OUT): $(FONT_BUILDER) $(FONT_SOURCES)
	$(FONT_BUILDER) $(FONT_OUT) $(FONT_SOURCES)

clean:
	rm -f $(OUT) $(FONT_OUT)
