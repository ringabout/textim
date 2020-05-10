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

