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
        public event System.Action OnSelectedItemBroken;

        private void Awake()
        {
            armAnimator = arm.GetComponent<Animator>();
            arm.gameObject.SetActive(false);
        }

        private void Update()
        {
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
            if (currentItem != null)
                UnEquipItem();

            if (itemWrapper == null)
                return;

            currentItem = itemWrapper.ItemData switch
            {
                HarvestItemData harvestItemData => new HarvestItem(itemWrapper),
                ConsumableItemData consumableItemData => new ConsumableItem(itemWrapper),
                _ => null
            };

            Instantiate(itemWrapper.ItemData.HeldPrefab, itemHolder);

            itemWrapper.OnItemBroken += UpdateInventory;

            arm.gameObject.SetActive(true);
        }

        public void UnEquipItem()
        {
            currentItem.Wrapper.OnItemBroken -= UpdateInventory;

            currentItem = null;
            arm.gameObject.SetActive(false);

            if (itemHolder.childCount > 0)
                Destroy(itemHolder.GetChild(0).gameObject);
        }

        public void UseItem()
        {
            currentItem?.Use();
        }

        private void UpdateInventory()
        {
            OnSelectedItemBroken?.Invoke();
        }
    }
}
