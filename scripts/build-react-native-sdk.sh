echo "Cleaning ..."
rm -rf ./dist

echo "Building .js and .d.ts ..."
tsc --project tsconfig.native.json
tsc --project tsconfig.web.json

echo "Installing original module..."
rm -rf ./tmp
npm i --prefix ./tmp @jitsi/react-native-sdk
mv ./tmp/node_modules/@jitsi/react-native-sdk ./tmp/module

echo "Copying files..."
rm -rf ./tmp/node_modules ./tmp/package.json ./tmp/package-lock.json ./tmp/module/react/features ./tmp/module/index.tsx
mv ./dist/react/features ./tmp/module/react/features
mv ./dist/index.d.ts ./tmp/module/index.d.ts
mv ./dist/index.js ./tmp/module/index.js
rm -rf ./dist
mv ./tmp/module ./dist

echo "Preparing publish config..."
TMP=$(mktemp)
jq '.name = "@tdwio/jitsi-react-native-sdk"' ./dist/package.json > "$TMP" && mv "$TMP" ./dist/package.json
jq '.repository.url = "https://github.com/tdwio/jitsi-react-native-sdk"' ./dist/package.json > "$TMP" && mv "$TMP" ./dist/package.json
jq '.scripts = {}' ./dist/package.json > "$TMP" && mv "$TMP" ./dist/package.json
cp ./.npmrc ./dist/.npmrc