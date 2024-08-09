using Game.Items.Wrappers;

namespace Game.Items
{
    public class DefaultItem : Item
    {
        public DefaultItem(ItemWrapper itemWrapper) : base(itemWrapper) { }

        public override void Use() { }
    }
}
