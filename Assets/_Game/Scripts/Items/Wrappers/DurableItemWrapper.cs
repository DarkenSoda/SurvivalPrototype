using Game.Items.Data;

namespace Game.Items.Wrappers
{
    public class DurableItemWrapper : ItemWrapper, IDurable
    {
        public float CurrentDurability { get; set; }
        public event System.Action OnDurabilityChanged;

        public DurableItemWrapper(HarvestItemData itemData) : base(itemData)
        {
            CurrentDurability = itemData.MaxDurability;
        }

        public DurableItemWrapper(DurableItemWrapper itemWrapper) : base(itemWrapper)
        {
            CurrentDurability = itemWrapper.CurrentDurability;
        }

        public void DecreaseDurability(float amount)
        {
            CurrentDurability -= amount;
            OnDurabilityChanged?.Invoke();

            if (CurrentDurability <= 0)
            {
                CurrentDurability = 0;
                Destroy();
            }
        }
    }
}
