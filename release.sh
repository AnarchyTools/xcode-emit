if [ ! -f artifacts.zip ]; then
    echo "Missing artifacts.zip"
    exit 1
fi 
echo "version to tag:"
read version
#the OSX is in .atllbuild
rm -rf /tmp/build
mkdir -p /tmp/build/bin
unzip artifacts.zip -d /tmp/build/
cp /tmp/build/.atllbuild/products/xcode-emit /tmp/build/bin/xcode-emit
tar c -C /tmp/build bin | pixz -9 -o xcode-emit-${version}-macosx.tar.xz