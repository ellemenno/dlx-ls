package dlx
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.dlx.Direction;


    public static class DirectionSpec
    {
        private static const it:Thing = Spec.describe('dlx.Direction');

        public static function describe():void
        {
            it.should('provide UP, DOWN, LEFT, and RIGHT', provide_directions);
        }


        private static function provide_directions():void
        {
            it.expects(Direction.UP.toString()).toEqual('UP');
            it.expects(Direction.DOWN.toString()).toEqual('DOWN');
            it.expects(Direction.LEFT.toString()).toEqual('LEFT');
            it.expects(Direction.RIGHT.toString()).toEqual('RIGHT');
        }
    }
}
