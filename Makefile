# -*- make -*-
FILES := \
	.aliases            \
	.bash_profile       \
	.bash_prompt        \
	.curlrc             \
	.exports            \
	.extra              \
	.functions          \
	.gitconfig          \
	.hgignore           \
	.hgrc               \
	.hg-map-cmdline.lg  \
	.hg-pre-update-hook.sh  \
	.inputrc            \
	.osx                \
	.screenrc           \
	.screenrc-hardstatus1 \
	.screenrc-hardstatus2 \
	.wgetrc             \
	.Xresources         \
	bin/prompt_lite.sh  \

# FILES end

.PHONY: $FILES

# $FILES:
# 	echo

home-vs-repo: $(FILES)
	@ for i in $^ ; do \
	    diff -u ~/$$i $$i ; \
        done ; true

repo-vs-home: $(FILES)
	@ for i in $^ ; do \
	    diff -u $$i ~/$$i ; \
        done

copy-home-to-repo: $(FILES)
	@ for i in $^ ; do \
	  cp ~/$$(basename $$i) $$i ; \
	done

copy-repo-to-home: $(FILES)
	for i in $^ ; do \
	  cp -v $$i ~/$$(basename $$i) ; \
	done

status:
	hg status
