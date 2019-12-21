import os, parseutils, tables, sets, strutils, math

import docx, stopwords


type
  FileKind* = enum
    Txt, Docx, None

  TfIdfData* = tuple
    data: Table[string, float]
    occur: int

  TfIdf* = object
    tdIdf*: seq[TfIdfData] 
    total*: Table[string, int]
     
proc parseWords*(tf: var TfIdf, s: string)

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

proc parseFile*(fileName: string): string =
  case findFileExt(fileName):
  of Txt:
    let 
      f = open(fileName, fmRead)
    result = f.readAll()
    f.close()
  of Docx:
    result = parseDocument(fileName)
  else:
    let 
      f = open(fileName, fmRead)
    result = f.readAll()
    f.close()


proc parseWords(tf: var TfIdf, s: string) =
  var
    pos = 0
    word: string
    current = tf.tdIdf.len
  tf.tdIdf.add((initTable[string, float](), 0))
  while pos < s.len:
    pos += parseIdent(s, word, pos)
    word = toLowerAscii(word)
    pos += skipUntil(s, Letters, pos)
    if word in ENGLISH_STOP_WORDS:
      continue
    if word notin tf.tdIdf[current].data:
      if word notin tf.total:
        tf.total[word] = 1
      else:
        tf.total[word] += 1
      tf.tdIdf[current].data[word] = 0.0
    tf.tdIdf[current].data[word] += 1.0
    tf.tdIdf[current].occur += 1

proc addDocument*(tf: var TfIdf, fileName: string) =
  let s = parseFile(fileName)
  parseWords(tf, s)

proc addString*(tf: var TfIdf, s: string) =
  parseWords(tf, s)

proc countDocument*(tf: var TfIdf) =
  let size = tf.total.len
  for idx in 0 ..< tf.tdIdf.len:
    for k, v in tf.tdIdf[idx].data.mpairs:
      v = (v / float(tf.tdIdf[idx].occur)) * ln(size / (tf.total[k] + 1))
