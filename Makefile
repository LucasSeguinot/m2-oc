.PHONY: all run clean mrproper doc depend

##############################
#       Configuration        #
##############################

# Folders
SRC = src
BIN = .
DOC = doc

# Modules
TARGET_MODULE = main
ML_MODULES = job schedule
CMA_MODULES = str

##############################
#    End of configuration    #
##############################

TARGET_MODULE_FULL = $(TARGET_MODULE:%=$(SRC)/%)
TARGET     = $(TARGET_MODULE:%=$(BIN)/%$(EXE))
TARGET_ML  = $(TARGET_MODULE_FULL:%=%.ml)
TARGET_CMO = $(TARGET_MODULE_FULL:%=%.cmo)
TARGET_CMX = $(TARGET_MODULE_FULL:%=%.cmx)

ML_MODULES_FULL = $(ML_MODULES:%=$(SRC)/%)
ML_FILES  = $(ML_MODULES_FULL:%=%.ml)

MODULES_MLI_FILES = $(ML_MODULES_FULL:%=%.mli)
EXISTING_MLI_FILES = $(wildcard $(SRC)/*.mli)
MLI_FILES = $(filter $(MODULES_MLI_FILES), $(EXISTING_MLI_FILES)) # Intersection

MLSRC = $(MLI_FILES) $(ML_FILES) $(TARGET_ML)

CMI_FILES = $(MLI_FILES:%.mli=%.cmi)
CMO_FILES = $(ML_MODULES_FULL:%=%.cmo) $(TARGET_CMO)
CMX_FILES = $(ML_MODULES_FULL:%=%.cmx) $(TARGET_CMX)

CMA_FILES = $(CMA_MODULES:%=%.cma)
CMXA_FILES = $(CMA_MODULES:%=%.cmxa)

INCLUDE	= -I $(SRC)

CAMLC   = ocamlfind ocamlc $(INCLUDE) $(PACKAGES_CMD) -linkpkg
CAMLOPT = ocamlfind ocamlopt $(INCLUDE) $(PACKAGES_CMD) -linkpkg
CAMLDEP = ocamldep $(INCLUDE)
CAMLDOC = ocamldoc $(INCLUDE)

all: Makefile.depend $(TARGET)

$(TARGET): $(CMX_FILES)
	mkdir -p $(BIN)
	$(CAMLOPT) -o $@ $(CMXA_FILES) $(CMX_FILES)

$(CMI_FILES): %.cmi: %.mli
	$(CAMLC) -c $<

$(CMO_FILES): %.cmo: %.ml
	$(CAMLC) -c $(CMA_FILES) $<

$(CMX_FILES): %.cmx: %.ml
	$(CAMLOPT) -c $(CMXA_FILES) $<

run: $(TARGET)
	$(TARGET)

clean:
	rm -rf $(SRC)/*.cm[oix] $(SRC)/*.o
	rm -rf Makefile.depend

mrproper: clean
	-rm -rf $(BIN)
	-rm -rf $(DOC)

doc: $(MLI_FILES) $(CMI_FILES)
	mkdir -p $(DOC)
	$(CAMLDOC) -html -d $(DOC) $(MLI_FILES)

Makefile.depend: $(MLI_FILES) $(ML_FILES)
	$(CAMLDEP) $(MLI_FILES) $(ML_FILES) > Makefile.depend

depend: Makefile.depend

include Makefile.depend
