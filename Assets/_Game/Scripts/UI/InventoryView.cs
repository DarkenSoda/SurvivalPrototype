using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Game.InventorySystem;
using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine;
using UnityEngine.UIElements;
using Game.Utilities;

namespace Game.UI.Inventory
{
    public partial class InventoryView : MonoBehaviour
    {
        [SerializeField] private UIDocument document;
        [SerializeField] private StyleSheet styleSheet;
        [SerializeField] private string panelName = "Inventory";
        [SerializeField] private int hotbarSlotCount = 8;

        private static VisualElement ghostIcon;
        private bool isDragging = false;
        public bool IsVisible => inventory.style.visibility == Visibility.Visible;

        public int HotbarSlotCount => hotbarSlotCount;

        private VisualElement root;
        private VisualElement container;
        private VisualElement inventory;
        private VisualElement hotbar;
        private VisualElement hotbarOverlay;
        // private VisualElement inventorySlotContainer;
        // private ListView inventorySlotContainer;
        private ScrollView inventorySlotContainer;

        private DynamicInventory dynamicInventory;
        private HotbarSlot[] hotbarSlots;
        private Slot draggedSlot;

        public event Action<ItemWrapper, int> OnItemDropped;
        public event Action<int> OnHotbarSlotChanged;

        #region Initialization
        public IEnumerator Initialize()
        {
            dynamicInventory = new DynamicInventory(new DynamicInventoryComparer());
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
            inventory.style.visibility = Visibility.Visible;

            inventorySlotContainer = inventory.CreateChild<ScrollView>("slotContainer");
            inventorySlotContainer.mouseWheelScrollSize = 500;
            inventorySlotContainer.verticalScroller.style.visibility = Visibility.Hidden;

            yield return null;
        }

        private IEnumerator InitializeHotbar()
        {
            hotbar = container.CreateChild("hotbar");

            var hotbarSlotContainer = hotbar.CreateChild("hotbarSlotContainer");
            hotbarOverlay = hotbar.CreateChild("hotbarOverlay");
            hotbarOverlay.pickingMode = PickingMode.Ignore; // Allows events to pass through

            for (int i = 0; i < hotbarSlotCount; i++)
            {
                var slot = hotbarSlotContainer.CreateChild<HotbarSlot>("hotbarSlot");
                hotbarSlots[i] = slot;
            }

            yield return null;
        }
        #endregion

        #region Inventory Management
        public IEnumerator AddItemToInventory(ItemWrapper item, int amount)
        {
            for (int i = 0; i < amount; i++)
            {
                var addedSlot = dynamicInventory.AddItem(item);

                if (addedSlot != null)
                    addedSlot.OnPointerDownAction += OnSlotPressed;

                yield return null;
            }
        }

        public void RemoveSlotFromInventory(Slot slot)
        {
            if (slot is not InventorySlot inventorySlot)
                return;

            slot.OnPointerDownAction -= OnSlotPressed;
            dynamicInventory.RemoveSlot(slot);
        }

        private void UpdateInventorySlots()
        {
            inventorySlotContainer.Clear();
            foreach (var slot in dynamicInventory.GetAllSlots())
            {
                inventorySlotContainer.Add(slot);
            }
            inventorySlotContainer.MarkDirtyRepaint();
        }

        public void ToggleInventory()
        {
            inventory.style.visibility = inventory.style.visibility == Visibility.Visible ? Visibility.Hidden : Visibility.Visible;
            hotbarOverlay.style.visibility = inventory.style.visibility;
        }
        #endregion

        #region UI Events
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
            if (!isDragging) return;

            bool isOverInventory = ghostIcon.worldBound.Overlaps(inventory.worldBound);
            bool isOverHotbar = ghostIcon.worldBound.Overlaps(hotbar.worldBound);

            if (isOverInventory)
            {
                HandleInventoryDrop();
            }
            else if (isOverHotbar)
            {
                HandleHotbarDrop();
            }
            else
            {
                DropDraggedItem();
            }

            ResetDraggingState();
        }
        #endregion

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

        public void UpdateSelectedItemDurability(int index)
        {
            hotbarSlots[index].SetDurability();
        }

        #region Callbacks
        private IEnumerator RegisterCallbacks()
        {
            dynamicInventory.OnInventoryChanged += UpdateInventorySlots;

            container.RegisterCallback<PointerMoveEvent>(OnPointerMove);
            container.RegisterCallback<PointerUpEvent>(OnPointerUp);

            foreach (var slot in hotbarSlots)
            {
                slot.OnPointerDownAction += OnSlotPressed;
            }

            yield return null;
        }

        private void UnregisterCallbacks()
        {
            dynamicInventory.OnInventoryChanged -= UpdateInventorySlots;

            container.UnregisterCallback<PointerMoveEvent>(OnPointerMove);
            container.UnregisterCallback<PointerUpEvent>(OnPointerUp);

            foreach (var slot in dynamicInventory.GetAllSlots())
            {
                slot.OnPointerDownAction -= OnSlotPressed;
            }

            foreach (var slot in hotbarSlots)
            {
                slot.OnPointerDownAction -= OnSlotPressed;
            }
        }
        #endregion

        private void OnDestroy()
        {
            UnregisterCallbacks();
        }
    }

    public partial class InventoryView : MonoBehaviour
    {
        #region Drag and Drop
        private void HandleInventoryDrop()
        {
            if (draggedSlot is HotbarSlot)
            {
                AddItemToInventoryFromHotbar();
            }
        }

        private void AddItemToInventoryFromHotbar()
        {
            var ItemWrapper = draggedSlot.ItemWrapper;
            var Amount = draggedSlot.Amount;
            StartCoroutine(AddItemToInventory(ItemWrapper, Amount));
            draggedSlot.Set(null);
            OnHotbarSlotChanged?.Invoke(draggedSlot.Index);
        }

        private void HandleHotbarDrop()
        {
            var closestSlot = hotbarSlots
                .Where(s => s.worldBound.Overlaps(ghostIcon.worldBound))
                .OrderBy(s => Vector2.Distance(s.worldBound.center, ghostIcon.worldBound.center))
                .FirstOrDefault();

            if (closestSlot == null) return;

            if (draggedSlot is InventorySlot)
            {
                SwapInventoryWithHotbar(closestSlot);
            }
            else
            {
                if (draggedSlot == closestSlot)
                    return;

                SwapHotbarSlots(closestSlot);
            }

            OnHotbarSlotChanged?.Invoke(closestSlot.Index);
        }

        private void SwapInventoryWithHotbar(HotbarSlot closestSlot)
        {
            var tempItem = closestSlot.ItemWrapper;
            var tempAmount = closestSlot.Amount;

            closestSlot.Set(draggedSlot.ItemWrapper, draggedSlot.Amount);

            StartCoroutine(AddItemToInventory(tempItem, tempAmount));
            RemoveSlotFromInventory(draggedSlot);
        }

        private void SwapHotbarSlots(HotbarSlot closestSlot)
        {
            var tempItem = closestSlot.ItemWrapper;
            var tempAmount = closestSlot.Amount;

            closestSlot.Set(draggedSlot.ItemWrapper, draggedSlot.Amount);
            draggedSlot.Set(tempItem, tempAmount);

            OnHotbarSlotChanged?.Invoke(draggedSlot.Index);
        }

        private void ResetDraggingState()
        {
            ghostIcon.style.visibility = Visibility.Hidden;
            isDragging = false;
            draggedSlot = null;
        }

        private void DropDraggedItem()
        {
            OnItemDropped?.Invoke(draggedSlot.ItemWrapper, draggedSlot.Amount);

            if (draggedSlot is InventorySlot)
            {
                RemoveSlotFromInventory(draggedSlot);
            }
            else
            {
                draggedSlot.Set(null);
                OnHotbarSlotChanged?.Invoke(draggedSlot.Index);
            }
        }
        #endregion
    }
}
