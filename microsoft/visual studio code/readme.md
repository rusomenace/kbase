If you want to delete the entire line make your regex find the entire line and include the linefeed as well. Something like:
```
^.*(word1|word2|word3).*\n?
```
Then ```ALT-Enter``` will select all lines that match and Delete will eliminate them including the lines they occupied.