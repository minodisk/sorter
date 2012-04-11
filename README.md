# Sorter

Dictionary and natural sort module for Node.js, RequireJS and browser.

## Installation at Node.js

    $ npm install sorter

## Adding to browser

### browser

    <script type="text/javascript" src="sorter.js"></script>
    <script>
      var dictionarySort = window.mn.dsk.sorter.dictionarySort;
      var naturalSort = window.mn.dsk.sorter.naturalSort;
    </script>

### RequireJS

    <script type="text/javascript" src="require.js"></script>
    <script type="text/javascript">
      require(['sorter'], function (sorter) {
        var dictionarySort = sorter.dictionarySort;
        var naturalSort = sorter.naturalSort;
      });
    </script>

## API Documentation

* **dictSort(array\[, key\])** - Returns natural ordered array.
* **natSort(array\[, key\])** - Returns dictionary ordered array.

## Dictionary Sort

Array#sort()

    AD
    AM
    BC
    PM
    after
    before

sorter.dictSort()

    AD
    after
    AM
    BC
    before
    PM

## Natural Sort

Array#sort()

    image_005.jpg
    image_04.jpg
    image_1.jpg
    image_12.jpg
    image_21.jpg
    image_4.jpg

sorter.natSort()

    image_1.jpg
    image_04.jpg
    image_4.jpg
    image_005.jpg
    image_12.jpg
    image_21.jpg
