##===========================================================================#
## Author: Guido España
## Gather all the data and generate figures & tables automatically

all: data figs manuscript

##==============================================================================#
## 1. First, collect the data 
##==============================================================================#
SRC_DIR = ./analysis/scripts
SRC_FILES := $(SRC_DIR)/run_data_ICER_puerto_rico.R
DATA_OUT := $(SRC_FILES:.R=.Rout)

data: $(DATA_OUT)
$(SRC_DIR)/%.Rout: $(SRC_DIR)/%.R
	(cd $(SRC_DIR); R CMD BATCH $(<F))

##==============================================================================#
## 2. Make the figures
##==============================================================================#
FIGS_DIR = ./analysis/figures
FIG_FILES :=  $(FIGS_DIR)/report_figure_ICER.jpeg \
	$(FIGS_DIR)/report_figure_tornado_diagram.jpeg

figs: $(FIG_FILES) 

$(FIGS_DIR)/report_figure_ICER.jpeg: $(SRC_DIR)/report_figure_ICER.R $(DATA_OUT)
	(cd $(SRC_DIR); R CMD BATCH $(<F))

$(FIGS_DIR)/report_figure_tornado_diagram.jpeg: $(SRC_DIR)/report_figure_tornado_diagram.py $(DATA_OUT)
	(cd $(SRC_DIR); python3 $(<F))

##==============================================================================#
## 3. Manuscript
##==============================================================================#
PDF_DIR = ./manuscript
TEX_MASTER := manuscript_latex_demo
PDF_FILES := $(PDF_DIR)/$(TEX_MASTER).pdf
DOC_REF := demo_template.docx
BIB_FILE := Guido_Postdoc_Literature.bib
MASTER_BIB := ~/Dropbox/Literature/Guido_Postdoc_Literature.bib
PANDOC_FLAGS := --filter pandoc-citeproc --csl ~/Dropbox/Literature/style_files/plos-computational-biology.csl	--reference-doc $(DOC_REF) --mathml --bibliography=$(BIB_FILE)

manuscript: $(PDF_FILES) $(PDF_DIR)/$(TEX_MASTER).docx

$(PDF_DIR)/manuscript_latex_demo.pdf: $(PDF_DIR)/$(TEX_MASTER).tex $(DATA_OUT) $(FIG_FILES) $(PDF_DIR)/table_ICER_psa.tex $(PDF_DIR)/$(BIB_FILE)
	(cd $(PDF_DIR); pdflatex $(TEX_MASTER);\
	bibtex $(TEX_MASTER); pdflatex $(TEX_MASTER);\
	pdflatex $(TEX_MASTER))

$(PDF_DIR)/table_ICER_psa.tex: $(SRC_DIR)/table_ICER_psa.R $(DATA_OUT)
	(cd $(SRC_DIR); R CMD BATCH $(<F))

$(PDF_DIR)/$(TEX_MASTER).docx: $(PDF_DIR)/$(TEX_MASTER).tex $(PDF_DIR)/$(TEX_MASTER).pdf
	(cd $(PDF_DIR); pandoc $(<F) -o $(@F) $(PANDOC_FLAGS))

## Always copy the master bib file
$(PDF_DIR)/$(BIB_FILE): $(MASTER_BIB)
	(cp $(MASTER_BIB) $(PDF_DIR)/$(BIB_FILE))

##==============================================================================#
## Clean stuff
##==============================================================================#
clean:
	rm -fv $(DATA_OUT); rm -fv $(FIG_FILES); rm -fv $(PDF_FILES)
cleanData:
	rm -fv $(DATA_OUT)

cleanFigs:
	rm -fv $(FIG_FILES)

cleanTex:
	rm -fv $(PDF_FILES)

cleanJunk:
	(cd $(PDF_DIR); rm -fv *.log; rm -fv *.out; rm -fv *.blg; rm -rfv _region_.*; rm -fv *.aux; rm -rfv auto)
