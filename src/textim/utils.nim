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
  ## Finds file's extension name.
  let fileSplit = splitFile(fileName)
  case fileSplit.ext
  of ".txt":
    result = Txt
  of ".docx":
    result = Docx
  else:
    result = None

proc parseFile*(fileName: string): string =
  ## Returns the contents of the file.
  case findFileExt(fileName)
  of Txt:
    result = readFile(filename)
  of Docx:
    result = parseDocument(fileName)
  else:
    result = readFile(filename)
 
proc parseWords(tf: var TfIdf, s: string) =
  ## Calculates words.
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
  ## Adds new contents.
  let s = parseFile(fileName)
  parseWords(tf, s)

proc addString*(tf: var TfIdf, s: string) =
  ## Adds new contents.
  parseWords(tf, s)

proc countDocument*(tf: var TfIdf) =
  ## Calculates scores.
  let size = tf.total.len
  for idx in 0 ..< tf.tdIdf.len:
    for k, v in tf.tdIdf[idx].data.mpairs:
      v = (v / float(tf.tdIdf[idx].occur)) * ln(size / (tf.total[k] + 1))
