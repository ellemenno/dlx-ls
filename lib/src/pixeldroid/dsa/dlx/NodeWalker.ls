package pixeldroid.dsa.dlx
{
    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;


    class NodeWalker
    {
        static public function collect(start:Node, direction:Direction, list:Vector.<Node>):void
        {
            list.clear();
            apply(start, direction, function (node:Node):void { list.push(node); });
        }

        static public function apply(start:Node, direction:Direction, action:Function):void
        {
            var node:Node = start;

            switch(direction)
            {
                case Direction.LEFT:  while ((node = node.left)  != start) { action(node); } break;
                case Direction.RIGHT: while ((node = node.right) != start) { action(node); } break;
                case Direction.UP:    while ((node = node.up)    != start) { action(node); } break;
                case Direction.DOWN:  while ((node = node.down)  != start) { action(node); } break;
            }
        }
    }

}
