using System.Collections.Generic;
using Game.Items.Data;

namespace Game.Utilities
{
    public class DynamicInventoryComparer : IComparer<ItemData>
    {
        public int Compare(ItemData x, ItemData y)
        {
            if (x.ItemType == y.ItemType)
            {
                return x.Name.CompareTo(y.Name);
            }

            return x.ItemType.CompareTo(y.ItemType);
        }
    }
}
