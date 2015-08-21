# -*- make -*-
FILES := \
	.aliases            \
	.bash_profile       \
	.bash_prompt        \
	.curlrc             \
	.exports            \
	.extra              \
	.gitconfig          \
	.hgrc               \
	.inputrc            \
	.osx                \
	.Xresources         \

# FILES end

.PHONY: $FILES

# $FILES:
# 	echo

home-vs-repo: $(FILES)
	@ for i in $^ ; do \
	    diff -u ~/$$(basename $$i) $$i ; \
        done ; true

repo-vs-home: $(FILES)
	@ for i in $^ ; do \
	    diff -u $$i ~/$$(basename $$i) ; \
        done

copy-home-to-repo: $(FILES)
	@ for i in $^ ; do \
	  echo cp ~/$$(basename $$i) $$i ; \
	done

copy-repo-to-home: $(FILES)
	for i in $^ ; do \
	  echo cp $$i ~/$$(basename $$i) ; \
	done

status:
	hg status
