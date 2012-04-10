# Sorter

Dictionary and natural sort module for Node.js, RequireJS and browser.
Supports 2 bytes character in English and Japanese.

## Installation at Node.js

    $ npm install sorter

## Adding to browser

### RequireJS

    <script type="text/javascript" src="require.js"></script>
    <script type="text/javascript">
      require(['sorter'], function (sorter) {
        var dictionarySort = sorter.dictionarySort;
        var naturalSort = sorter.naturalSort;
      });
    </script>

### browser

    <script type="text/javascript" src="sorter.js"></script>
    <script>
      var dictionarySort = window.mn.dsk.sorter.dictionarySort;
      var naturalSort = window.mn.dsk.sorter.naturalSort;
    </script>

## API Documentation

* **dictSort(array, key = null)** -
* **natSort(array, key = null)** -