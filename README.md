# how/to/s & cheatsheets

Scripts that serve to look up stuff that I always forget.

* Old and new snippets
* Templates for latex
* useR 2011 notes

## Server related
```
qstat -f -u '*'
```
```
ps -aux | grep srueger
```

## Backups
### HPC1 2 HPC1
```
rsync -avr /data/sgg/sina/projects/ /chuvdatarc/srueger/SGG/COMMUN/Sina/backups/
rsync -avr /data/sgg/sina/teaching/ /chuvdatarc/srueger/SGG/COMMUN/Sina/backups/
```

### Laptop 2 HPC1
```
scp -r /Users/admin/Documents/Work/Projects/tagging/documentation/document_article/* srueger@hpc1.chuv.ch:/data/sgg/sina/backup.article
```
```
scp -r  /Users/admin/Documents/Studies/Reports/final-thesis/* srueger@hpc1.chuv.ch:/data/sgg/sina/backup.thesis
```

### macbook 2 harddisk
>> MANUEL!

>> old was this one:
```
scp -r /Users/admin/Documents/* sina@neve.unil.ch:/h-sara0/sina/backup_mac/
```
