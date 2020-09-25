echo "Generating website"
cd tools && go run . && cd ..

echo 'Delete existing file'
rm -rf openwrt

echo 'Using new website'
mv tools/website openwrt
find . |grep Packages |grep -v ".gz" | xargs gzip --keep

echo 'Update index'
python make_index.py openwrt