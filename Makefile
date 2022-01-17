.PHONY: build srv commit deploy firn

BRANCH=`git branch --show-current`

build:
	cd src && firn build

srv:
	cd src && firn serve

commit:
	@printf "\033[0;32mDeploying updates to github...\033[0m\n"
	git add src/*
	git commit -m "site rebuild `date`"

deploy: commit
	git push -u origin $(BRANCH)

# see https://github.com/theiceshelf/firn#quickstart
# installs to /usr/local/bin/firn
# https://github.com/theiceshelf/firn/blob/master/install#L27
firn:
	curl -s https://hyperreal.enterprises/install-firn -o install-firn
	chmod +x install-firn
	sudo ./install-firn
