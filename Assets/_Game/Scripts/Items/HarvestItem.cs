using Game.Harvesting;
using Game.Items.Data;
using UnityEngine;
using DG.Tweening;
using System;
using Game.Items.Wrappers;

namespace Game.Items
{
    [Serializable]
    public class HarvestItem : Item
    {
        public HarvestItemData HarvestData => Wrapper.ItemData as HarvestItemData;
        public DurableItemWrapper DurableWrapper => Wrapper as DurableItemWrapper;

        public HarvestItem(ItemWrapper itemWrapper)
            : base(itemWrapper) { }

        public override void Use()
        {
            Ray ray = new Ray(Camera.main.transform.position, Camera.main.transform.forward);

            if (!Physics.Raycast(ray, out RaycastHit hit, HarvestData.Range))
                return;

            if (!hit.collider.TryGetComponent(out IHarvestable harvestable))
                return;

            if (harvestable.Type != HarvestData.HarvestableType)
                return;

            hit.transform.DOShakePosition(0.1f, .1f, 100);
            harvestable.Harvest(HarvestData.Damage);

            DurableWrapper.DecreaseDurability(HarvestData.DurabilityDecreaseRate);
        }
    }
}
