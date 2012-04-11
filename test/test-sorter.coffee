sorter = require '../lib/node/sorter'
_ = require 'underscore'

exports.dictSort =

  'single-byte':

    'empty':(test)->
      test.deepEqual sorter.dictSort(['', '']), ['', '']
      test.done()

    'same':(test)->
      test.deepEqual sorter.dictSort(['x', 'x']), ['x', 'x']
      test.done()

    'simple':(test)->
      test.deepEqual sorter.dictSort(['y', 'x']), ['x', 'y']
      test.done()

    'number(basic)': (test)->
      arr = [
        '123', '132', '213', '231', '312', '321'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'number': (test)->
      arr = [
        '0', '00', '000', '001', '01', '010', '011'
        '1', '10', '100', '101', '11', '110', '111'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'alphabet': (test)->
      arr = [
        'A', 'a'
        'AA', 'Aa', 'aA', 'aa'
        'AAA', 'AAa', 'AaA', 'Aaa', 'aAA', 'aAa', 'aaA', 'aaa'
        'ab', 'abc', 'b'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'mixed': (test)->
      arr = [
        'A10B1', 'A10B10', 'A10B2', 'A1B1', 'A1B10', 'A1B2'
        'A2B1', 'A2B10', 'A2B2'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'filename': (test)->
      arr = [
        '1.txt', '10.txt', '100.txt'
        '2.txt', '20.txt'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'readme': (test)->
      arr = ['AD', 'after', 'AM', 'BC', 'before', 'PM']
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

  'multibyte':

    'number': (test)->
      arr = [
        '000', '00０', '0０0', '0００'
        '０00', '０0０', '００0', '０００'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'alphabet': (test)->
      arr = [
        'AＡaａ', 'AＡａa', 'AaＡａ', 'AaａＡ', 'AａＡa', 'AａaＡ'
        'ＡAaａ', 'ＡAａa', 'ＡaAａ', 'ＡaａA', 'ＡａAa', 'ＡａaA'
        'aAＡａ', 'aAａＡ', 'aＡAａ', 'aＡａA', 'aａAＡ', 'aａＡA'
        'ａAＡa', 'ａAaＡ', 'ａＡAa', 'ａＡaA', 'ａaAＡ', 'ａaＡA'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'japanese aiueo': (test)->
      arr = [
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
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'japanese a': (test)->
      arr = [
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
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'complex': (test)->
      arr = [
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
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

  'web':

    'http://www.atmarkit.co.jp/bbs/phpBB/viewtopic.php?topic=27978&forum=26': (test)->
      arr = [
        'こじま'
        'ごとう'
        'こばやし'
      ]
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

    'http://www.softvision.co.jp/dbpro/help/guide/jishoord.htm': (test)->
      arr = [
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
      test.deepEqual sorter.dictSort(_.shuffle(arr)), arr
      test.done()

exports.natSort =

  'single byte':

    'empty':(test)->
      test.deepEqual sorter.natSort(['', '']), ['', '']
      test.done()

    'same':(test)->
      test.deepEqual sorter.natSort(['x', 'x']), ['x', 'x']
      test.done()

    'simple':(test)->
      test.deepEqual sorter.natSort(['y', 'x']), ['x', 'y']
      test.done()

    'ordered two gorups':(test)->
      test.deepEqual sorter.natSort(['x2', 'x1']), ['x1', 'x2']
      test.done()

    'ordered two gorups separated':(test)->
      test.deepEqual sorter.natSort(['x_2', 'x_1']), ['x_1', 'x_2']
      test.done()

    'ordered two gorups separated different distances':(test)->
      test.deepEqual sorter.natSort(['x_10', 'x_5']), ['x_5', 'x_10']
      test.done()

  'php':

    'negative numbers': (test)->
      arr = ['-2', '-5', '-1000','0','1','3','9']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    'zero padding': (test)->
      arr = ['0', '8', '009', '09', '10', '011']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    'filename starts with number': (test)->
      arr = ['1.txt', '2.txt', '10.txt', '20.txt', '100.txt']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    'filename contains number':(test)->
      arr = ['img1.png', 'img2.png', 'img10.png', 'img12.png']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()
      
  'sourcefrog.net':

    'rfc':(test)->
      arr = ['rfc1.txt', 'rfc822.txt', 'rfc2086.txt']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    '1':(test)->
      arr = ['a', 'a0', 'a1', 'a1a', 'a1b', 'a2', 'a10', 'a20']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    '2':(test)->
      arr = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    'decimal':(test)->
      arr = ['1.001', '1.1', '1.002', '1.02', '1.3', '1.010']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

    'readme': (test)->
      arr = ['image_1.jpg', 'image_04.jpg', 'image_4.jpg', 'image_005.jpg', 'image_12.jpg', 'image_21.jpg']
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()

###
    'version': (test)->
      arr = [
        '0.0.1', '0.0.2', '0.0.14'
        '0.3.0', '0.3.00'
        '0.3.1', '0.3.2', '0.3.02', '0.3.3', '0.3.12', '0.3.020', '0.3.21'
        '1.0.0', '1.0.1', '1.0.10', '1.0.100', '1.1.0', '1.001.1', '1.2.0'
      ]
      test.deepEqual sorter.natSort(_.shuffle(arr)), arr
      test.done()
  'web':

    'http://sourcefrog.net/projects/natsort/':

      'raw': (test)->
        arr
        arr = ['rfc1.txt', 'rfc822.txt', 'rfc2086.txt']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        arr = ['a', 'a0', 'a1', 'a1a', 'a1b', 'a2', 'a10', 'a20']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        arr = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        arr = ['1.001', '1.002', '1.010', '1.02', '1.1', '1.3']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        test.done()

      'multibyte': (test)->
        arr = [
          'あーるえふしー1.txt', 'アぁルエフシぃ１.txt'
          'ああるえふしぃ82２.txt', 'ああるえふしぃ8２2.txt', 'ああるえふしぃ８22.txt', 'ああるえふしー822.txt'
          'あーるえふしー2086.txt', 'あーるえふしー208６.txt', 'あーるえふしー20８6.txt', 'あーるえふしー2０86.txt'
          'あーるえふしー２086.txt', 'ぁぃ'
        ]
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        arr = ['あ', 'ぁ0', 'ァ1', 'ぁ1ア', 'ァ1い', 'ァ2', 'ぁ10', 'あ20']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        arr = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        arr = ['1.001', '1.002', '1.010', '1.02', '1.1', '1.3']
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        test.done()

      'complex': (test)->
        arr = [
          '1.001', '1.002', '1.010', '1.02', '1.1', '1.3'
          'a', 'a0', 'a1', 'a1a', 'a1b', 'a2', 'a10', 'a20'
          'rfc1.txt', 'rfc822.txt', 'rfc2086.txt'
          'x2-g8', 'x2-y7', 'x2-y08', 'x8-y8'
        ]
        test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
        test.done()

    'http://rubygems.org/gems/naturalsort': (test)->
      arr = ['a1', 'a2', 'a11', 'a12','a21']
      test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
      arr = ['A', 'a', 'B', 'b', 'C', 'c']
      test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
      arr = ['x_1', 'x__2']
      test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
      arr = ['x2-g8', 'x2-y7', 'x2-y08', 'x8-y8']
      test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
      test.done()

    'http://sourcefrog.net/projects/natsort/example-out.txt': (test)->
      arr = [
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
      test.deepEqual(sorter.natSort(__.shuffle(arr)), arr)
      test.done()
###