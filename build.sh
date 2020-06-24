SDKURL=$1;
TARGET_FOLDER=$2;
echo "sdkURL: ${SDKURL} targetFolder:${TARGET_FOLDER}";
echo "building ipk ..."

docker build --build-arg sdkURL=${SDKURL} --build-arg targetFolder=${TARGET_FOLDER} . -t htynkn/openwrt-switch-lan-play-${TARGET_FOLDER}:latest
rm -f target-${TARGET_FOLDER}.zip
docker run -v $PWD:/opt/mount --rm --entrypoint cp htynkn/openwrt-switch-lan-play-${TARGET_FOLDER}:latest /sdk/openwrt-sdk/target.zip /opt/mount/target-${TARGET_FOLDER}.zip