package dlx
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.DLX;
    import pixeldroid.dsa.dlx.AsciiRenderer;
    import pixeldroid.dsa.dlx.Column;


    public static class AsciiRendererSpec
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

        public static function describe():void
        {
            var it:Thing = Spec.describe('dlx.AsciiRenderer');

            it.should('provide a human-readable string rendering', function() {
                var dlx:DLX = getSampleMatrix();
                var result:Vector.<String> = [
                '___|001|002|003|004|005|006|007|',
                '001|   |   | x |   | x | x |   |',
                '002| x |   |   | x |   |   | x |',
                '003|   | x | x |   |   | x |   |',
                '004| x |   |   | x |   |   |   |',
                '005|   | x |   |   |   |   | x |',
                '006|   |   |   | x | x |   | x |'
                ];

                it.expects(dlx.toString()).toEqual(result.join('\n'));
            });

            it.should('skip empty columns and rows', function() {
                var dlx:DLX = getSampleMatrix();
                var c3:Column = dlx.getColumn(3);
                var result:Vector.<String> = [
                '___|001|002|004|005|006|007|',
                '002| x |   | x |   |   | x |',
                '004| x |   | x |   |   |   |',
                '005|   | x |   |   |   | x |',
                '006|   |   | x | x |   | x |'
                ];

                c3.cover();
                it.expects(dlx.toString()).toEqual(result.join('\n'));
            });

            it.should('filter the rendering by rows to show solutions', function() {
                var dlx:DLX = getSampleMatrix();
                var result:Vector.<String> = [
                '___|001|002|003|004|005|006|007|',
                '001|   |   | x |   | x | x |   |',
                '004| x |   |   | x |   |   |   |',
                '005|   | x |   |   |   |   | x |',
                ];

                it.expects(AsciiRenderer.render(dlx, [1,4,5])).toEqual(result.join('\n'));
            });
        }
    }
}
