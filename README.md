# SorterJS

Dictionary and natural sort module for Node.js, RequireJS and browser.

## Installation

### Node.js

    $ npm install sorter

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

* **dictionarySort(array, key = null)** -
* **naturalSort(array, key = null)** -