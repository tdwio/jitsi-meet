cd ./dist

VERSION=$(jq -r .version ./package.json)
echo "Pushing new tag $VERSION..."
git add -A
git commit -m "v$VERSION"
git tag $VERSION
git push && git push --tags