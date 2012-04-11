(function() {
  var DICTIONARY_DATA, R_MULTIBYTE_NUM, R_NUM_SPLITTER, dictCompare, dictionary, exports, natCompare, toDictCode;

  exports = {};

  R_NUM_SPLITTER = /([0-9 \uff10-\uff19\u3000]+)|([^0-9 \uff10-\uff19\u3000]+)/g;

  R_MULTIBYTE_NUM = /[\uff10-\uff19]/g;

  DICTIONARY_DATA = {
    en: {
      encode: {
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ': ['ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ', 'abcdefghijklmnopqrstuvwxyz', 'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ'],
        '01234567890': ['０１２３４５６７８９']
      }
    },
    ru: {
      encode: {
        'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ': ['абвгдеёжзийклмнопрстуфхцчшщъыьэюя']
      }
    },
    ja: {
      encode: {
        'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや ゆ よらりるれろわゐ ゑをん': ['ぁぃぅぇぉ            っ                 ゃ ゅ ょ     ゎ', 'ァィゥェォヵ  ヶ        ッ                 ャ ュ ョ     ヮ', 'ｧｨｩｪｫ            ｯ                 ｬ ｭ ｮ', 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや ゆ よらりるれろわゐ ゑをん', 'アイウエオカキクケコサシスセソタチツデトナニヌネノハヒフヘホマミムメモヤ ユ ヨラリルレロワヰ ヱヲン', 'ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔ ﾕ ﾖﾗﾘﾙﾚﾛﾜ   ｦﾝ', '  ゔ  がぎぐげござじずぜぞだぢづでど     ばびぶべぼ', '  ヴ  ガギグゲゴザジズゼゾダヂヅデド     バビブベボ', '                         ぱぴぷぺぽ', '                         パピプペポ']
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
    var code, data, delta, deltaPerRow, dictionaryData, i, j, language, longChar, map, srcChar, srcCode, srcText, srcTexts, trgChar, trgCodes, trgText, _len, _len2, _len3, _ref, _results;
    _results = [];
    for (language in DICTIONARY_DATA) {
      dictionaryData = DICTIONARY_DATA[language];
      _ref = dictionaryData.encode;
      for (trgText in _ref) {
        srcTexts = _ref[trgText];
        trgCodes = [];
        for (i = 0, _len = trgText.length; i < _len; i++) {
          trgChar = trgText[i];
          trgCodes[i] = trgText.charCodeAt(i);
        }
        deltaPerRow = Math.pow(0.1, String(srcTexts.length).length + 1);
        for (i = 0, _len2 = srcTexts.length; i < _len2; i++) {
          srcText = srcTexts[i];
          delta = deltaPerRow * (i + 1);
          data = {
            min: Infinity,
            max: -Infinity,
            map: {}
          };
          for (j = 0, _len3 = srcText.length; j < _len3; j++) {
            srcChar = srcText[j];
            code = srcText.charCodeAt(j);
            if (code !== 32) data.map[code] = trgCodes[j] + delta;
            if (code < data.min) data.min = code;
            if (code > data.max) data.max = code;
          }
          dictionary.encode.push(data);
        }
      }
      _results.push((function() {
        var _i, _len4, _len5, _len6, _ref2, _results2;
        _ref2 = dictionaryData.long;
        _results2 = [];
        for (longChar in _ref2) {
          data = _ref2[longChar];
          map = {};
          for (trgText in data) {
            srcTexts = data[trgText];
            trgCodes = [];
            for (i = 0, _len4 = trgText.length; i < _len4; i++) {
              trgChar = trgText[i];
              trgCodes[i] = trgText.charCodeAt(i);
            }
            for (_i = 0, _len5 = srcTexts.length; _i < _len5; _i++) {
              srcText = srcTexts[_i];
              for (i = 0, _len6 = srcText.length; i < _len6; i++) {
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

  exports.dictSort = function(src, key) {
    if (key == null) key = null;
    src.sort(function(a, b) {
      if (key) {
        a = a[key];
        b = b[key];
      }
      return dictCompare(a, b);
    });
    return src;
  };

  dictCompare = function(a, b) {
    var d, delta, i, _ref;
    delta = 0;
    for (i = 0, _ref = Math.min(a.length, b.length); i < _ref; i += 1) {
      d = toDictCode(a, i) - toDictCode(b, i);
      if (d < -0.1 || d > 0.1) return d;
      if (delta === 0) delta = d;
    }
    if ((d = a.length - b.length) !== 0) {
      return d;
    } else {
      return delta;
    }
  };

  toDictCode = function(text, index) {
    var code, currCode, i, map, prevCode;
    code = text.charCodeAt(index);
    if (index > 0 && ((map = dictionary.long[code]) != null)) {
      prevCode = text.charCodeAt(index - 1);
      if ((currCode = map[prevCode]) != null) code = currCode;
    }
    i = dictionary.encode.length;
    while (i--) {
      map = dictionary.encode[i];
      if (code >= map.min && code <= map.max && (map.map[code] != null)) {
        return map.map[code];
      }
    }
    return code;
  };

  exports.natSort = function(src, key) {
    var chunks, dst, i, tmps, v, _len;
    if (key == null) key = null;
    tmps = [];
    for (i = 0, _len = src.length; i < _len; i++) {
      v = src[i];
      v = key ? v[key] : v;
      chunks = [];
      v.replace(R_NUM_SPLITTER, function(matched, num, str) {
        var chunk;
        chunk = {};
        if (num) {
          num = num.replace(R_MULTIBYTE_NUM, function(matched) {
            return '０１２３４５６７８９'.indexOf(matched);
          });
          chunk.num = Number(num);
        }
        chunk.str = matched;
        return chunks.push(chunk);
      });
      tmps[i] = {
        raw: v,
        chunks: chunks
      };
    }
    tmps.sort(natCompare);
    dst = [];
    i = tmps.length;
    while (i--) {
      dst[i] = tmps[i].raw;
    }
    return dst;
  };

  natCompare = function(a, b) {
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
          delta = dictCompare(a[i].str, b[i].str);
        }
      } else if (typeof a[i].num !== 'undefined') {
        return dictCompare(a[i].str, b[i].str);
      } else if (typeof b[i].num !== 'undefined') {
        return dictCompare(a[i].str, b[i].str);
      } else {
        d = dictCompare(a[i].str, b[i].str);
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

  if (typeof define !== "undefined" && define !== null) {
    define(function() {
      return exports;
    });
  } else if (typeof window !== "undefined" && window !== null) {
    if (window.mn == null) window.mn = {};
    if (window.mn.dsk == null) window.mn.dsk = {};
    if (window.mn.dsk.sorter == null) window.mn.dsk.sorter = exports;
  }

}).call(this);
