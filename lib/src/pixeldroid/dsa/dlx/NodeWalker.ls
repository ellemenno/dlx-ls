package pixeldroid.dsa.dlx
{
    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;


    class NodeWalker
    {
        static public function collect(start:Node, direction:Direction, list:Vector.<Node>):void
        {
            list.clear();
            var node:Node = start;

            switch(direction)
            {
                case Direction.LEFT:  while ((node = node.left)  != start) { list.push(node); } break;
                case Direction.RIGHT: while ((node = node.right) != start) { list.push(node); } break;
                case Direction.UP:    while ((node = node.up)    != start) { list.push(node); } break;
                case Direction.DOWN:  while ((node = node.down)  != start) { list.push(node); } break;
            }
        }
    }

}
