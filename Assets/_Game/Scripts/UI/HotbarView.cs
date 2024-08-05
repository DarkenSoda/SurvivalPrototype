using System.Collections;
using System.Collections.Generic;
using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class HotbarView : StorageView
    {
        private void Start()
        {
            container.RegisterCallback<PointerMoveEvent>(OnPointerMove);
            container.RegisterCallback<PointerUpEvent>(OnPointerUp);

            foreach (var slot in slots)
            {
                // slot.OnPointerDownAction += OnSlotPressed;
            }
        }

        public override IEnumerator Initialize()
        {
            slots = new HotbarSlot[slotCount];
            root = document.rootVisualElement;
            root.Clear();

            root.styleSheets.Add(styleSheet);

            container = root.CreateChild("container");
            container.style.visibility = Visibility.Visible;

            var hotbar = container.CreateChild("hotbar");
            hotbar.CreateChild("hotbarFrame");

            var slotContainer = hotbar.CreateChild("slotContainer");
            for (int i = 0; i < slotCount; i++)
            {
                var slot = slotContainer.CreateChild<HotbarSlot>("slot");
                slots[i] = slot;
            }

            ghostIcon = container.CreateChild("ghostIcon");
            ghostIcon.BringToFront();
            ghostIcon.style.visibility = Visibility.Hidden;

            yield return null;
        }

        public override void OnPointerUp(PointerUpEvent e)
        {
            if (!isDragging)
                return;

            ghostIcon.style.visibility = Visibility.Hidden;
            isDragging = false;

            if (e.target is HotbarSlot hotbarSlot)
            {
                var temp = hotbarSlot.ItemWrapper;
                hotbarSlot.Set(slots[draggedSlotIndex].ItemWrapper);
                slots[draggedSlotIndex].Set(temp);
                return;
            }

            if (e.target is InventorySlot inventorySlot)
            {
                var temp = inventorySlot.ItemWrapper;
                inventorySlot.Set(slots[draggedSlotIndex].ItemWrapper);
                slots[draggedSlotIndex].Set(temp);
                return;
            }

            // Drop item
        }
    }
}
