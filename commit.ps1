$def_msg = "Just another commit"
$commit_msg = if($commit_msg = (Read-Host "Commit message -Default: $def_msg]")){$commit_msg}else{$def_msg}
git add .
git commit -am "$commit_msg"
git push
