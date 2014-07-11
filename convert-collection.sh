#! /bin/sh

SOURCE=${1}
DEST=${2}
ROOT='./migrate'

CNXML_UTILS=~/rhaptos.cnxmlutils/rhaptos/cnxmlutils/xsl
CNXML_TO_HTML_XSL=${CNXML_UTILS}/cnxml-to-html5.xsl
COLLXML_TO_HTML_XSL=${CNXML_UTILS}/collxml-to-html5.xsl

KRAMDOWN_CLEANUP_XSL=${ROOT}/kramdownify.xsl
POST_CLEANUP_XSL=${ROOT}/post-cleanup.xsl


function kramdownize {
  # 1. Clean up the HTML so the kramdown markup is cleaner (remove id's on paragraphs, convert <figure> to <img>)
  # 2. remove the XHTML namespace from elements so kramdown does not add it via {: xmlns="http://..."}
  # 3. disable line wrapping
  # 4. add the markdown="1" to figures so the contents is processed (BUG?)
  # 5. convert the <title> at the top of the file to a Liquid Template (for Jekyll)
  xsltproc ${KRAMDOWN_CLEANUP_XSL} - | xsltproc ${POST_CLEANUP_XSL} - | kramdown --line-width 9999 -i html -o kramdown - | sed 's/ data-z-for-sed=""\}\ */\}\
\
/g' /dev/stdin | sed 's/<figure/<figure markdown="1"/g' /dev/stdin | sed 's/<title>/---\
title: "/g' /dev/stdin | sed 's/<\/title>/"\
layout: page\
---\
/g' /dev/stdin

}


# Copy resources (assume no name collisions)
echo "Copying resources (assuming duplicate file names are OK)"
mkdir ${DEST}/resources

cp ${SOURCE}/*/* ${DEST}/resources
rm ${DEST}/resources/*.cnxml



# Convert the ToC
echo "Building SUMMARY.md"
xsltproc ${COLLXML_TO_HTML_XSL} ${SOURCE}/collection.xml | kramdownize > ${DEST}/SUMMARY.md



mkdir ${DEST}/contents

# Loop through all the modules and convert them to markdown
for MODULE_NAME in $(cd ${SOURCE} && ls | grep '^m')
do
  echo "Building ${MODULE_NAME}.md"
  MODULE_HTML=$(xsltproc ${CNXML_TO_HTML_XSL} ${SOURCE}/${MODULE_NAME}/index.cnxml)
  echo "<html xmlns=\"http://www.w3.org/1999/xhtml\">${MODULE_HTML}</html>" | kramdownize > ${DEST}/contents/${MODULE_NAME}.md
done


# MODULE_NAME="m44593"
# echo "Building ${MODULE_NAME}.md"
# MODULE_HTML=$(xsltproc ${CNXML_TO_HTML_XSL} ${SOURCE}/${MODULE_NAME}/index.cnxml)
# echo "<html xmlns=\"http://www.w3.org/1999/xhtml\">${MODULE_HTML}</html>" | kramdownize > ${MODULE_NAME}.md

