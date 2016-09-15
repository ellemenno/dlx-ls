package dlx
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.dlx.Column;
    import pixeldroid.dsa.dlx.Node;


    public static class NodeSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('dlx.Node');

            it.should('disconnect from the node chain when covered and reconnect when uncovered', function() {
                var col:Column = new Column(0);
                var a:Node = col.addNode();
                var b:Node = col.addNode();
                var c:Node = col.addNode();

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
                var col:Column = new Column(0);
                it.expects(col.size).toEqual(0);

                var a:Node = col.addNode();
                var b:Node = col.addNode();
                var c:Node = col.addNode();
                it.expects(col.size).toEqual(3);

                b.cover();
                it.expects(col.size).toEqual(2);

                b.uncover();
                it.expects(col.size).toEqual(3);
            });
        }
    }
}
