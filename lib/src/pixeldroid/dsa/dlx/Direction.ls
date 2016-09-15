package pixeldroid.dsa.dlx
{

    class Direction
    {
        static public const LEFT:Direction = new Direction('LEFT');
        static public const RIGHT:Direction = new Direction('RIGHT');
        static public const UP:Direction = new Direction('UP');
        static public const DOWN:Direction = new Direction('DOWN');

        private var label:String;

        public function Direction(label:String)
        {
            this.label = label;
        }

        public function toString():String { return label; }
    }

}
