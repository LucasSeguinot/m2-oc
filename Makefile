.PHONY: all clean mrproper doc depend

##############################
#       Configuration        #
##############################

# Folders
SRC = src
BIN = .
DOC = doc

# Modules
TARGET_MODULES = tp1 tp2
ML_MODULES = util job schedule heuristics neighborhood selection localSearch
CMA_MODULES = str

##############################
#    End of configuration    #
##############################

TARGET_MODULES_FULL = $(TARGET_MODULES:%=$(SRC)/%)
TARGET     = $(TARGET_MODULES:%=$(BIN)/%)
TARGET_ML  = $(TARGET_MODULES_FULL:%=%.ml)
TARGET_CMO = $(TARGET_MODULES_FULL:%=%.cmo)
TARGET_CMX = $(TARGET_MODULES_FULL:%=%.cmx)

ML_MODULES_FULL = $(ML_MODULES:%=$(SRC)/%)
ML_FILES  = $(ML_MODULES_FULL:%=%.ml)

MODULES_MLI_FILES = $(ML_MODULES_FULL:%=%.mli)
EXISTING_MLI_FILES = $(wildcard $(SRC)/*.mli)
MLI_FILES = $(filter $(MODULES_MLI_FILES), $(EXISTING_MLI_FILES)) # Intersection

MLSRC = $(MLI_FILES) $(ML_FILES) $(TARGET_ML)

CMI_FILES = $(MLI_FILES:%.mli=%.cmi)
CMO_FILES = $(ML_MODULES_FULL:%=%.cmo) $(TARGET_CMO)
CMX_FILES = $(ML_MODULES_FULL:%=%.cmx)

CMA_FILES = $(CMA_MODULES:%=%.cma)
CMXA_FILES = $(CMA_MODULES:%=%.cmxa)

INCLUDE	= -I $(SRC)

CAMLC   = ocamlfind ocamlc $(INCLUDE) $(PACKAGES_CMD) -linkpkg
CAMLOPT = ocamlfind ocamlopt $(INCLUDE) $(PACKAGES_CMD) -linkpkg
CAMLDEP = ocamldep $(INCLUDE)
CAMLDOC = ocamldoc $(INCLUDE)

all: Makefile.depend $(TARGET)

$(TARGET): $(BIN)/%: $(CMX_FILES) $(SRC)/%.cmx
	mkdir -p $(BIN)
	$(CAMLOPT) -o $@ $(CMXA_FILES) $^

$(CMI_FILES): %.cmi: %.mli
	$(CAMLC) -c $<

$(CMO_FILES): %.cmo: %.ml
	$(CAMLC) -c $(CMA_FILES) $<

$(CMX_FILES) $(TARGET_CMX): %.cmx: %.ml
	$(CAMLOPT) -c $(CMXA_FILES) $<

clean:
	find $(SRC) -name *.cmi -delete
	find $(SRC) -name *.cmo -delete
	find $(SRC) -name *.cmx -delete
	find $(SRC) -name *.o -delete
	rm -f Makefile.depend

mrproper: clean
	-rm -f $(TARGET)
	-rm -rf $(DOC)

doc: $(MLI_FILES) $(CMI_FILES)
	mkdir -p $(DOC)
	$(CAMLDOC) -html -d $(DOC) $(MLI_FILES)

Makefile.depend: $(MLI_FILES) $(ML_FILES)
	$(CAMLDEP) $(MLI_FILES) $(ML_FILES) > Makefile.depend

depend: Makefile.depend

include Makefile.depend
