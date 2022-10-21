$commit_msg = read-host "Commit message"
git add .
git commit -am "$commit_msg"
git push