echo "Generating website"
cd tools && go run . && cd ..

echo 'Delete existing file'
rm -rf openwrt

echo 'Using new website'
mv tools/website openwrt

echo 'Update index'
python make_index.py openwrt
