git tag -d v1.0.0 // delete
git tag v1.0.0
git push origin :refs/tags/v1.0.0
git push origin v1.0.0

Verify

git tag
git show v1.0.0
