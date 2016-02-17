clean:
	rm -rf data/
	rm -rf tools/*.zip

reduce:
	cd tools; python reduce_data.py

download:
	cd tools; ./download_all.sh

merge: 
	cd tools; ./merge.sh


all: download merge reduce
.PHONY: all