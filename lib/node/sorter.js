(function() {
  var DICTIONARY, R_MULTIBYTE_NUM, R_NUM_SPLITTER, dictionaryCompare, exports, jaVowel, naturalCompare, naturalParse, sequence, toDictionaryCode;

  R_NUM_SPLITTER = /([0-9 \uff10-\uff19\u3000]+)|([^0-9 \uff10-\uff19\u3000]+)/g;

  R_MULTIBYTE_NUM = /[\uff10-\uff19]/g;

  DICTIONARY = {
    'A': ['Ａ-Ｚ', 'a-z', 'ａ-ｚ'],
    '0': ['０-９'],
    'あ': ['ぁぃぅぇぉ            っ                 ゃ ゅ ょ     ゎ', 'ァィゥェォヵ  ヶ        ッ                 ャ ュ ョ     ヮ', 'ｧｨｩｪｫ            ｯ                 ｬ ｭ ｮ', 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや ゆ よらりるれろわゐ ゑをん', 'アイウエオカキクケコサシスセソタチツデトナニヌネノハヒフヘホマミムメモヤ ユ ヨラリルレロワヰ ヱヲン', 'ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔ ﾕ ﾖﾗﾘﾙﾚﾛﾜ   ｦﾝ', '  ゔ  がぎぐげござじずぜぞだぢづでど     ばびぶべぼ', '  ヴ  ガギグゲゴザジズゼゾダヂヅデド     バビブベボ', '                         ぱぴぷぺぽ', '                         パピプペポ']
  };

  sequence = [];

  jaVowel = [];

  (function() {
    var baseCode, code, data, delta, i, j, srcText, srcTexts, trgChar, trgCode, _results;
    _results = [];
    for (trgChar in DICTIONARY) {
      srcTexts = DICTIONARY[trgChar];
      trgCode = trgChar.charCodeAt(0);
      delta = Math.pow(0.1, String(srcTexts.length).length + 1);
      _results.push((function() {
        var _len, _ref, _results2;
        _results2 = [];
        for (i = 0, _len = srcTexts.length; i < _len; i++) {
          srcText = srcTexts[i];
          baseCode = trgCode + delta * (i + 1);
          data = {
            targetChar: trgChar,
            targetCode: trgCode,
            src: srcText,
            codeMap: {}
          };
          if (srcText.length === 3 && srcText.indexOf('-') === 1) {
            data.min = srcText.charCodeAt(0);
            data.max = srcText.charCodeAt(2);
            for (j = 0, _ref = data.max - data.min; j <= _ref; j += 1) {
              data.codeMap[data.min + j] = baseCode + j;
            }
          } else {
            data.min = Number.MAX_VALUE;
            data.max = Number.MIN_VALUE;
            j = srcText.length;
            while (j--) {
              code = srcText.charCodeAt(j);
              if (code !== 32 && code !== 12288) {
                data.codeMap[code] = baseCode + j;
                if (code < data.min) data.min = code;
                if (code > data.max) data.max = code;
              }
            }
          }
          sequence.push(data);
          if (trgChar === 'あ') {
            _results2.push(jaVowel.push(data));
          } else {
            _results2.push(void 0);
          }
        }
        return _results2;
      })());
    }
    return _results;
  })();

  console.log(sequence[sequence.length - 1]);

  console.log('-------------');

  console.log(jaVowel[jaVowel.length - 1]);

  dictionaryCompare = function(a, b) {
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
    var code, i, map;
    code = text.charCodeAt(index);
    if ((code === 12540 || code === 12509) && index !== 0) {
      while (index--) {
        code = text.charCodeAt(index);
        if (code !== 12540 && code !== 12509) break;
      }
      i = jaVowel.length;
      while (i--) {
        map = jaVowel[i];
        if (code >= map.min && code <= map.max && map.codeMap[code]) {
          code = map.src.charCodeAt(map.src.indexOf(text.charAt(index)) % 5);
          break;
        }
      }
    }
    i = sequence.length;
    while (i--) {
      map = sequence[i];
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
          delta = dictionaryCompare(a[i].str, b[i].str);
        }
      } else if (typeof a[i].num !== 'undefined') {
        return dictionaryCompare(a[i].str, b[i].str);
      } else if (typeof b[i].num !== 'undefined') {
        return dictionaryCompare(a[i].str, b[i].str);
      } else {
        d = dictionaryCompare(a[i].str, b[i].str);
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

  exports = {};

  exports.dictionarySort = function(src, key) {
    if (key == null) key = null;
    src.sort(function(a, b) {
      if (key) {
        a = a[key];
        b = b[key];
      }
      return dictionaryCompare(a, b);
    });
    return src;
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
