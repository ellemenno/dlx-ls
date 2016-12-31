package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.DLX;


    public static class DLXSpec
    {
        private static const it:Thing = Spec.describe('DLX');

        public static function describe():void
        {
            it.should('be versioned', be_versioned);
            it.should('initialize by default to a single dimensionless root node', init_as_root_only);
            it.should('initialize to a given number of empty columns', init_to_given_width);
            it.should('provide access to its columns', provide_col_access);
            it.should('solve a 2x2 latin square', solve_latin_square_2x2);
        }


        private static function be_versioned():void
        {
            it.expects(DLX.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function init_as_root_only():void
        {
            var dlx:DLX = new DLX();
            it.expects(dlx.width).toEqual(0);
            it.expects(dlx.height).toEqual(0);
        }

        private static function init_to_given_width():void
        {
            var dlx:DLX = new DLX(3);
            it.expects(dlx.width).toEqual(3);
            it.expects(dlx.height).toEqual(0);
        }

        private static function provide_col_access():void
        {
            var dlx:DLX = new DLX(3);
            dlx.addRow([1,2,3]);
            it.expects(dlx.getColumn(0).size).toEqual(0); //root
            it.expects(dlx.getColumn(1).label).toEqual(1);
            it.expects(dlx.getColumn(2).label).toEqual(2);
            it.expects(dlx.getColumn(3).label).toEqual(3);
        }

        private static function solve_latin_square_2x2():void
        {
            /*
            a) constraint columns 1–4:  Ensure each cell (col,row) has has some number.
            b) constraint columns 5–8:  Ensure each number (1,2) appears somewhere in each column.
            c) constraint columns 9–12: Ensure each number (1,2) appears somewhere in each row.

                       |      Constraints      |    Coordinates
                       |  (a)  |  (b)  |  (c)  |   .---------------.
                       |  col  |  num  |  num  |   | c1,r1 | c2,r1 |
             Choices   | 1 | 2 | 1 | 2 | 1 | 2 |   |-------+-------|
                       |  row  |  col  |  row  |   | c1,r2 | c2,r2 |
                       |1|2|1|2|1|2|1|2|1|2|1|2|   '---------------'
            -----------|-----------------------|
            n    c,r   |1 2 3 4 5 6 7 8 9 a b c|
            1 @ (1,1) 1|x| | | |x| | | |x| | | | a) occupy c1,r1   b) #1 in c1   c) #1 in r1
            2 @ (1,1) 2|x| | | | | |x| | | |x| | a) occupy c1,r1   b) #2 in c1   c) #2 in r1
            1 @ (1,2) 3| |x| | |x| | | | |x| | | ...
            2 @ (1,2) 4| |x| | | | |x| | | | |x|
            1 @ (2,1) 5| | |x| | |x| | |x| | | |
            2 @ (2,1) 6| | |x| | | | |x| | |x| |
            1 @ (2,2) 7| | | |x| |x| | | |x| | |
            2 @ (2,2) 8| | | |x| | | |x| | | |x|

            Solution 1 : 1,4,6,7                   .-------.
                                                   | 1 | 2 |
            n    c,r   |1 2 3 4 5 6 7 8 9 a b c|   |---+---|
            1 @ (1,1) 1|x| | | |x| | | |x| | | |   | 2 | 1 |
            2 @ (1,2) 4| |x| | | | |x| | | | |x|   '-------'
            2 @ (2,1) 6| | |x| | | | |x| | |x| |
            1 @ (2,2) 7| | | |x| |x| | | |x| | |

            Solution 2 : 2,3,5,8                   .-------.
                                                   | 2 | 1 |
            n    c,r   |1 2 3 4 5 6 7 8 9 a b c|   |---+---|
            2 @ (1,1) 2|x| | | | | |x| | | |x| |   | 1 | 2 |
            1 @ (1,2) 3| |x| | |x| | | | |x| | |   '-------'
            1 @ (2,1) 5| | |x| | |x| | |x| | | |
            2 @ (2,2) 8| | | |x| | | |x| | | |x|
            */

            var dlx:DLX = new DLX(12);
            dlx.addRow([1,5,9]);
            dlx.addRow([1,7,11]);
            dlx.addRow([2,5,10]);
            dlx.addRow([2,7,12]);
            dlx.addRow([3,6,9]);
            dlx.addRow([3,8,11]);
            dlx.addRow([4,6,10]);
            dlx.addRow([4,8,12]);

            dlx.solve();

            it.expects(dlx.solutions.length).toEqual(2);
            it.expects(dlx.solutions[0].toString()).toEqual([1,4,6,7].toString());
            it.expects(dlx.solutions[1].toString()).toEqual([2,3,5,8].toString());
        }
    }
}
