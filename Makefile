# -*- make -*-
FILES := \
	.aliases            \
	.bash_profile       \
	.bash_prompt        \
	.curlrc             \
	.exports            \
	.extra              \
	.gitconfig          \
	.inputrc            \
	.osx                \

# FILES end

.PHONY: $FILES

# $FILES:
# 	echo

diff-home: $(FILES)
	for i in $^ ; do \
	    diff -u ~/$$(basename $$i) $$i ; \
        done

diff-repo: $(FILES)
	for i in $^ ; do \
	    diff -u $$i ~/$$(basename $$i) ; \
        done

copy-home-to-repo: $(FILES)
	for i in $^ ; do \
	  echo cp ~/$$(basename $$i) $$i ; \
	done

copy-repo-to-home: $(FILES)
	for i in $^ ; do \
	  echo cp $$i ~/$$(basename $$i) ; \
	done
