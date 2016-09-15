package pixeldroid.dsa.dlx
{
    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;
    import pixeldroid.dsa.dlx.NodeWalker;


    class Column extends Node
    {
        public var size:Number;
        public var label:Number;

        private var coverAction:Function;
        private var uncoverAction:Function;


        public function Column(label:Number)
        {
            super(this);

            this.label = label;
            size = 0;

            coverAction = function (node:Node):void { node.cover(); };
            uncoverAction = function (node:Node):void { node.uncover(); };
        }

        public function addNode():Node
        {
            var bottom:Node = up;
            var newNode:Node = new Node(this);

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

            NodeWalker.apply(this, Direction.DOWN, function (rowStart:Node):void {
                NodeWalker.apply(rowStart, Direction.RIGHT, coverAction);
            });
        }

        public function uncover():void
        {
            NodeWalker.apply(this, Direction.UP, function (rowStart:Node):void {
                NodeWalker.apply(rowStart, Direction.LEFT, uncoverAction);
            });

            right.left = this;
            left.right = this;
        }
    }

}
