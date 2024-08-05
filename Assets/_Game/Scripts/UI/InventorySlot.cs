using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class InventorySlot : Slot
    {
        public InventorySlot()
        {
            Icon = this.CreateChild<Image>("slotIcon");
            StackLabel = this.CreateChild("slotFrame").CreateChild<Label>("slotStack");
        }
    }
}
