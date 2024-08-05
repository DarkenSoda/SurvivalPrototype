using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class HotbarSlot : Slot
    {
        public VisualElement SelectionFrame { get; private set; }

        public HotbarSlot()
        {
            Icon = this.CreateChild<Image>("hotbarIcon");
            StackLabel = this.CreateChild("hotbarFrame").CreateChild<Label>("hotbarStack");
            SelectionFrame = this.CreateChild("hotbarSelectionFrame");
            SelectionFrame.style.visibility = Visibility.Hidden;
        }
    }
}
