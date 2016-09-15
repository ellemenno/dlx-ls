package dlx
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.DLX;
    import pixeldroid.dsa.dlx.Column;
    import pixeldroid.dsa.dlx.Node;


    public static class ColumnSpec
    {
        private static function getSampleMatrix():DLX
        {
            var dlx:DLX = new DLX(7);

            dlx.addRow([3, 5, 6]);  // 1 *
            dlx.addRow([1, 4, 7]);  // 2
            dlx.addRow([2, 3, 6]);  // 3
            dlx.addRow([1, 4]);     // 4 *
            dlx.addRow([2, 7]);     // 5 *
            dlx.addRow([4, 5, 7]);  // 6

            return dlx;
        }

        private static const sampleMatrixRender:Vector.<String> = [
            '___|001|002|003|004|005|006|007|',
            '001|   |   | x |   | x | x |   |',
            '002| x |   |   | x |   |   | x |',
            '003|   | x | x |   |   | x |   |',
            '004| x |   |   | x |   |   |   |',
            '005|   | x |   |   |   |   | x |',
            '006|   |   |   | x | x |   | x |'
        ];

        public static function describe():void
        {
            var it:Thing = Spec.describe('dlx.Column');

            it.should('provide a label', function() {
                var label:Number = 3;
                var col:Column = new Column(label);
                it.expects(col.label).toEqual(label);
            });

            it.should('track its size', function() {
                var col:Column = new Column(0);
                it.expects(col.size).toEqual(0);

                col.addNode();
                it.expects(col.size).toEqual(1);

                col.addNode();
                col.addNode();
                it.expects(col.size).toEqual(3);
            });

            it.should('add nodes doubly linked up and down', function() {
                var col:Column = new Column(0);
                var a:Node = col.addNode();
                var b:Node = col.addNode();
                var c:Node = col.addNode();

                it.expects(a.up).toEqual(col);
                it.expects(a.down).toEqual(b);
                it.expects(b.up).toEqual(a);
                it.expects(b.down).toEqual(c);
                it.expects(c.up).toEqual(b);
                it.expects(c.down).toEqual(col);
            });

            it.should('hide and unhide itself and its linked rows when covered and uncovered', function() {
                var dlx:DLX = getSampleMatrix();
                var c3:Column = dlx.getColumn(3);
                var covered3:Vector.<String> = [
                '___|001|002|004|005|006|007|',
                '002| x |   | x |   |   | x |',
                '004| x |   | x |   |   |   |',
                '005|   | x |   |   |   | x |',
                '006|   |   | x | x |   | x |'
                ];

                it.expects(dlx.width).toEqual(7);
                it.expects(dlx.toString()).toEqual(sampleMatrixRender.join('\n'));

                c3.cover();
                it.expects(dlx.width).toEqual(6);
                it.expects(dlx.toString()).toEqual(covered3.join('\n'));

                c3.uncover();
                it.expects(dlx.width).toEqual(7);
                it.expects(dlx.toString()).toEqual(sampleMatrixRender.join('\n'));
            });
        }
    }
}
