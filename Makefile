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

manuscript: $(PDF_FILES)

$(PDF_DIR)/manuscript_latex_demo.pdf: $(PDF_DIR)/$(TEX_MASTER).tex $(DATA_OUT) $(FIG_FILES) $(PDF_DIR)/table_ICER_psa.tex
	(cd $(PDF_DIR); pdflatex $(TEX_MASTER);\
	bibtex $(TEX_MASTER); pdflatex $(TEX_MASTER);\
	pdflatex $(TEX_MASTER))

$(PDF_DIR)/table_ICER_psa.tex: $(SRC_DIR)/table_ICER_psa.R $(DATA_OUT)
	(cd $(SRC_DIR); R CMD BATCH $(<F))

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
