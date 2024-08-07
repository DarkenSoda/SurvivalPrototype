using System;
using System.Collections;
using Game.InventorySystem;
using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine;

namespace Game.Items
{
    public class DroppedItem : MonoBehaviour
    {
        [SerializeField] private GameObject model;
        [SerializeField] private float interactionDelay = 1f;
        private Rigidbody rb;
        public ItemWrapper ItemWrapper { get; private set; }

        private bool isInteractable = true;

        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
            StartCoroutine(DisableInteractionFor(interactionDelay));
        }

        public void Initialize(ItemData itemData)
        {
            ItemWrapper = itemData.CreateWrapper();
            InitializeDroppedItemModel();
        }

        private void InitializeDroppedItemModel()
        {
            model.transform.localPosition = ItemWrapper.ItemData.DroppedItemData.Position;
            model.transform.localRotation = ItemWrapper.ItemData.DroppedItemData.Rotation;
            model.transform.localScale = ItemWrapper.ItemData.DroppedItemData.Scale;
            var itemModel = model.GetComponent<SpriteRenderer>();
            itemModel.sprite = ItemWrapper.ItemData.Icon;
        }

        public void SetWrapper(ItemWrapper wrapper)
        {
            ItemWrapper = wrapper;
            InitializeDroppedItemModel();
        }

        private IEnumerator DisableInteractionFor(float interactionDelay)
        {
            isInteractable = false;
            yield return new WaitForSeconds(interactionDelay);
            isInteractable = true;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Ground"))
            {
                rb.isKinematic = true;
            }

            if (!isInteractable)
                return;

            if (other.CompareTag("Player"))
            {
                other.GetComponent<Inventory>().PickUpItem(ItemWrapper);
                Destroy(gameObject);
            }
        }
    }
}
