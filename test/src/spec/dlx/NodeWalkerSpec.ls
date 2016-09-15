package dlx
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.dlx.Direction;
    import pixeldroid.dsa.dlx.Node;
    import pixeldroid.dsa.dlx.NodeWalker;


    public static class NodeWalkerSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('dlx.NodeWalker');

            var list:Vector.<Node> = [];

            it.should('not collect the start node', function() {
                var a:Node = new Node(null);
                var b:Node = new Node(null);
                var c:Node = new Node(null);

                a.right = b;
                b.right = c;
                c.right = a;

                NodeWalker.collect(a, Direction.RIGHT, list);
                it.expects(list).not.toContain(a);
            });

            it.should('collect nodes connected in a given direction', function() {
                var a:Node = new Node(null);
                var a1:Node = new Node(null);
                var a2:Node = new Node(null);
                var b:Node = new Node(null);
                var c:Node = new Node(null);
                var d:Node = new Node(null);

                NodeWalker.collect(d, Direction.RIGHT, list);
                it.expects(list.length).toEqual(0);

                NodeWalker.collect(d, Direction.UP, list);
                it.expects(list.length).toEqual(0);

                NodeWalker.collect(d, Direction.LEFT, list);
                it.expects(list.length).toEqual(0);

                NodeWalker.collect(d, Direction.DOWN, list);
                it.expects(list.length).toEqual(0);

                a.right = a1; a1.right = a2; a2.right = a;
                a.left = a2; a2.left = a1; a1.left = a;

                a.down = b; a.up = d;
                b.down = c; b.up = a;
                c.down = d; c.up = b;
                d.down = a; d.up = c;

                NodeWalker.collect(a, Direction.RIGHT, list);
                it.expects(list.length).toEqual(2);
                it.expects(list[0]).toEqual(a1);
                it.expects(list[1]).toEqual(a2);

                NodeWalker.collect(a, Direction.LEFT, list);
                it.expects(list.length).toEqual(2);
                it.expects(list[0]).toEqual(a2);
                it.expects(list[1]).toEqual(a1);

                NodeWalker.collect(b, Direction.UP, list);
                it.expects(list.length).toEqual(3);
                it.expects(list[0]).toEqual(a);
                it.expects(list[1]).toEqual(d);
                it.expects(list[2]).toEqual(c);

                NodeWalker.collect(d, Direction.DOWN, list);
                it.expects(list.length).toEqual(3);
                it.expects(list[0]).toEqual(a);
                it.expects(list[1]).toEqual(b);
                it.expects(list[2]).toEqual(c);
            });

            it.should('act on nodes connected in a given direction', function() {
                var a:TestNode = new TestNode();
                var b:TestNode = new TestNode();
                var c:TestNode = new TestNode();
                var d:TestNode = new TestNode();

                a.down = b; b.up = a;
                b.down = c; c.up = b;
                c.down = a; a.up = c;
                c.left = d; d.right = c;

                var action:Function = function(node:Node) { node.cover(); node.uncover(); };

                NodeWalker.apply(a, Direction.DOWN, action);
                it.expects(a.touched).not.toBeTruthy();
                it.expects(b.touched).toBeTruthy();
                it.expects(c.touched).toBeTruthy();
                it.expects(d.touched).not.toBeTruthy();
            });
        }
    }

    class TestNode extends Node
    {
        public var touched:Boolean = false;
        public function TestNode() { super(null); }
        override public function cover():void { touched = true; }
    }
}
