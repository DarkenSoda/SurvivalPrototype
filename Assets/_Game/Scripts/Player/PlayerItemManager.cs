using Game.Items;
using Game.Items.Data;
using UnityEngine;
using Alchemy;
using Game.Items.Wrappers;

namespace Game.Player
{
    public class PlayerItemManager : MonoBehaviour
    {
        [SerializeField] private Transform arm;
        [SerializeField] private Transform itemHolder;

        private Animator armAnimator;
        private Item currentItem;
        private ItemWrapper currentItemWrapper;
        public event System.Action OnSelectedItemBroken;
        public event System.Action OnSelectedItemDurabilityChanged;

        private void Awake()
        {
            armAnimator = arm.GetComponent<Animator>();
            arm.gameObject.SetActive(false);
        }

        private void Update()
        {
            if (currentItem == null)
                return;

            if (Input.GetMouseButtonDown(0))
            {
                armAnimator.SetBool("Use", true);
            }
            else if (Input.GetMouseButtonUp(0))
            {
                armAnimator.SetBool("Use", false);
            }
        }

        public void EquipItem(ItemWrapper itemWrapper)
        {
            if (currentItemWrapper != null)
                UnEquipItem();

            if (itemWrapper == null)
                return;

            currentItemWrapper = itemWrapper;
            currentItem = itemWrapper.ItemData switch
            {
                HarvestItemData harvestItemData => new HarvestItem(itemWrapper),
                ConsumableItemData consumableItemData => new ConsumableItem(itemWrapper),
                _ => null
            };

            Instantiate(itemWrapper.ItemData.HeldPrefab, itemHolder);
            RegisterCallbacks();

            armAnimator.runtimeAnimatorController = itemWrapper.ItemData.AnimatorController;
            arm.gameObject.SetActive(true);
        }

        public void UnEquipItem()
        {
            UnregisterCallbacks();

            currentItem = null;
            currentItemWrapper = null;
            arm.gameObject.SetActive(false);

            if (itemHolder.childCount > 0)
                Destroy(itemHolder.GetChild(0).gameObject);
        }

        public void RegisterCallbacks()
        {
            if (currentItemWrapper == null)
                return;

            currentItemWrapper.OnItemBroken += ItemBroken;

            if (currentItemWrapper is IDurable durableItem)
                durableItem.OnDurabilityChanged += DurabilityChanged;
        }

        public void UnregisterCallbacks()
        {
            if (currentItemWrapper == null)
                return;

            currentItemWrapper.OnItemBroken -= ItemBroken;

            if (currentItemWrapper is IDurable durableItem)
                durableItem.OnDurabilityChanged -= DurabilityChanged;
        }

        public void UseItem()
        {
            currentItem?.Use();
        }

        private void ItemBroken()
        {
            OnSelectedItemBroken?.Invoke();
        }

        private void DurabilityChanged()
        {
            OnSelectedItemDurabilityChanged?.Invoke();
        }
    }
}
