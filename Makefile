clean:
	rm -rf data/
	rm -rf tools/*.zip

download:
	cd tools; ./download_all.sh

merge: 
	cd tools; ./merge.sh

convert:
	cd tools; python convert_data.py

all: download merge reduce
.PHONY: all