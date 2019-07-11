# LaTeX Demo for reproducible research presentation

This is a demo file. The directory tree is:
```
latex_demo-o- README.md
           |- manuscript
           |- pandoc
           |- analysis
                    |- data
                    |- output
                    |- figures
                    |- scripts
```
Scripts should be run within the scripts directory, not outside of it...for some reason

# Tie up all files with a Makefile
The Makefile in this repository gathers data, creates figures, and compiles the LaTeX document. 


# Pandoc filters
Use the pandoc filters in the pandoc directory to get the numbering of figures, equations, and tables. The filters only work if the labels are declared inside the caption (I plan to fix that at some point),  e.g., `\caption{\label{figA} This is Figure A}`. If the labels are not declared in that way, the filter will break, so would be better not to use it in that case. 

