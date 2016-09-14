package pixeldroid.dsa
{
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
        private var root:DLX_Column;
        private var searchResult:Vector.<DLX_Node>;

        public function DLX(numColumns:Number=0)
        {
            numRows = 0;
            root = new DLX_Column(0);
            searchResult = [];
            solutions = [];

            setColumns(numColumns);
        }

        public function addRow(rowList:Vector.<Number>):void
        {
            var addedNodes:Vector.<DLX_Node> = [];
            var columnList:Vector.<DLX_Column> = [];
            var i:Number;

            DLX_Walker.collect(root, DLX_Direction.RIGHT, columnList);
            for each(var column:DLX_Column in columnList)
            {
                i = rowList.indexOf(column.label);
                if (i > -1) addedNodes.push(column.addNode());
            }

            var w:Number = addedNodes.length;
            for (i in addedNodes) {
                var node:DLX_Node = addedNodes[i];
                var rightIndex:Number = (i+1) % w;
                var leftIndex:Number  = (i-1); if (leftIndex < 0) leftIndex += w;
                node.right = addedNodes[rightIndex];
                node.left  = addedNodes[leftIndex];
                node.row   = numRows + 1;
            }

            numRows++;
        }

        public function getColumn(index:Number):DLX_Column
        {
            if (index < 0) return null;
            if (index == 0) return root;

            var i:Number = 0;
            var column:DLX_Column = root;
            while ((column = (column.right as DLX_Column)) != root)
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
            var node:DLX_Node = root;

            while ((node = node.right) != root) { w++; }

            return w;
        }

        public function solve():void { search(0); }

        public function toString():String
        {
            return DLX_AsciiRenderer.render(this);
        }


        private function findSmallestColumn():DLX_Column
        {
            var column:DLX_Column = root.right.column;
            if (column == root) return null;

            var columnList:Vector.<DLX_Column> = [];
            var smallest:Number = column.size;

            DLX_Walker.collect(root, DLX_Direction.RIGHT, columnList);
            for each(var candidate:DLX_Column in columnList)
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
            var column:DLX_Column = findSmallestColumn();
            if (column == null)
            {
                storeSolution();
                return;
            }

            column.cover();

            while (searchResult.length <= index) searchResult.push(null);
            var rowList:Vector.<DLX_Node> = [];
            var nodeList:Vector.<DLX_Node> = [];
            var node:DLX_Node;

            DLX_Walker.collect(column, DLX_Direction.DOWN, rowList);
            for each(var rowStart:DLX_Node in rowList)
            {
                searchResult[index] = rowStart;
                DLX_Walker.collect(rowStart, DLX_Direction.RIGHT, nodeList);
                for each(node in nodeList) node.column.cover();

                search(index + 1);

                rowStart = searchResult[index];
                DLX_Walker.collect(rowStart, DLX_Direction.LEFT, nodeList);
                for each(node in nodeList) node.column.uncover();
            }

            column.uncover();
        }

        private function setColumns(numColumns:Number):void
        {
            var node:DLX_Node = root;
            for (var i:Number = 0; i < numColumns; i++)
            {
                node.right = new DLX_Column(i+1) as DLX_Node;
                node.right.left = node;
                node = node.right;
            }

            node.right = root;
            root.left = node;
        }

        private function storeSolution():void
        {
            var answer:Vector.<Number> = []; // a set of rows that provide perfect coverage
            for each(var rowStart:DLX_Node in searchResult) answer.push(rowStart.row);
            answer.sort(Vector.NUMERIC);
            solutions.push(answer);
        }

    }

    class DLX_Direction
    {
        static public const LEFT:DLX_Direction = new DLX_Direction('LEFT');
        static public const RIGHT:DLX_Direction = new DLX_Direction('RIGHT');
        static public const UP:DLX_Direction = new DLX_Direction('UP');
        static public const DOWN:DLX_Direction = new DLX_Direction('DOWN');

        private var label:String;

        public function DLX_Direction(label:String)
        {
            this.label = label;
        }

        public function toString():String { return label; }
    }

    class DLX_Node
    {
        public var left:DLX_Node;
        public var right:DLX_Node;
        public var up:DLX_Node;
        public var down:DLX_Node;

        public var column:DLX_Column;
        public var row:Number = 0;


        public function DLX_Node(column:DLX_Column)
        {
            left = right = up = down = this;
            this.column = column;
        }

        public function cover():void
        {
            up.down = down;
            down.up = up;

            column.size -= 1;
        }

        public function uncover():void
        {
            up.down = this;
            down.up = this;

            column.size += 1;
        }

        public function toString():String
        {
            var col:String = column ? column.label.toString() : '-';
            return '[' +col +',' +row +']'; }
    }

    class DLX_Column extends DLX_Node
    {
        public var size:Number;
        public var label:Number;

        private var rowList:Vector.<DLX_Node> = [];
        private var nodeList:Vector.<DLX_Node> = [];

        public function DLX_Column(label:Number)
        {
            super(this);

            this.label = label;
            size = 0;
        }

        public function addNode():DLX_Node
        {
            var bottom:DLX_Node = up;
            var newNode:DLX_Node = new DLX_Node(this);

            bottom.down = newNode;
            newNode.up = bottom;
            newNode.down = this;
            up = newNode;

            size += 1;

            return newNode;
        }

        public function cover():void
        {
            right.left = left;
            left.right = right;

            DLX_Walker.collect(this, DLX_Direction.DOWN, rowList);
            for each(var rowStart:DLX_Node in rowList)
            {
                DLX_Walker.collect(rowStart, DLX_Direction.RIGHT, nodeList);
                for each(var node:DLX_Node in nodeList) node.cover();
            }
        }

        public function uncover():void
        {
            DLX_Walker.collect(this, DLX_Direction.UP, rowList);
            for each(var rowStart:DLX_Node in rowList)
            {
                DLX_Walker.collect(rowStart, DLX_Direction.LEFT, nodeList);
                for each(var node:DLX_Node in nodeList) node.uncover();
            }

            right.left = this;
            left.right = this;
        }
    }

    class DLX_AsciiRenderer
    {
        static public function render(dlx:DLX, rowsToShow:Vector.<Number> = []):String
        {
            var root:DLX_Column = dlx.getColumn(0);
            var numRows:Number = dlx.height;

            var matrix:Vector.<Vector.<String>> = [];
            var lines:Vector.<String> = [];
            var line:Vector.<String> = [];
            var columnList:Vector.<DLX_Column> = [];
            var rowList:Vector.<DLX_Node> = [];
            var row:Number;
            var empty:Boolean;

            DLX_Walker.collect(root, DLX_Direction.RIGHT, columnList);
            for each(var columnStart:DLX_Column in columnList)
            {
                line.push(String.lpad(columnStart.label.toString(), '0', 3));

                var column:Vector.<Boolean> = [];
                for (row = 1; row <= numRows; row++) column.push(false);

                DLX_Walker.collect(columnStart, DLX_Direction.DOWN, rowList);
                for each(var node:DLX_Node in rowList) column[node.row-1] = true;

                matrix.push(column);
            }
            lines.push('___|' + line.join('|') + '|');

            for (row = 1; row <= numRows; row++)
            {
                if (rowsToShow.length > 0 && rowsToShow.indexOf(row) == -1) continue;

                line.clear();
                empty = true;
                for each(column in matrix)
                {
                    if (column[row-1])
                    {
                        line.push('x');
                        empty = false;
                    }
                    else line.push(' ');
                }
                if (empty) continue;

                lines.push(String.lpad(row.toString(), '0', 3) +'| ' + line.join(' | ') + ' |');
            }

            var s:String = lines.join('\n');
            return s;
        }
    }

    class DLX_Walker
    {
        static public function collect(start:DLX_Node, direction:DLX_Direction, list:Vector.<DLX_Node>):void
        {
            list.clear();
            var node:DLX_Node = start;

            switch(direction)
            {
                case DLX_Direction.LEFT:  while ((node = node.left)  != start) { list.push(node); } break;
                case DLX_Direction.RIGHT: while ((node = node.right) != start) { list.push(node); } break;
                case DLX_Direction.UP:    while ((node = node.up)    != start) { list.push(node); } break;
                case DLX_Direction.DOWN:  while ((node = node.down)  != start) { list.push(node); } break;
            }
        }
    }

}
