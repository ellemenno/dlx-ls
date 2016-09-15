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

            var column:Vector.<Boolean>;
            var row:Number;
            var rowMarking:Function = function (node:Node):void { column[node.row-1] = true; };
            var empty:Boolean;

            NodeWalker.apply(root, Direction.RIGHT, function (columnStart:Column):void {
                line.push(String.lpad(columnStart.label.toString(), '0', 3));

                column = [];
                for (row = 1; row <= numRows; row++) column.push(false);
                NodeWalker.apply(columnStart, Direction.DOWN, rowMarking);

                matrix.push(column);
            });

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
