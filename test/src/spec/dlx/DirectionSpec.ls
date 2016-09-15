package dlx
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.dlx.Direction;


    public static class DirectionSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('dlx.Direction');

            it.should('provide UP, DOWN, LEFT, and RIGHT', function() {
                it.expects(Direction.UP.toString()).toEqual('UP');
                it.expects(Direction.DOWN.toString()).toEqual('DOWN');
                it.expects(Direction.LEFT.toString()).toEqual('LEFT');
                it.expects(Direction.RIGHT.toString()).toEqual('RIGHT');
            });
        }
    }
}
