# how/to/s and cheatsheets
Old and new snippets

<<<<<<< HEAD
useR 2011 notes


Templates, code snippets, howto's

* bash
* PDF converter
	* pdf2tiff
	* pdf2jpeg
* screen
* vim
* printer
* hpc
```
qstat -f -u '*'
```
```
ps -aux | grep srueger
```
* R 
>> are in cookbook-r
* Latex templates

* backup
** HPC1 2 HPC1
```
rsync -avr /data/sgg/sina/projects/ /chuvdatarc/srueger/SGG/COMMUN/Sina/backups/
rsync -avr /data/sgg/sina/teaching/ /chuvdatarc/srueger/SGG/COMMUN/Sina/backups/
```

** Laptop 2 HPC1
```
scp -r /Users/admin/Documents/Work/Projects/tagging/documentation/document_article/* srueger@hpc1.chuv.ch:/data/sgg/sina/backup.article
```
```
scp -r  /Users/admin/Documents/Studies/Reports/final-thesis/* srueger@hpc1.chuv.ch:/data/sgg/sina/backup.thesis
```

** macbook 2 harddisk
>> MANUEL!

>> old was this one:
```
scp -r /Users/admin/Documents/* sina@neve.unil.ch:/h-sara0/sina/backup_mac/
```

=======
bash stuff

useR 2011 notes
>>>>>>> c33fc8ae88cddec0120413223c4372581398f45e
