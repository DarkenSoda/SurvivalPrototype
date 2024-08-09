using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class InventorySlot : Slot
    {
        public Label DescriptionLabel { get; private set; }
        public Label DurabilityLabel { get; private set; }

        public InventorySlot()
        {
            AddToClassList("slot");
            Icon = this.CreateChild<Image>("slotIcon");
            StackLabel = this.CreateChild("slotFrame").CreateChild<Label>("slotStack");
            DescriptionLabel = this.CreateChild<Label>("slotDescription");
            DurabilityLabel = this.CreateChild<Label>("slotDurability");
        }

        public override void Set(ItemWrapper itemWrapper, int amount = 0)
        {
            base.Set(itemWrapper, amount);
            SetDescription();
            SetDurability();
        }

        public void SetDescription()
        {
            DescriptionLabel.text = ItemWrapper?.ItemData?.Description ?? string.Empty;
        }

        public void SetDurability()
        {
            if (ItemWrapper is not DurableItemWrapper durableItem)
            {
                DurabilityLabel.text = string.Empty;
                return;
            }

            float durability = durableItem.CurrentDurability;
            float maxDurability = (durableItem.ItemData as HarvestItemData).MaxDurability;
            float durabilityPercentage = durability / maxDurability * 100;

            DurabilityLabel.text = $"{durabilityPercentage:0}%";
        }
    }
}
