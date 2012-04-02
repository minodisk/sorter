sorter = require '../lib/node/sorter'

_shuffle = (src)->
  src = src.slice()
  i = src.length
  while i
    j = Math.random() * i >> 0
    v = src[--i]
    src[i] = src[j]
    src[j] = v
  src

exports.dictionary =

  'empty':(test)->
    src = ['', '']
    test.deepEqual sorter.dictionary(_shuffle(src)), src
    test.done()

  'single-byte':

    'number(basic)': (test)->
      src = [
        '123', '132', '213', '231', '312', '321'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'number': (test)->
      src = [
        '0', '00', '000', '001', '01', '010', '011'
        '1', '10', '100', '101', '11', '110', '111'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'alphabet': (test)->
      src = [
        'A', 'a'
        'AA', 'Aa', 'aA', 'aa'
        'AAA', 'AAa', 'AaA', 'Aaa', 'aAA', 'aAa', 'aaA', 'aaa'
        'ab', 'abc', 'b'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'mixed': (test)->
      src = [
        'A10B1', 'A10B10', 'A10B2', 'A1B1', 'A1B10', 'A1B2'
        'A2B1', 'A2B10', 'A2B2'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'filename': (test)->
      src = [
        '1.txt', '10.txt', '100.txt'
        '2.txt', '20.txt'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

  'multibyte':

    'number': (test)->
      src = [
        '000', '00０', '0０0', '0００'
        '０00', '０0０', '００0', '０００'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'alphabet': (test)->
      src = [
        'AＡaａ', 'AＡａa', 'AaＡａ', 'AaａＡ', 'AａＡa', 'AａaＡ'
        'ＡAaａ', 'ＡAａa', 'ＡaAａ', 'ＡaａA', 'ＡａAa', 'ＡａaA'
        'aAＡａ', 'aAａＡ', 'aＡAａ', 'aＡａA', 'aａAＡ', 'aａＡA'
        'ａAＡa', 'ａAaＡ', 'ａＡAa', 'ａＡaA', 'ａaAＡ', 'ａaＡA'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'japanese aiueo': (test)->
      src = [
        'ぁ', 'ァ', 'ｧ', 'あ', 'ア', 'ｱ'
        'ぃ', 'ィ', 'ｨ', 'い', 'イ', 'ｲ'
        'ぅ', 'ゥ', 'ｩ', 'う', 'ウ', 'ｳ', 'ゔ', 'ヴ'
        'ぇ', 'ェ', 'ｪ', 'え', 'エ', 'ｴ'
        'ぉ', 'ォ', 'ｫ', 'お', 'オ', 'ｵ'
        'ゎ', 'ヮ', 'わ', 'ワ', 'ﾜ'
        'ゐ', 'ヰ'
        'ゑ', 'ヱ'
        'を', 'ヲ', 'ｦ'
        'ん', 'ン', 'ﾝ'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'japanese a': (test)->
      src = [
        'ぁぁぁ', 'ぁぁァ', 'ぁぁｧ'
        'ぁァぁ', 'ぁァァ', 'ぁァｧ'
        'ぁｧぁ', 'ぁｧァ', 'ぁｧｧ'
        'ァぁぁ', 'ァぁァ', 'ァぁｧ'
        'ァァぁ', 'ァァァ', 'ァァｧ'
        'ァｧぁ', 'ァｧァ', 'ァｧｧ'
        'ｧぁぁ', 'ｧぁァ', 'ｧぁｧ'
        'ｧァぁ', 'ｧァァ', 'ｧァｧ'
        'ｧｧぁ', 'ｧｧァ', 'ｧｧｧ'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'complex': (test)->
      src = [
        'ァ１'
        'あ1'
        'ぁ2'
        'ｧ２'
        'ぁァｧ０0アaａAＡ'
        'ぁァｧ０0アaａAＡｱ'
        'ぁァｧ０0アaａAＡｱあ'
        'ァｧぁ０0ｱＡａAあaア'
        'ｧァぁ0０あaｱAアＡａ'
        'ｧァぁAaＡ０ａあ0ｱア'
        'ｧぁァＡａAア0aあｱ０'
        'ぁｧァあａ0０aアＡAｱ'
        'ｧぁァあＡ０アa0ａｱA'
        'ァｧぁアaAａあ0ｱ０Ａ'
        'ぁァｧあAａアＡ0ｱ０a'
        'い234'
        'い２３４'
        'イ234'
        'ぃ５'
        'い５'
        'う22'
        'う2２'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

  'web':

    'http://www.atmarkit.co.jp/bbs/phpBB/viewtopic.php?topic=27978&forum=26': (test)->
      src = [
        'こじま'
        'ごとう'
        'こばやし'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()

    'http://www.softvision.co.jp/dbpro/help/guide/jishoord.htm': (test)->
      src = [
        'かっこ'
        'かつご'
        'がっこ'
        'かっこう'
        'かつごう'
        'がっこう'
        'かっこうあざみ'
        'がっこうちゅう'
        'カッコー'
        'かっこく'
      ]
      test.deepEqual sorter.dictionary(_shuffle(src)), src
      test.done()


exports.naturalSort =

  'empty':(test)->
    test.deepEqual sorter.naturalSort(['', '']), ['', '']
    test.done()

  'identical simple':(test)->
    test.deepEqual sorter.naturalSort(['x1', 'x1']), ['x1', 'x1']
    test.done()

  'ordered simple':(test)->
    test.deepEqual sorter.naturalSort(['y', 'x']), ['x', 'y']
    test.done()

  'ordered two gorups':(test)->
    test.deepEqual sorter.naturalSort(['x2', 'x1']), ['x1', 'x2']
    test.done()

  'ordered two gorups separated':(test)->
    test.deepEqual sorter.naturalSort(['x_2', 'x_1']), ['x_1', 'x_2']
    test.done()

  'ordered two gorups separated different distances':(test)->
    test.deepEqual sorter.naturalSort(['x__2', 'x_1']), ['x_1', 'x__2']
    test.done()

  'ordered two gorups separated different distances':(test)->
    test.deepEqual sorter.naturalSort(['x_2', 'x__1']), ['x__1', 'x_2']
    test.done()

###
  'three groups':(test)->
    _testNaturalSort test
      , ['hello 2 world', 'hello world', 'hello world 2']
      , ['hello world', 'hello world 2', 'hello 2 world']

  'test_multiple_string_number':(test)->
    test.deepEqual ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8'], ['x2-y08', 'x8-y8', 'x2-y7', 'x2-g8']

  'test_multiple_string_number_2':(test)->
    test.deepEqual ['x02-g8', 'x2-y7', 'x02-y08', 'x8-y8'], ['x02-y08', 'x8-y8', 'x2-y7', 'x02-g8']

  'test_filename':(test)->
    test.deepEqual ["img1.png", "img2.png", "img10.png", "img12.png"], ["img12.png", "img10.png", "img2.png", "img1.png"]

  'single-byte':

    'number(basic)': (test)->
      src = [
        '123', '132', '213', '231', '312', '321'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'number': (test)->
      src = [
        '0', '00', '000', '1', '01', '001', '10', '010'
        '11', '011', '100', '101', '110', '111'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'number(decimal)': (test)->
      src = [
        '.0', '.00', '0', '00', '000', '0.', '00.', '0.0'
        '1', '01', '001', '0001', '1.', '001.', '1.0', '01.0', '1.00'
        '10', '010', '00010', '10.', '0010.', '10.0', '010.0', '10.00'
        '11', '011', '000000000000000000000000000000000000011', '11.0'
        '100', '101', '109.99999', '110', '0000000110', '110.00001', '111'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'alphabet': (test)->
      src = [
        'A', 'a'
        'AA', 'Aa', 'aA', 'aa'
        'AAA', 'AAa', 'AaA', 'Aaa', 'aAA', 'aAa', 'aaA', 'aaa'
        'ab', 'abc', 'b'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'mixed': (test)->
      src = [
        '0', '1', '1.1'
        'a0', 'a00', 'a000'
        'a1', 'a01', 'a001'
        'a1.1', 'a01.1', 'a001.1'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'filename': (test)->
      src = ['1.txt', '2.txt', '10.txt', '20.txt', '100.txt']
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'version': (test)->
      src = [
        '0.0.1', '0.0.2', '0.0.14'
        '0.3.0', '0.3.00'
        '0.3.1', '0.3.2', '0.3.02', '0.3.3', '0.3.12', '0.3.020', '0.3.21'
        '1.0.0', '1.0.1', '1.0.10', '1.0.100', '1.1.0', '1.001.1', '1.2.0'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

  'web':

    'http://sourcefrog.net/projects/natsort/':

      'raw': (test)->
        src
        src = ['rfc1.txt', 'rfc822.txt', 'rfc2086.txt']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        src = ['a', 'a0', 'a1', 'a1a', 'a1b', 'a2', 'a10', 'a20']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        src = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        src = ['1.001', '1.002', '1.010', '1.02', '1.1', '1.3']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        test.done()

      'multibyte': (test)->
        src = [
          'あーるえふしー1.txt', 'アぁルエフシぃ１.txt'
          'ああるえふしぃ82２.txt', 'ああるえふしぃ8２2.txt', 'ああるえふしぃ８22.txt', 'ああるえふしー822.txt'
          'あーるえふしー2086.txt', 'あーるえふしー208６.txt', 'あーるえふしー20８6.txt', 'あーるえふしー2０86.txt'
          'あーるえふしー２086.txt', 'ぁぃ'
        ]
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        src = ['あ', 'ぁ0', 'ァ1', 'ぁ1ア', 'ァ1い', 'ァ2', 'ぁ10', 'あ20']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        src = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        src = ['1.001', '1.002', '1.010', '1.02', '1.1', '1.3']
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        test.done()

      'complex': (test)->
        src = [
          '1.001', '1.002', '1.010', '1.02', '1.1', '1.3'
          'a', 'a0', 'a1', 'a1a', 'a1b', 'a2', 'a10', 'a20'
          'rfc1.txt', 'rfc822.txt', 'rfc2086.txt'
          'x2-g8', 'x2-y7', 'x2-y08', 'x8-y8'
        ]
        test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
        test.done()

    'http://rubygems.org/gems/naturalsort': (test)->
      src = ['a1', 'a2', 'a11', 'a12','a21']
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      src = ['A', 'a', 'B', 'b', 'C', 'c']
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      src = ['x_1', 'x__2']
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      src = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()

    'http://sourcefrog.net/projects/natsort/example-out.txt': (test)->
      src = [
        '1-2'
        '1-02'
        '1-20'
        '10-20'
        'fred'
        'jane'
        'pic01'
        'pic2'
        'pic02'
        'pic02a'
        'pic3'
        'pic4'
        'pic 4 else'
        'pic 5'
        'pic05'
        'pic 5 '
        'pic 5 something'
        'pic 6'
        'pic   7'
        'pic100'
        'pic100a'
        'pic120'
        'pic121'
        'pic02000'
        'tom'
        'x2-g8'
        'x2-y7'
        'x2-y08'
        'x8-y8'
      ]
      test.deepEqual(arrayutil.naturalSort(_shuffle(src)), src)
      test.done()
###