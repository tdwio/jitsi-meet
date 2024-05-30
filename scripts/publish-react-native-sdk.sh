cd ./dist

VERSION=$(jq -r .version ./package.json)
echo "Publishing version $VERSION..."
npm publish

echo "Pushing new tag v$VERSION..."
git tag v$VERSION
git push && git push --tags