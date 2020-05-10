# textim
Text process utils writen in Nim.

# Examples

```nim
import textim


var tf: TfIdf
addDocument(tf, "t1.docx")
addDocument(tf, "t2.docx")
countDocument(tf)
echo tf
```

# API: textim

```nim
import textim
```

## **type** FileKind


```nim
FileKind = enum
 Txt, Docx, None
```

## **type** TfIdfData


```nim
TfIdfData = tuple[data: Table[string, float], occur: int]
```

## **type** TfIdf


```nim
TfIdf = object
 tdIdf*: seq[TfIdfData]
 total*: Table[string, int]
```

## **proc** parseFile

Returns the contents of the file.

```nim
proc parseFile(fileName: string): string {.raises: [IOError, OSError, Defect, Exception], tags: [
 ReadIOEffect, ReadDirEffect, WriteDirEffect, WriteIOEffect].}
```

## **proc** parseWords

Calculates words.

```nim
proc parseWords(tf: var TfIdf; s: string) {.raises: [KeyError].}
```

## **proc** addDocument

Adds new contents.

```nim
proc addDocument(tf: var TfIdf; fileName: string) {.raises: [IOError, OSError, Defect, Exception, KeyError], tags: [ReadIOEffect, ReadDirEffect, WriteDirEffect, WriteIOEffect].}
```

## **proc** addString

Adds new contents.

```nim
proc addString(tf: var TfIdf; s: string) {.raises: [KeyError].}
```

## **proc** countDocument

Calculates scores.

```nim
proc countDocument(tf: var TfIdf) {.raises: [KeyError].}
```
