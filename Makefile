# We list 'en' first because it's built the most often, and therefore
# is less likely than any of the translations is to have a problem with
# PDF generation.  This way it gets built first, which means even if
# other builds fail later, you can still run the 'upload' rule.
LANGUAGES=en de es fr he ja ml pl pt-pt pt-br ca da fa id ru it gr ar gl hu nl ro vi zh ta ko sv th tr

default: all

# Process en/book.xml.in to produce en/book.xml with the right version number.
version-stamp:
	sed -e "s|__SEE ../aggrevision SCRIPT__|`./aggrevision`|g" \
           < en/book.xml.in > en/book.xml

.PHONY: ${LANGUAGES}
${LANGUAGES}: version-stamp
	@(cd $@ && make -f ../lang-makefile all-but-pdf)
	@(cd $@ && make -f ../lang-makefile pdf)

all: version-stamp
	@for name in ${LANGUAGES}; do                           \
          (cd $${name} && make -f ../lang-makefile all-but-pdf) \
        done
	@for name in ${LANGUAGES}; do                           \
          (cd $${name} && make -f ../lang-makefile pdf)         \
        done

# Note that running this command in the relevant lang dir works too:
# 'fop -xml book.xml -xsl ../tools/fo-stylesheet.xsl -pdf producingoss.pdf'
# r2881 has more background on how we discovered that command.  Whether
# we want to switch our PDF production method to it, instead of running
# 'xsltproc  --output ./producingoss.fo ../tools/fo-stylesheet.xsl book.xml'
# as we currently do (if you trace down into tools/Makefile.base-*
# you'll see how that happens) is an open question.
pdf: version-stamp
	@for name in ${LANGUAGES}; do                           \
          (cd $${name} && make -f ../lang-makefile pdf)         \
        done

ebook: version-stamp
	@for name in ${LANGUAGES}; do                    \
          (cd $${name} && make -f ../lang-makefile epub) \
        done

# The web site post-commit hook runs 'make www'.
www: lang-www dist
	@echo -n "r" > revision.txt.tmp
	@svnversion -n >> revision.txt.tmp
	@mv revision.txt.tmp revision.txt
lang-www: version-stamp
	@for name in ${LANGUAGES}; do                \
          cd $${name}; make -f ../lang-makefile www; \
          cd ..;                                     \
        done

clean:
	@for name in ${LANGUAGES}; do                  \
          cd $${name}; make -f ../lang-makefile clean; \
          cd ..;                                       \
        done
	@rm en/book.xml

upload: 
	@for d in ${LANGUAGES}; do                                                      \
          cd $${d};                                                                     \
          for ext in pdf epub; do                                                       \
            if [ -f producingoss.$${ext} ]; then                                        \
              echo "Uploading $${ext} for $${d}...";                                    \
              scp producingoss.$${ext}                                                  \
                kfogel@sp.red-bean.com:/www/producingoss/$${d}/pnew.$${ext};            \
              ssh kfogel@sp.red-bean.com                                                \
                "(cd /www/producingoss/$${d} && mv pnew.$${ext} producingoss.$${ext})"; \
              echo "Done";                                                              \
              echo "";                                                                  \
            fi;                                                                         \
          done;                                                                         \
          cd ..;                                                                        \
        done

dist: version-stamp
	@rm -rf tmp
	@mkdir tmp
	@svnversion -n . > tmp/rev
	@if cat tmp/rev | grep --silent ":"; then                          \
          echo -n "Cannot make dist from a mixed-revision working copy: "; \
          cat tmp/rev;                                                     \
          echo "";                                                         \
          exit 1;                                                          \
        fi
	@if cat tmp/rev | grep --silent "M"; then                          \
          echo -n "Cannot make dist from a modified working copy: ";       \
          cat tmp/rev;                                                     \
          echo "";                                                         \
          exit 1;                                                          \
        fi
	@echo -n "1." > tmp/vn
	@cat tmp/rev >> tmp/vn
	@mkdir tmp/producingoss-`cat tmp/vn`
	@cp COPYING README styles.css Makefile lang-makefile \
          tmp/producingoss-`cat tmp/vn`
	@for d in ??; do cp -a $${d} tmp/producingoss-`cat tmp/vn`/; done
	@find tmp -name ".svn" | xargs rm -rf
	@find tmp -name "*.ps" | xargs rm -rf
	@(cd tmp; tar zcvf producingoss-`cat vn`.tar.gz producingoss-`cat vn`)
	@(cd tmp; zip -r producingoss-`cat vn`.zip producingoss-`cat vn`)
	@if [ -f tmp/producingoss-`cat tmp/vn`.tar.gz ]; then \
           rm -rf producingoss-*.tar.gz;                      \
        fi
	@if [ -f tmp/producingoss-`cat tmp/vn`.zip ]; then \
           rm -rf producingoss-*.zip;                      \
        fi
	@mv tmp/producingoss-`cat tmp/vn`.tar.gz .
	@mv tmp/producingoss-`cat tmp/vn`.zip .
	@sed -e "s/REPLACEME/producingoss-`cat tmp\/vn`/g" \
          < download.html.tmpl > download.html
	@rm -rf tmp
