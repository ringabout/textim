import os, parseutils, tables, sets, strutils

import docx, stopwords


type
  FileKind* = enum
    Txt, Docx, None
  TfIdf* = object
    data*: seq[Table[string, float]]
    total*: Table[string, int]
     

proc findFileExt(fileName: string): FileKind =
  let fileSplit = splitFile(fileName)
  echo fileSplit.ext
  case fileSplit.ext:
  of ".txt":
    result = Txt
  of ".docx":
    result = Docx
  else:
    result = None

proc parseWords*(tf: var TfIdf, fileName: string) =
  var s: string
  case findFileExt(fileName):
  of Txt:
    let 
      f = open(fileName, fmRead)
    s = f.readAll()
    f.close()
  of Docx:
    s = parseDocument(fileName)
  else:
    let 
      f = open(fileName, fmRead)
    s = f.readAll()
  var
    pos = 0
    word: string
    current = tf.data.len
  tf.data.add(initTable[string, float]())
  while pos < s.len:
    pos += parseIdent(s, word, pos)
    word = toLowerAscii(word)
    echo word
    pos += skipUntil(s, Letters, pos)
    if word in ENGLISH_STOP_WORDS:
      continue
    if word notin tf.data[current]:
      if word notin tf.total:
        tf.total[word] = 1
      else:
        tf.total[word] += 1
      tf.data[current][word] = 0.0
    tf.data[current][word] += 1.0

    


    

  