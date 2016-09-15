package pixeldroid.dsa
{
    import pixeldroid.dsa.dlx.AsciiRenderer;
    import pixeldroid.dsa.dlx.Column;
    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;
    import pixeldroid.dsa.dlx.NodeWalker;

    /**
    A constraint table that uses Knuth's dancing links to implement algorithm x to find solutions.
    */
    public class DLX
    {
        public static const version:String = '0.0.1';

        public var solutions:Vector.<Vector.<Number>>;
        //                          |       '-row--'|
        //                          '----solution---'

        private var numRows:Number;
        private var root:Column;
        private var searchResult:Vector.<Node>;


        public function DLX(numColumns:Number=0)
        {
            numRows = 0;
            root = new Column(0);
            searchResult = [];
            solutions = [];

            setColumns(numColumns);
        }

        public function addRow(rowList:Vector.<Number>):void
        {
            var addedNodes:Vector.<Node> = [];
            var columnList:Vector.<Column> = [];
            var i:Number;

            NodeWalker.collect(root, Direction.RIGHT, columnList);
            for each(var column:Column in columnList)
            {
                i = rowList.indexOf(column.label);
                if (i > -1) addedNodes.push(column.addNode());
            }

            var w:Number = addedNodes.length;
            for (i in addedNodes) {
                var node:Node = addedNodes[i];
                var rightIndex:Number = (i+1) % w;
                var leftIndex:Number  = (i-1); if (leftIndex < 0) leftIndex += w;
                node.right = addedNodes[rightIndex];
                node.left  = addedNodes[leftIndex];
                node.row   = numRows + 1;
            }

            numRows++;
        }

        public function getColumn(index:Number):Column
        {
            if (index < 0) return null;
            if (index == 0) return root;

            var i:Number = 0;
            var column:Column = root;
            while ((column = (column.right as Column)) != root)
            {
                i++;
                if (i == index) return column;
            }

            return null;
        }

        public function get height():Number { return numRows; }

        public function get width():Number
        {
            var w:Number = 0;
            var node:Node = root;

            while ((node = node.right) != root) { w++; }

            return w;
        }

        public function solve():void { search(0); }

        public function toString():String
        {
            return AsciiRenderer.render(this);
        }


        private function findSmallestColumn():Column
        {
            var column:Column = root.right.column;
            if (column == root) return null;

            var columnList:Vector.<Column> = [];
            var smallest:Number = column.size;

            NodeWalker.collect(root, Direction.RIGHT, columnList);
            for each(var candidate:Column in columnList)
            {
                if (candidate.size <= smallest)
                {
                    column = candidate;
                    smallest = candidate.size;
                }
            }

            return column;
        }

        private function search(index:Number):void
        {
            var column:Column = findSmallestColumn();
            if (column == null)
            {
                storeSolution();
                return;
            }

            column.cover();

            while (searchResult.length <= index) searchResult.push(null);
            var rowList:Vector.<Node> = [];
            var nodeList:Vector.<Node> = [];
            var node:Node;

            NodeWalker.collect(column, Direction.DOWN, rowList);
            for each(var rowStart:Node in rowList)
            {
                searchResult[index] = rowStart;
                NodeWalker.collect(rowStart, Direction.RIGHT, nodeList);
                for each(node in nodeList) node.column.cover();

                search(index + 1);

                rowStart = searchResult[index];
                NodeWalker.collect(rowStart, Direction.LEFT, nodeList);
                for each(node in nodeList) node.column.uncover();
            }

            column.uncover();
        }

        private function setColumns(numColumns:Number):void
        {
            var node:Node = root;
            for (var i:Number = 0; i < numColumns; i++)
            {
                node.right = new Column(i+1) as Node;
                node.right.left = node;
                node = node.right;
            }

            node.right = root;
            root.left = node;
        }

        private function storeSolution():void
        {
            var answer:Vector.<Number> = []; // a set of rows that provide perfect coverage
            for each(var rowStart:Node in searchResult) answer.push(rowStart.row);
            answer.sort(Vector.NUMERIC);
            solutions.push(answer);
        }

    }

}
