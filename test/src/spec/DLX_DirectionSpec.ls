package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.dsa.DLX_Direction;

    public static class DLX_DirectionSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('DLX_Direction');

            it.should('provide UP, DOWN, LEFT, and RIGHT', function() {
                it.expects(DLX_Direction.UP.toString()).toEqual('UP');
                it.expects(DLX_Direction.DOWN.toString()).toEqual('DOWN');
                it.expects(DLX_Direction.LEFT.toString()).toEqual('LEFT');
                it.expects(DLX_Direction.RIGHT.toString()).toEqual('RIGHT');
            });
        }
    }
}
