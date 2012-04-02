(function() {
  var DICTIONARY_DATA, R_MULTIBYTE_NUM, R_NUM_SPLITTER, compareAsDictionary, dictionary, exports, naturalCompare, naturalParse, toDictionaryCode;

  R_NUM_SPLITTER = /([0-9 \uff10-\uff19\u3000]+)|([^0-9 \uff10-\uff19\u3000]+)/g;

  R_MULTIBYTE_NUM = /[\uff10-\uff19]/g;

  DICTIONARY_DATA = {
    en: {
      encode: {
        'A': ['ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ', 'abcdefghijklmnopqrstuvwxyz', 'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ'],
        '0': ['０１２３４５６７８９']
      }
    },
    ja: {
      encode: {
        'あ': ['ぁぃぅぇぉ            っ                 ゃ ゅ ょ     ゎ', 'ァィゥェォヵ  ヶ        ッ                 ャ ュ ョ     ヮ', 'ｧｨｩｪｫ            ｯ                 ｬ ｭ ｮ', 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや ゆ よらりるれろわゐ ゑをん', 'アイウエオカキクケコサシスセソタチツデトナニヌネノハヒフヘホマミムメモヤ ユ ヨラリルレロワヰ ヱヲン', 'ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔ ﾕ ﾖﾗﾘﾙﾚﾛﾜ   ｦﾝ', '  ゔ  がぎぐげござじずぜぞだぢづでど     ばびぶべぼ', '  ヴ  ガギグゲゴザジズゼゾダヂヅデド     バビブベボ', '                         ぱぴぷぺぽ', '                         パピプペポ']
      },
      long: {
        'ー': {
          'ぁぃぅぇぉ': ['  っ', 'ゃ ゅ ょ', 'ゎ'],
          'ァィゥェォ': ['ヵ  ヶ', '  ッ', 'ャ ュ ョ', 'ヮ'],
          'ｧｨｩｪｫ': ['  ｯ', 'ｬ ｭ ｮ'],
          'あいうえお': ['かきくけこ', 'さしすせそ', 'たちつてと', 'なにぬねの', 'はひふへほ', 'まみむめも', 'や ゆ よ', 'らりるれろ', 'わゐ ゑを', '  ゔ', 'がぎぐげご', 'ざじずぜぞ', 'だぢづでど', 'ばびぶべぼ', 'ぱぴぷぺぽ'],
          'アイウエオ': ['カキクケコ', 'サシスセソ', 'タチツデト', 'ナニヌネノ', 'ハヒフヘホ', 'マミムメモ', 'ヤ ユ ヨ', 'ラリルレロ', 'ワヰ ヱヲ', '  ヴ', 'ガギグゲゴ', 'ザジズゼゾ', 'ダヂヅデド', 'バビブベボ', 'パピプペポ'],
          'ｱｲｳｴｵ': ['ｶｷｸｹｺ', 'ｻｼｽｾｿ', 'ﾀﾁﾂﾃﾄ', 'ﾅﾆﾇﾈﾉ', 'ﾊﾋﾌﾍﾎ', 'ﾏﾐﾑﾒﾓ', 'ﾔ ﾕ ﾖ', 'ﾗﾘﾙﾚﾛ', 'ﾜ   ｦ']
        }
      }
    }
  };

  dictionary = {
    encode: [],
    long: {}
  };

  (function() {
    var baseCode, code, data, delta, dictionaryData, i, j, language, longChar, map, srcChar, srcCode, srcText, srcTexts, trgChar, trgCode, trgCodes, trgText, _len, _ref, _results;
    _results = [];
    for (language in DICTIONARY_DATA) {
      dictionaryData = DICTIONARY_DATA[language];
      _ref = dictionaryData.encode;
      for (trgChar in _ref) {
        srcTexts = _ref[trgChar];
        trgCode = trgChar.charCodeAt(0);
        delta = Math.pow(0.1, String(srcTexts.length).length + 1);
        for (i = 0, _len = srcTexts.length; i < _len; i++) {
          srcText = srcTexts[i];
          baseCode = trgCode + delta * (i + 1);
          data = {
            trgChar: trgChar,
            trgCode: trgCode,
            src: srcText,
            codeMap: {}
          };
          data.min = Number.MAX_VALUE;
          data.max = Number.MIN_VALUE;
          j = srcText.length;
          while (j--) {
            code = srcText.charCodeAt(j);
            if (code !== 32) {
              data.codeMap[code] = baseCode + j;
              if (code < data.min) data.min = code;
              if (code > data.max) data.max = code;
            }
          }
          dictionary.encode.push(data);
        }
      }
      _results.push((function() {
        var _i, _len2, _len3, _len4, _ref2, _results2;
        _ref2 = dictionaryData.long;
        _results2 = [];
        for (longChar in _ref2) {
          data = _ref2[longChar];
          map = {};
          for (trgText in data) {
            srcTexts = data[trgText];
            trgCodes = [];
            for (i = 0, _len2 = trgText.length; i < _len2; i++) {
              trgChar = trgText[i];
              trgCodes[i] = trgText.charCodeAt(i);
            }
            for (_i = 0, _len3 = srcTexts.length; _i < _len3; _i++) {
              srcText = srcTexts[_i];
              for (i = 0, _len4 = srcText.length; i < _len4; i++) {
                srcChar = srcText[i];
                srcCode = srcText.charCodeAt(i);
                if (srcCode !== 32) map[srcCode] = trgCodes[i];
              }
            }
          }
          _results2.push(dictionary.long[longChar.charCodeAt(0)] = map);
        }
        return _results2;
      })());
    }
    return _results;
  })();

  console.log(dictionary);

  exports = {};

  exports.dictionary = function(src, key) {
    if (key == null) key = null;
    src.sort(function(a, b) {
      if (key) {
        a = a[key];
        b = b[key];
      }
      return compareAsDictionary(a, b);
    });
    return src;
  };

  compareAsDictionary = function(a, b) {
    var d, delta, i, _ref;
    delta = 0;
    for (i = 0, _ref = Math.min(a.length, b.length); i < _ref; i += 1) {
      d = toDictionaryCode(a, i) - toDictionaryCode(b, i);
      if (d < -0.1 || d > 0.1) return d;
      if (delta === 0) delta = d;
    }
    d = a.length - b.length;
    if (d !== 0) {
      return d;
    } else {
      return delta;
    }
  };

  toDictionaryCode = function(text, index) {
    var code, currCode, i, map, prevCode;
    code = text.charCodeAt(index);
    if (index > 0 && ((map = dictionary.long[code]) != null)) {
      prevCode = text.charCodeAt(index - 1);
      if ((currCode = map[prevCode]) != null) code = currCode;
    }
    i = dictionary.encode.length;
    while (i--) {
      map = dictionary.encode[i];
      if (code >= map.min && code <= map.max && map.codeMap[code]) {
        return map.codeMap[code];
      }
    }
    return code;
  };

  naturalParse = function(text) {
    var chunks;
    chunks = [];
    text.replace(R_NUM_SPLITTER, function(matched, num, str) {
      var chunk;
      chunk = {};
      if (num) {
        chunk.num = Number(num.replace(R_MULTIBYTE_NUM, function(matched) {
          return '０１２３４５６７８９'.indexOf(matched);
        }));
      }
      chunk.str = matched;
      return chunks.push(chunk);
    });
    return chunks;
  };

  naturalCompare = function(a, b) {
    var d, delta, i, _ref, _ref2;
    a = a.chunks;
    b = b.chunks;
    delta = 0;
    for (i = 0, _ref = Math.min(a.length, b.length); i < _ref; i += 1) {
      if (typeof a[i].num !== 'undefined' && typeof b[i].num !== 'undefined') {
        if ((d = a[i].num - b[i].num) !== 0) {
          return d;
        } else if ((d = a[i].str.length - b[i].str.length) !== 0) {
          if (delta === 0) {
            delta = (_ref2 = d < 0) != null ? _ref2 : -{
              0.1: 0.1
            };
          }
        } else if (delta === 0) {
          delta = compareAsDictionary(a[i].str, b[i].str);
        }
      } else if (typeof a[i].num !== 'undefined') {
        return compareAsDictionary(a[i].str, b[i].str);
      } else if (typeof b[i].num !== 'undefined') {
        return compareAsDictionary(a[i].str, b[i].str);
      } else {
        d = compareAsDictionary(a[i].str, b[i].str);
        if (d < -0.1 || d > 0.1) return d;
        if (delta === 0) delta = d;
      }
    }
    d = a.length - b.length;
    if (d !== 0) {
      return d;
    } else {
      return delta;
    }
  };

  exports.naturalSort = function(src, key) {
    var dst, i, tmps, v, _len;
    if (key == null) key = null;
    tmps = [];
    console.log(src);
    for (i = 0, _len = src.length; i < _len; i++) {
      v = src[i];
      v = key ? v[key] : v;
      tmps[i] = {
        raw: v,
        chunks: naturalParse(v)
      };
    }
    tmps.sort(naturalCompare);
    dst = [];
    i = tmps.length;
    while (i--) {
      dst[i] = tmps[i].raw;
    }
    return dst;
  };

  module.exports = exports;

}).call(this);
