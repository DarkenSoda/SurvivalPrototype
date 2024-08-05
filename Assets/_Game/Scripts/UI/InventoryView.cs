using System;
using System.Collections;
using System.Linq;
using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine;
using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class InventoryView : MonoBehaviour
    {
        [SerializeField] private UIDocument document;
        [SerializeField] private StyleSheet styleSheet;
        [SerializeField] private string panelName = "Inventory";
        [SerializeField] private int slotCount = 20;
        [SerializeField] private int hotbarSlotCount = 8;

        private static VisualElement ghostIcon;
        private bool isDragging = false;
        public bool IsVisible => inventory.style.visibility == Visibility.Visible;

        public int HotbarSlotCount => hotbarSlotCount;

        private VisualElement root;
        private VisualElement container;
        private VisualElement inventory;
        private VisualElement hotbar;

        private InventorySlot[] slots;
        private HotbarSlot[] hotbarSlots;
        private Slot draggedSlot;

        public event Action<ItemWrapper, int> OnItemDropped;
        public event Action<int> OnHotbarSlotChanged;

        private IEnumerator RegisterCallbacks()
        {
            container.RegisterCallback<PointerMoveEvent>(OnPointerMove);
            container.RegisterCallback<PointerUpEvent>(OnPointerUp);

            foreach (var slot in slots)
            {
                slot.OnPointerDownAction += OnSlotPressed;
            }

            foreach (var slot in hotbarSlots)
            {
                slot.OnPointerDownAction += OnSlotPressed;
            }

            yield return null;
        }

        public IEnumerator Initialize()
        {
            slots = new InventorySlot[slotCount];
            hotbarSlots = new HotbarSlot[hotbarSlotCount];

            root = document.rootVisualElement;
            root.Clear();

            root.styleSheets.Add(styleSheet);

            container = root.CreateChild("container");

            yield return InitializeInventory();
            yield return InitializeHotbar();

            ghostIcon = container.CreateChild("ghostIcon");
            ghostIcon.BringToFront();
            ghostIcon.style.visibility = Visibility.Hidden;

            yield return RegisterCallbacks();
        }

        private IEnumerator InitializeInventory()
        {
            inventory = container.CreateChild("inventory");
            inventory.CreateChild("inventoryFrame");
            inventory.CreateChild("inventoryTitle").Add(new Label(panelName));

            var slotContainer = inventory.CreateChild("slotContainer");
            for (int i = 0; i < slotCount; i++)
            {
                var slot = slotContainer.CreateChild<InventorySlot>("slot");
                slots[i] = slot;
            }

            inventory.style.visibility = Visibility.Visible;

            yield return null;
        }

        private IEnumerator InitializeHotbar()
        {
            hotbar = container.CreateChild("hotbar");

            var hotbarSlotContainer = hotbar.CreateChild("hotbarSlotContainer");
            for (int i = 0; i < hotbarSlotCount; i++)
            {
                var slot = hotbarSlotContainer.CreateChild<HotbarSlot>("hotbarSlot");
                hotbarSlots[i] = slot;
            }

            yield return null;
        }

        public IEnumerator AddItem(ItemWrapper item, int amount)
        {
            // Find slot with same item and max stack size not reached
            for (int i = 0; i < amount; i++)
            {
                var slot = slots
                    .Where(s => s.ItemWrapper?.ItemData == item.ItemData && s.Amount < item.ItemData.MaxStack)
                    .FirstOrDefault();

                if (slot != null)
                {
                    slot.SetAmount(slot.Amount + 1);

                    yield return null;
                    continue;
                }

                // if not found, find empty slot
                slot = slots
                    .Where(s => s.Sprite == null)
                    .FirstOrDefault();

                if (slot != null)
                {
                    slot.Set(item, 1);
                }
                else
                {
                    // if not found, drop item
                }


                yield return null;
            }
        }

        public void ToggleInventory()
        {
            inventory.style.visibility = inventory.style.visibility == Visibility.Visible ? Visibility.Hidden : Visibility.Visible;
        }

        private void OnSlotPressed(PointerDownEvent e, Slot pressedSlot)
        {
            isDragging = true;
            draggedSlot = pressedSlot;

            SetGhostIconPosition(e.position);
            ghostIcon.style.backgroundImage = draggedSlot.Sprite.texture;
            ghostIcon.style.visibility = Visibility.Visible;
        }

        private void OnPointerMove(PointerMoveEvent e)
        {
            if (!isDragging)
                return;

            SetGhostIconPosition(e.position);
        }

        private void OnPointerUp(PointerUpEvent e)
        {
            if (!isDragging)
                return;

            Slot closestSlot = slots
                .Where(s => s.worldBound.Overlaps(ghostIcon.worldBound))
                .Union<Slot>(hotbarSlots.Where(s => s.worldBound.Overlaps(ghostIcon.worldBound)))
                .OrderBy(s => Vector2.Distance(s.worldBound.center, ghostIcon.worldBound.center))
                .FirstOrDefault();

            ghostIcon.style.visibility = Visibility.Hidden;
            isDragging = false;

            if (closestSlot == null)
            {
                // Drop item
                OnItemDropped?.Invoke(draggedSlot.ItemWrapper, draggedSlot.Amount);
                draggedSlot.Set(null, 0);
                draggedSlot = null;
                return;
            }

            if (draggedSlot is InventorySlot)
                HandleInventorySlotDropped(closestSlot);

            if (draggedSlot is HotbarSlot)
                HandleHotbarSlotDropped(closestSlot);

            draggedSlot = null;
        }

        private void HandleInventorySlotDropped(Slot closestSlot)
        {
            if (closestSlot is InventorySlot)
                return;

            if (closestSlot is not HotbarSlot hotbarSlot)
                return;

            var inventorySlot = draggedSlot as InventorySlot;

            var temp = hotbarSlot.ItemWrapper;
            var tempAmount = hotbarSlot.Amount;
            hotbarSlot.Set(inventorySlot.ItemWrapper, inventorySlot.Amount);
            inventorySlot.Set(temp, tempAmount);
            OnHotbarSlotChanged?.Invoke(closestSlot.Index);

            // change from swap to AddItem later
            // AddItem(temp, tempAmount);
        }

        private void HandleHotbarSlotDropped(Slot closestSlot)
        {
            var hotbarSlot = draggedSlot as HotbarSlot;

            var temp = closestSlot.ItemWrapper;
            var tempAmount = closestSlot.Amount;
            closestSlot.Set(hotbarSlot.ItemWrapper, hotbarSlot.Amount);
            hotbarSlot.Set(temp, tempAmount);

            OnHotbarSlotChanged?.Invoke(draggedSlot.Index);
            if (closestSlot is HotbarSlot)
                OnHotbarSlotChanged?.Invoke(closestSlot.Index);

            // change from swap to AddItem later if target is inventory slot
            // AddItem(temp, tempAmount);
        }

        private static void SetGhostIconPosition(Vector2 position)
        {
            ghostIcon.style.left = position.x - ghostIcon.layout.width / 2;
            ghostIcon.style.top = position.y - ghostIcon.layout.height / 2;
        }

        public ItemWrapper ChangeSelectedSlotFrame(int selectedSlotIndex)
        {
            foreach (var slot in hotbarSlots)
            {
                slot.SelectionFrame.style.visibility = Visibility.Hidden;
            }

            hotbarSlots[selectedSlotIndex].SelectionFrame.style.visibility = Visibility.Visible;
            return hotbarSlots[selectedSlotIndex].ItemWrapper;
        }

        public void DecreaseSelectedItemAmount(int index)
        {
            hotbarSlots[index].Reduce();

            if (hotbarSlots[index].Amount == 0)
                OnHotbarSlotChanged?.Invoke(index);
        }
    }
}
