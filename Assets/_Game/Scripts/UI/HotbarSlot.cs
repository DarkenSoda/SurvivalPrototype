using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine;
using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class HotbarSlot : Slot
    {
        public VisualElement SelectionFrame { get; private set; }
        public VisualElement DurabilityBar { get; private set; }

        public HotbarSlot()
        {
            Icon = this.CreateChild<Image>("hotbarIcon");
            StackLabel = this.CreateChild("hotbarFrame").CreateChild<Label>("hotbarStack");
            SelectionFrame = this.CreateChild("hotbarSelectionFrame");
            DurabilityBar = this.CreateChild("hotbarDurabilityContainer").CreateChild("hotbarDurabilityBar");

            SelectionFrame.style.visibility = Visibility.Hidden;
            DurabilityBar.style.visibility = Visibility.Hidden;
        }

        public override void Set(ItemWrapper itemWrapper, int amount = 0)
        {
            base.Set(itemWrapper, amount);
            SetDurability();
        }

        public void SetDurability()
        {
            if (ItemWrapper is not DurableItemWrapper durableItemWrapper)
            {
                DurabilityBar.style.visibility = Visibility.Hidden;
                return;
            }

            DurabilityBar.style.visibility = Visibility.Visible;
            float currentDurability = durableItemWrapper.CurrentDurability;
            float maxDurability = (durableItemWrapper.ItemData as HarvestItemData).MaxDurability;
            float durabilityPercentage = currentDurability / maxDurability;

            DurabilityBar.style.width = new StyleLength(new Length(durabilityPercentage * 100, LengthUnit.Percent));

            string durabilityClass = durabilityPercentage switch
            {
                <= 0.25f => "lowDurability",
                <= 0.5f => "midDurability",
                <= 0.75f => "highDurability",
                _ => "maxDurability"
            };

            DurabilityBar.ClearClassList();
            DurabilityBar.AddToClassList("hotbarDurabilityBar");
            DurabilityBar.AddToClassList(durabilityClass);
        }

        // public ProgressBar CreateProgressBar()
        // {
        //     ProgressBar progressBar = new ProgressBar()
        //     {
        //         lowValue = 0f,
        //         highValue = 1f,
        //         value = 1f,
        //     };
        //     progressBar.AddToClassList("hotbarDurabilityBar");
        //     return progressBar;
        // }
    }
}
