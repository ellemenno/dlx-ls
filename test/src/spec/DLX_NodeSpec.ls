package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.DLX_Column;
    import pixeldroid.dsa.DLX_Node;

    public static class DLX_NodeSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('DLX_Node');

            it.should('disconnect from the node chain when covered and reconnect when uncovered', function() {
                var col:DLX_Column = new DLX_Column(0);
                var a:DLX_Node = col.addNode();
                var b:DLX_Node = col.addNode();
                var c:DLX_Node = col.addNode();

                it.expects(a.down).toEqual(b);
                it.expects(c.up).toEqual(b);

                b.cover();

                it.expects(a.down).toEqual(c);
                it.expects(c.up).toEqual(a);

                b.uncover();

                it.expects(a.down).toEqual(b);
                it.expects(c.up).toEqual(b);
            });

            it.should('change its column\'s size when covered and uncovered', function() {
                var col:DLX_Column = new DLX_Column(0);
                it.expects(col.size).toEqual(0);

                var a:DLX_Node = col.addNode();
                var b:DLX_Node = col.addNode();
                var c:DLX_Node = col.addNode();
                it.expects(col.size).toEqual(3);

                b.cover();
                it.expects(col.size).toEqual(2);

                b.uncover();
                it.expects(col.size).toEqual(3);
            });
        }
    }
}
