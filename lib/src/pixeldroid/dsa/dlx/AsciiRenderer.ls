package pixeldroid.dsa.dlx
{
    import pixeldroid.dsa.DLX;
    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;
    import pixeldroid.dsa.dlx.NodeWalker;


    class AsciiRenderer
    {
        static public function render(dlx:DLX, rowsToShow:Vector.<Number> = []):String
        {
            var root:Column = dlx.getColumn(0);
            var numRows:Number = dlx.height;

            var matrix:Vector.<Vector.<String>> = [];
            var lines:Vector.<String> = [];
            var line:Vector.<String> = [];
            var columnList:Vector.<Column> = [];
            var rowList:Vector.<Node> = [];
            var row:Number;
            var empty:Boolean;

            NodeWalker.collect(root, Direction.RIGHT, columnList);
            for each(var columnStart:Column in columnList)
            {
                line.push(String.lpad(columnStart.label.toString(), '0', 3));

                var column:Vector.<Boolean> = [];
                for (row = 1; row <= numRows; row++) column.push(false);

                NodeWalker.collect(columnStart, Direction.DOWN, rowList);
                for each(var node:Node in rowList) column[node.row-1] = true;

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

}
