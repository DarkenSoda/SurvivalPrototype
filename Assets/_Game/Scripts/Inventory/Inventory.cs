using System;
using System.Collections;
using System.Collections.Generic;
using Game.Items.Data;
using UnityEngine;
using Alchemy.Serialization;
using Game.UI.Inventory;
using Game.Items.Wrappers;
using Game.Player;

namespace Game.Inventory
{
    [AlchemySerialize]
    public partial class Inventory : MonoBehaviour
    {
        [SerializeField] private InventoryView view;
        [SerializeField] private float dropForce = 5f;

        [AlchemySerializeField, NonSerialized]
        public Dictionary<ItemData, int> startingItems;

        public bool IsInventoryVisible => view.IsVisible;

        private Transform cameraTransform;
        private PlayerItemManager playerItemManager;

        private void Awake()
        {
            StartCoroutine(Initialize());

            cameraTransform = Camera.main.transform;
            playerItemManager = GetComponent<PlayerItemManager>();
            playerItemManager.OnSelectedItemBroken += UpdateSelectedItem;
        }

        private IEnumerator Initialize()
        {
            yield return view.Initialize();

            foreach (var item in startingItems)
            {
                int totalAmount = item.Value;
                int stackSize = item.Key.MaxStack;

                int stacks = totalAmount / stackSize;
                int remainder = totalAmount % stackSize;

                for (int i = 0; i < stacks; i++)
                {
                    yield return view.AddItem(item.Key.CreateWrapper(), stackSize);
                }
                
                yield return view.AddItem(item.Key.CreateWrapper(), remainder);
            }

            view.OnItemDropped += OnItemDropped;
            OnSelectedSlotChanged += OnHotbarSlotChanged;
            view.OnHotbarSlotChanged += OnCheckHotbarSlotChanged;
            OnSelectedSlotChanged?.Invoke();
            ToggleInventory();
        }

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.E))
            {
                ToggleInventory();
            }

            HandleScroll();
        }

        private void ToggleInventory()
        {
            view.ToggleInventory();

            if (IsInventoryVisible)
            {
                Cursor.lockState = CursorLockMode.None;
                Cursor.visible = true;
            }
            else
            {
                Cursor.lockState = CursorLockMode.Locked;
                Cursor.visible = false;
            }
        }

        public void PickUpItem(ItemWrapper itemWrapper)
        {
            StartCoroutine(view.AddItem(itemWrapper, 1));
        }

        private void OnItemDropped(ItemWrapper wrapper, int amount)
        {
            StartCoroutine(DropItem(wrapper, amount));
        }

        private IEnumerator DropItem(ItemWrapper wrapper, int amount)
        {
            for (int i = 0; i < amount; i++)
            {
                yield return new WaitForSeconds(0.1f);

                var item = wrapper.ItemData;
                var droppedItem = Instantiate(item.DroppedItemData.DroppedPrefab, transform.position, Quaternion.identity);
                droppedItem.SetWrapper(wrapper);
                droppedItem.GetComponent<Rigidbody>().AddForce(cameraTransform.forward * dropForce, ForceMode.Impulse);
            }
        }

        private void OnDisable()
        {
            view.OnItemDropped -= OnItemDropped;
            OnSelectedSlotChanged -= OnHotbarSlotChanged;
            view.OnHotbarSlotChanged -= OnCheckHotbarSlotChanged;

            playerItemManager.OnSelectedItemBroken -= UpdateSelectedItem;
        }
    }

    // Slot selection
    public partial class Inventory
    {
        public Action OnSelectedSlotChanged;
        private int selectedSlotIndex = 0;
        public int SelectedSlotIndex
        {
            get => selectedSlotIndex;
            set
            {
                if (selectedSlotIndex != value)
                {
                    selectedSlotIndex = value;
                    OnSelectedSlotChanged?.Invoke();
                }
            }
        }

        public void HandleScroll()
        {
            if (Input.mouseScrollDelta.y > 0)
            {
                SelectedSlotIndex = (SelectedSlotIndex + 1) % view.HotbarSlotCount;
            }
            else if (Input.mouseScrollDelta.y < 0)
            {
                SelectedSlotIndex = (SelectedSlotIndex - 1 + view.HotbarSlotCount) % view.HotbarSlotCount;
            }
        }

        // if selected slot is changed, update the item
        public void OnHotbarSlotChanged()
        {
            var item = view.ChangeSelectedSlotFrame(SelectedSlotIndex);

            playerItemManager.EquipItem(item);
        }

        // if any hotbar slot is changed, check if it is the selected slot
        public void OnCheckHotbarSlotChanged(int index)
        {
            if (SelectedSlotIndex == index)
            {
                OnHotbarSlotChanged();
            }
        }

        public void UpdateSelectedItem()
        {
            view.DecreaseSelectedItemAmount(selectedSlotIndex);
        }
    }
}
