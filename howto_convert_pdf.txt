
PDF to JPEG

for file in *.pdf; do \
echo $file;\
convert -density 900x900 -resize 150% -quality 100 $file `echo $file|cut -f1 -d'.'`.jpeg;\
done



PDF to TIFF

for file in *.pdf; do \
echo $file;\
convert -density 300 -resize 1200x1200 -quality 90 $file `echo $file|cut -f1 -d'.'`.tiff;\
done



## ------------------------------------------------------------------------

PDF to EPS

pdfcrop "figure_1_a_AF_epi.pdf" "figure_1_a_AF_epi-temp.pdf"
pdftops -f figure_1_a_AF_epi -l figure_1_a_AF_epi -eps "figure_1_a_AF_epi-temp.pdf" "figure_1_a_AF_epi.eps"
rm  "figure_1_a_AF_epi-temp.pdf"

inkscape *.pdf --export-eps=*.eps

for file in *.pdf; do \
echo $file;\
inkscape $file --export-dpi=300 --export-eps=`echo $file|cut -f1 -d'.'`.eps;\
done

for file in figure_2_right_*.pdf; do \
echo $file;\
inkscape $file --export-eps=`echo $file|cut -f1 -d'.'`.eps;\
done

for file in figure_2_right_*.pdf; do \
echo $file;\
inkscape $file --export-dpi=300 --export-eps=`echo $file|cut -f1 -d'.'`2.pdf;\
done



for file in *.pdf; do \
echo $file;\
convert -density 300 -quality 90 $file `echo $file|cut -f1 -d'.'`.tiff;\
done

