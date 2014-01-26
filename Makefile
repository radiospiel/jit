.PHONY: test doc
	
test:
	roundup test/*-test.sh

doc:
	which -s ronn || (echo "Please install ronn: gem install ronn" && false)
	ronn --pipe --roff README.md > doc/jit.1
	ronn --pipe --html README.md > doc/jit.1.html
