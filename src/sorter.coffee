R_NUM_SPLITTER = /([0-9 \uff10-\uff19\u3000]+)|([^0-9 \uff10-\uff19\u3000]+)/g
R_MULTIBYTE_NUM = /[\uff10-\uff19]/g
DICTIONARY_DATA =
  en:
    encode:
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ': [
        'ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ'
        'abcdefghijklmnopqrstuvwxyz'
        'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ'
      ]
      '01234567890': [
        '０１２３４５６７８９'
      ]
  ja:
    encode:
      'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや ゆ よらりるれろわゐ ゑをん': [
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
    long  :
      'ー':
        'ぁぃぅぇぉ': [
          '  っ'
          'ゃ ゅ ょ'
          'ゎ'
        ]
        'ァィゥェォ': [
          'ヵ  ヶ'
          '  ッ'
          'ャ ュ ョ'
          'ヮ'
        ]
        'ｧｨｩｪｫ': [
          '  ｯ'
          'ｬ ｭ ｮ'
        ]
        'あいうえお': [
          'かきくけこ'
          'さしすせそ'
          'たちつてと'
          'なにぬねの'
          'はひふへほ'
          'まみむめも'
          'や ゆ よ'
          'らりるれろ'
          'わゐ ゑを'
          '  ゔ'
          'がぎぐげご'
          'ざじずぜぞ'
          'だぢづでど'
          'ばびぶべぼ'
          'ぱぴぷぺぽ'
        ]
        'アイウエオ': [
          'カキクケコ'
          'サシスセソ'
          'タチツデト'
          'ナニヌネノ'
          'ハヒフヘホ'
          'マミムメモ'
          'ヤ ユ ヨ'
          'ラリルレロ'
          'ワヰ ヱヲ'
          '  ヴ'
          'ガギグゲゴ'
          'ザジズゼゾ'
          'ダヂヅデド'
          'バビブベボ'
          'パピプペポ'
        ]
        'ｱｲｳｴｵ': [
          'ｶｷｸｹｺ'
          'ｻｼｽｾｿ'
          'ﾀﾁﾂﾃﾄ'
          'ﾅﾆﾇﾈﾉ'
          'ﾊﾋﾌﾍﾎ'
          'ﾏﾐﾑﾒﾓ'
          'ﾔ ﾕ ﾖ'
          'ﾗﾘﾙﾚﾛ'
          'ﾜ   ｦ'
        ]

dictionary =
  encode: []
  long  : {}

do ->
  for language, dictionaryData of DICTIONARY_DATA
    # Setup encode data.
    for trgText, srcTexts of dictionaryData.encode
      trgCodes = []
      for trgChar, i in trgText
        trgCodes[i] = trgText.charCodeAt i
      deltaPerRow = Math.pow 0.1, String(srcTexts.length).length + 1
      for srcText, i in srcTexts
        delta = deltaPerRow * (i + 1)
        data =
          min: Infinity
          max: -Infinity
          map: {}
        for srcChar, j in srcText
          code = srcText.charCodeAt j
          if code isnt 32
            data.map[code] = trgCodes[j] + delta
          if code < data.min
            data.min = code
          if code > data.max
            data.max = code
        dictionary.encode.push data

    # Setup long data.
    for longChar, data of dictionaryData.long
      map = {}
      for trgText, srcTexts of data
        trgCodes = []
        for trgChar, i in trgText
          trgCodes[i] = trgText.charCodeAt i
        for srcText in srcTexts
          for srcChar, i in srcText
            srcCode = srcText.charCodeAt i
            if srcCode isnt 32
              map[srcCode] = trgCodes[i]
      dictionary.long[longChar.charCodeAt 0] = map

#console.log dictionary

exports = {}

exports.dictionary = (src, key = null)->
  src.sort (a, b)->
    if key
      a = a[key]
      b = b[key]
    compareAsDictionary a, b
  src

compareAsDictionary = (a, b)->
  delta = 0
  for i in [0...Math.min(a.length, b.length)] by 1
    d = toDictionaryCode(a, i) - toDictionaryCode(b, i)
    if d < -0.1 or d > 0.1
      return d
    if delta is 0
      delta = d
  if (d = a.length - b.length) isnt 0
    d
  else
    delta

toDictionaryCode = (text, index)->
  code = text.charCodeAt index

  # If current char is long, displace to corresponded char of previous char.
  if index > 0 and (map = dictionary.long[code])?
    prevCode = text.charCodeAt index - 1
    if (currCode = map[prevCode])?
      code = currCode

  i = dictionary.encode.length
  while i--
    map = dictionary.encode[i]
    if code >= map.min and code <= map.max and map.map[code]?
      return map.map[code]
  code

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
        delta = compareAsDictionary(a[i].str, b[i].str)
      #console.log('                      Number -->')
    else if typeof a[i].num isnt 'undefined'
      #console.log('                      decide as String!!')
      return compareAsDictionary(a[i].str, b[i].str)
    else if typeof b[i].num isnt 'undefined'
      #console.log('                      decide as String!!')
      return compareAsDictionary(a[i].str, b[i].str)
    else
      d = compareAsDictionary(a[i].str, b[i].str)
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

#if BROWSER
if define?
  define -> exports
else if window?
  unless window.mn? then window.mn = {}
  unless window.mn.dsk? then window.mn.dsk = {}
  unless window.mn.dsk.sorter? then window.mn.dsk.sorter = exports
#else
module.exports = exports
#endif