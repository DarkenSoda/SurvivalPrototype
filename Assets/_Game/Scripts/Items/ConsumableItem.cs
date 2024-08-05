using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine;

namespace Game.Items
{
    public class ConsumableItem : Item
    {
        public ConsumableItemData ConsumableData => Wrapper.ItemData as ConsumableItemData;

        public ConsumableItem(ItemWrapper itemWrapper)
            : base(itemWrapper) { }

        public override void Use()
        {
            Debug.Log($"{ConsumableData.Name} Consumed");
            Wrapper.Destroy();
        }
    }
}
