package pixeldroid.dsa.dlx
{
    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;
    import pixeldroid.dsa.dlx.NodeWalker;


    class Column extends Node
    {
        public var size:Number;
        public var label:Number;

        private var rowList:Vector.<Node> = [];
        private var nodeList:Vector.<Node> = [];

        public function Column(label:Number)
        {
            super(this);

            this.label = label;
            size = 0;
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

            NodeWalker.collect(this, Direction.DOWN, rowList);
            for each(var rowStart:Node in rowList)
            {
                NodeWalker.collect(rowStart, Direction.RIGHT, nodeList);
                for each(var node:Node in nodeList) node.cover();
            }
        }

        public function uncover():void
        {
            NodeWalker.collect(this, Direction.UP, rowList);
            for each(var rowStart:Node in rowList)
            {
                NodeWalker.collect(rowStart, Direction.LEFT, nodeList);
                for each(var node:Node in nodeList) node.uncover();
            }

            right.left = this;
            left.right = this;
        }
    }

}
