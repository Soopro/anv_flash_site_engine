package
{
    import flash.net.LocalConnection;
    public class GC
    {
        public static function run()
        {
            try
            {
                var lc1:LocalConnection = new LocalConnection();
                var lc2:LocalConnection = new LocalConnection();
                lc1.connect('name');
                lc2.connect('name2');
            }
            catch (e:Error)
            {
            }
        }
    }
}