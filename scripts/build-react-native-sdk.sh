echo "Cleaning..."
rm -rf ./dist ./tmp

echo "Cloning tdwio/jitsi-react-native-sdk.git..."
mkdir -p tmp/source
git clone git@github.com:tdwio/jitsi-react-native-sdk.git tmp/source

echo "Building .js and .d.ts..."
tsc --project tsconfig.native.json
tsc --project tsconfig.web.json

echo "Installing original module..."
npm i --prefix ./tmp @jitsi/react-native-sdk
mv ./tmp/node_modules/@jitsi/react-native-sdk ./tmp/module

echo "Copying sources..."
rm -rf ./tmp/node_modules ./tmp/package.json ./tmp/package-lock.json
find ./tmp/module -name "*.ts" -type f -delete
find ./tmp/module -name "*.tsx" -type f -delete
rsync -am --ignore-existing ./dist/react/features ./tmp/module/react
cp -r ./dist/index.d.ts ./tmp/module/index.d.ts
cp -r ./dist/index.js ./tmp/module/index.js

echo "Copying sounds..."
rm -rf ./tmp/module/sounds
cp -r ./sounds ./tmp/module/sounds

echo "Cleaning up..."
rm -rf ./dist
mv ./tmp/module ./dist
mv ./tmp/source/.git ./dist/.git

echo "Updating package.json..."
TMP=$(mktemp)
jq '.main = "index.js"' ./dist/package.json > "$TMP" && mv "$TMP" ./dist/package.json
jq '.types = "index.d.ts"' ./dist/package.json > "$TMP" && mv "$TMP" ./dist/package.json
jq '.scripts = {}' ./dist/package.json > "$TMP" && mv "$TMP" ./dist/package.json