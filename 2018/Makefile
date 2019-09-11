auto:
	ls * | entr -c -s "file=\$$(ls *.rb | tail -1); name=\"\$${file%.*}\"; cat \$$name.txt | ruby \$$name.rb"

sample:
	ls * | entr -c -s "file=\$$(ls *.rb | tail -1); name=\"\$${file%.*}\"; cat \$$name.sample.txt | ruby \$$name.rb"
