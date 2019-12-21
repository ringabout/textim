# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import textim, docx, strutils

# let
#   text1 = parseDocument("t1.docx")
#   text2 = parseDocument("t2.docx") 

# echo text1
# echo repeat("-", 30)
# echo text2
import tables
var tf: TfIdf
addDocument(tf, "t1.docx")
addDocument(tf, "t2.docx")
countDocument(tf)
# echo tf.data[0].type
echo tf

