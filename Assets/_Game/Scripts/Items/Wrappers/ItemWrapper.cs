using Game.Items.Data;
using UnityEngine;

namespace Game.Items.Wrappers
{
    public class ItemWrapper
    {
        public ItemData ItemData { get; private set; }
        public event System.Action OnItemBroken;

        public ItemWrapper(ItemData itemData)
        {
            ItemData = itemData;
        }

        public ItemWrapper(ItemWrapper itemWrapper)
        {
            ItemData = itemWrapper.ItemData;
        }

        public virtual void Destroy()
        {
            OnItemBroken?.Invoke();
        }
    }
}
