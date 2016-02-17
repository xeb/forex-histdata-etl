
all:
	cd tools; ./download_all.sh
	cd tools; ./merge.sh

.PHONY: all