.PHONY: build srv commit deploy firn

BRANCH=`git branch --show-current`

build:
	cd src && firn build && cd .. && \
    rsync -athv --exclude=".*" src/_firn/_site/ docs/

srv:
	cd src && firn serve

commit: build
	@printf "\033[0;32mDeploying updates to github...\033[0m\n"
	git add src/*
	git add docs/*
	git commit -m "site rebuild `date`"

deploy: commit
	git push -u origin $(BRANCH)

# see https://github.com/theiceshelf/firn#quickstart
# installs to /usr/local/bin/firn
# https://github.com/theiceshelf/firn/blob/master/install#L27
firn:
	curl -s https://raw.githubusercontent.com/theiceshelf/firn/master/install -o install-firn
	chmod +x install-firn
	sudo ./install-firn
