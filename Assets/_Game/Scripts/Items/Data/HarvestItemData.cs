using Game.Harvesting;
using Game.Items.Wrappers;
using UnityEngine;

namespace Game.Items.Data
{
    [CreateAssetMenu(fileName = "New Harvest Item", menuName = "Scriptable Objects/Items/Harvest Item")]
    public class HarvestItemData : ItemData
    {
        [field: Header("Damage")]
        [field: SerializeField] public int Damage { get; private set; } = 1;
        [field: SerializeField] public float Range { get; private set; } = 1f;

        [field: Header("Durability")]
        [field: SerializeField] public float MaxDurability { get; private set; } = 100f;
        [field: SerializeField] public float DurabilityDecreaseRate { get; private set; } = 5f;

        [field: Header("Type")]
        [field: SerializeField] public HarvestableType HarvestableType { get; private set; }

        public override ItemWrapper CreateWrapper()
        {
            return new DurableItemWrapper(this);
        }

        public override ItemWrapper CopyWrapper(ItemWrapper itemWrapper)
        {
            return new DurableItemWrapper((DurableItemWrapper)itemWrapper);
        }
    }
}
