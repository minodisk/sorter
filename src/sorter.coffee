R_NUM_SPLITTER = /([0-9 \uff10-\uff19\u3000]+)|([^0-9 \uff10-\uff19\u3000]+)/g
R_MULTIBYTE_NUM = /[\uff10-\uff19]/g
DICTIONARY =
  'A': [
    'Ａ-Ｚ'
    'a-z'
    'ａ-ｚ'
  ]
  '0': [
    '０-９'
  ]
  'あ': [
    'ぁぃぅぇぉ            っ                 ゃ ゅ ょ     ゎ'
    'ァィゥェォヵ  ヶ        ッ                 ャ ュ ョ     ヮ'
    'ｧｨｩｪｫ            ｯ                 ｬ ｭ ｮ'
    'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや ゆ よらりるれろわゐ ゑをん'
    'アイウエオカキクケコサシスセソタチツデトナニヌネノハヒフヘホマミムメモヤ ユ ヨラリルレロワヰ ヱヲン'
    'ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔ ﾕ ﾖﾗﾘﾙﾚﾛﾜ   ｦﾝ'
    '  ゔ  がぎぐげござじずぜぞだぢづでど     ばびぶべぼ'
    '  ヴ  ガギグゲゴザジズゼゾダヂヅデド     バビブベボ'
    '                         ぱぴぷぺぽ'
    '                         パピプペポ'
  ]

sequence = []
jaVowel = []

do ->
  for trgChar, srcTexts of DICTIONARY
    trgCode = trgChar.charCodeAt 0
    delta = Math.pow 0.1, String(srcTexts.length).length + 1
    for srcText, i in srcTexts
      baseCode = trgCode + delta * (i + 1)
      data =
        targetChar: trgChar,
        targetCode: trgCode,
        src       : srcText,
        codeMap   : {}
      if srcText.length is 3 and srcText.indexOf('-') is 1
        data.min = srcText.charCodeAt 0
        data.max = srcText.charCodeAt 2
        for j in [0..data.max - data.min] by 1
          data.codeMap[data.min + j] = baseCode + j
      else
        data.min = Number.MAX_VALUE
        data.max = Number.MIN_VALUE
        j = srcText.length
        while j--
          code = srcText.charCodeAt j
          if code isnt 32 and code isnt 12288
            data.codeMap[code] = baseCode + j
            if code < data.min
              data.min = code
            if code > data.max
              data.max = code
      sequence.push data
      if trgChar is 'あ'
        jaVowel.push data

console.log sequence[sequence.length - 1]
console.log '-------------'
console.log jaVowel[jaVowel.length - 1]

dictionaryCompare = (a, b)->
  delta = 0
  for i in [0...Math.min(a.length, b.length)] by 1
    d = toDictionaryCode(a, i) - toDictionaryCode(b, i)
    if d < -0.1 or d > 0.1
      return d
    if delta is 0
      delta = d
  d = a.length - b.length
  if d isnt 0
    d
  else
    delta

toDictionaryCode = (text, index)->
  code = text.charCodeAt index
  if (code is 12540 or code is 12509) and index isnt 0
    while index--
      code = text.charCodeAt index
      if code isnt 12540 and code isnt 12509
        break
    i = jaVowel.length
    while i--
      map = jaVowel[i]
      if code >= map.min and code <= map.max and map.codeMap[code]
        code = map.src.charCodeAt(map.src.indexOf(text.charAt index) % 5)
        break

  i = sequence.length
  while i--
    map = sequence[i]
    if code >= map.min and code <= map.max and map.codeMap[code]
      return map.codeMap[code]
  code

naturalParse = (text)->
  chunks = []
  text.replace R_NUM_SPLITTER, (matched, num, str)->
    chunk = {}
    if num
      chunk.num = Number(num.replace R_MULTIBYTE_NUM, (matched)->
        '０１２３４５６７８９'.indexOf(matched)
      )
    chunk.str = matched
    chunks.push(chunk)
  #console.log(text, '->', JSON.stringify(chunks))
  chunks

naturalCompare = (a, b)->
  #  if (typeof a.num isnt 'undefined' and typeof b.num isnt 'undefined') {
  #    if ((d = a.num - b.num) isnt 0) {
  #      return d
  #    } else if ((d = a.raw.length - b.raw.length) isnt 0) {
  #      return d
  #    }
  #    return dictionaryCompare(a.raw, b.raw)
  #  } else if (typeof a.num isnt 'undefined') {
  #    return -1
  #  } else if (typeof b.num isnt 'undefined') {
  #    return 1
  #  }
  a = a.chunks
  b = b.chunks

  delta = 0
  for i in [0...Math.min(a.length, b.length)] by 1
    if typeof a[i].num isnt 'undefined' and typeof b[i].num isnt 'undefined'
      if (d = a[i].num - b[i].num) isnt 0
        #console.log('                      decide as Number!!')
        return d
      else if (d = a[i].str.length - b[i].str.length) isnt 0
        if delta is 0
          #console.log('                      Number, but string length -->')
          delta = (d < 0) ? -0.1: 0.1
      else if delta is 0
        #console.log('                      Number, but dictionary -->')
        delta = dictionaryCompare(a[i].str, b[i].str)
      #console.log('                      Number -->')
    else if typeof a[i].num isnt 'undefined'
      #console.log('                      decide as String!!')
      return dictionaryCompare(a[i].str, b[i].str)
    else if typeof b[i].num isnt 'undefined'
      #console.log('                      decide as String!!')
      return dictionaryCompare(a[i].str, b[i].str)
    else
      d = dictionaryCompare(a[i].str, b[i].str)
      if d < -0.1 or d > 0.1
        #console.log('                      decide as dictionary')
        return d
      if delta is 0
        delta = d
  #console.log('                      String -->')
  d = a.length - b.length
  if d isnt 0
    #console.log('                      decide as length', d)
    d
  else
    #console.log('                      decide as byte difference', delta)
    delta

exports = {}

exports.dictionarySort = (src, key = null)->
  src.sort (a, b)->
    if key
      a = a[key]
      b = b[key]
    return dictionaryCompare(a, b)
  return src

exports.naturalSort = (src, key = null)->
  tmps = []
  console.log src
  for v, i in src
    v = if key then v[key] else v
    tmps[i] =
      raw   : v
      chunks: naturalParse v
  tmps.sort(naturalCompare)
  dst = []
  i = tmps.length
  while i--
    dst[i] = tmps[i].raw
  dst

#if BROWSER
if module?
  module.exports = exports
else if define?
  define -> exports
else if window?
  unless window.mn? then window.mn = {}
  unless window.mn.dsk? then window.mn.dsk = {}
  unless window.mn.dsk.sorter? then window.mn.dsk.sorter = exports
#else
module.exports = exports
#endif