
# Command line tools snippets


## Servers

### `nice`

`nice -n 10 bin/Rscript foo.R`


### Use `screen` on server

```
screen -ls 		 		 ## List available sessions
screen -S MySessionName  ## Create session with specific name + connecting
ctrl+A+D   		  		 ## log out from session
screen -r MySessionName  ## Connecting to session
kill -9 MySessionName    ## want to kill session
```

From [here](http://fractio.nl/2008/09/29/setting-session-name-in-screen/).

### Vim

- `ctrl+o` to exit the insert mode
- `shift+q` to enter the exit mode
- then `q!+enter` to quit without saving
- or `wq+enter` to save and quit 

### `rsync`

`nice -n20 ionice -c 3 rsync -avz ...`


## Tidying up

### delete all DS store files

`find . -name '*.DS_Store' -type f -delete`

### Find and remove tilde files

- Find tilde files: `find ./ -name '*~' -print`
- Remove tilde files: `find ./ -name '*~' -exec rm '{}' \; -print`
- Remove tilde files II: `find ./ -name '*~' -exec rm '{}' \; -print -or -name ".*~" -exec rm {} \; -print`


### Replace filename pattern

`for f in `find . -name '*replaceme.jpg'` ; do mv $f ${f/replaceme/withme}; done`

### search for a word

grep -R "\paragraph" *


### *.wmf > *.pdf

`for i in *.wmf ; do convert "${i%%.*}".wmf "${i%%.*}".pdf ; done`


## Images

### cropping images

`pdfcrop --margins "-10 -20 -50 -10" --clip old.pdf new.pdf`


### imagemagick

`convert -density 300 -depth 8 -quality 85 plot.pdf plot.png`


### concatenate pdfs together

- `convert file1.pdf file2.pdf file3.pdf out.pdf`
- `pdftk file1.pdf file2.pdf file3.pdf cat output out.pdf`


### Remove 2nd column

`cut -c -1,3- text.txt`


### create softlink

`ln -rs tmp/alignments results/alignments/original`

`ln -rs tmp/variants/ results/original`
