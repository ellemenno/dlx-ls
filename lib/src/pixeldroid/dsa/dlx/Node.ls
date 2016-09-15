package pixeldroid.dsa.dlx
{
    import pixeldroid.dsa.dlx.Column;

    class Node
    {
        public var left:Node;
        public var right:Node;
        public var up:Node;
        public var down:Node;

        public var column:Column;
        public var row:Number = 0;


        public function Node(column:Column)
        {
            left = right = up = down = this;
            this.column = column;
        }

        public function cover():void
        {
            up.down = down;
            down.up = up;

            if (column) column.size -= 1;
        }

        public function uncover():void
        {
            up.down = this;
            down.up = this;

            if (column) column.size += 1;
        }

        public function toString():String
        {
            var col:String = column ? column.label.toString() : '-';
            return '[' +col +',' +row +']'; }
    }

}
