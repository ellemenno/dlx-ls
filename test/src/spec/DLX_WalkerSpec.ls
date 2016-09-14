package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.DLX_Direction;
    import pixeldroid.dsa.DLX_Node;
    import pixeldroid.dsa.DLX_Walker;

    public static class DLX_WalkerSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('DLX_Walker');

            var list:Vector.<DLX_Node> = [];

            it.should('not collect the start node', function() {
                var a:DLX_Node = new DLX_Node(null);
                var b:DLX_Node = new DLX_Node(null);
                var c:DLX_Node = new DLX_Node(null);

                a.right = b;
                b.right = c;
                c.right = a;

                DLX_Walker.collect(a, DLX_Direction.RIGHT, list);
                it.expects(list).not.toContain(a);
            });

            it.should('collect connected nodes in a given direction', function() {
                var a:DLX_Node = new DLX_Node(null);
                var a1:DLX_Node = new DLX_Node(null);
                var a2:DLX_Node = new DLX_Node(null);
                var b:DLX_Node = new DLX_Node(null);
                var c:DLX_Node = new DLX_Node(null);
                var d:DLX_Node = new DLX_Node(null);

                DLX_Walker.collect(d, DLX_Direction.RIGHT, list);
                it.expects(list.length).toEqual(0);

                DLX_Walker.collect(d, DLX_Direction.UP, list);
                it.expects(list.length).toEqual(0);

                DLX_Walker.collect(d, DLX_Direction.LEFT, list);
                it.expects(list.length).toEqual(0);

                DLX_Walker.collect(d, DLX_Direction.DOWN, list);
                it.expects(list.length).toEqual(0);

                a.right = a1; a1.right = a2; a2.right = a;
                a.left = a2; a2.left = a1; a1.left = a;

                a.down = b; a.up = d;
                b.down = c; b.up = a;
                c.down = d; c.up = b;
                d.down = a; d.up = c;

                DLX_Walker.collect(a, DLX_Direction.RIGHT, list);
                it.expects(list.length).toEqual(2);
                it.expects(list[0]).toEqual(a1);
                it.expects(list[1]).toEqual(a2);

                DLX_Walker.collect(a, DLX_Direction.LEFT, list);
                it.expects(list.length).toEqual(2);
                it.expects(list[0]).toEqual(a2);
                it.expects(list[1]).toEqual(a1);

                DLX_Walker.collect(b, DLX_Direction.UP, list);
                it.expects(list.length).toEqual(3);
                it.expects(list[0]).toEqual(a);
                it.expects(list[1]).toEqual(d);
                it.expects(list[2]).toEqual(c);

                DLX_Walker.collect(d, DLX_Direction.DOWN, list);
                it.expects(list.length).toEqual(3);
                it.expects(list[0]).toEqual(a);
                it.expects(list[1]).toEqual(b);
                it.expects(list[2]).toEqual(c);
            });
        }
    }
}
