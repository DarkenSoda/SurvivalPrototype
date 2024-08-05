using System;
using Alchemy.Inspector;
using Game.Items.Wrappers;
using UnityEngine;

namespace Game.Items.Data
{
    public abstract class ItemData : ScriptableObject
    {
        [field: Header("General Data")]
        [field: SerializeField] public string Name { get; private set; }
        [field: SerializeField] public string Description { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField] public int MaxStack { get; private set; }
        [field: SerializeField] public bool IsHarvestItem { get; private set; }

        [field: Header("Prefabs")]
        [field: SerializeField] public GameObject HeldPrefab { get; private set; }
        [field: SerializeField, DisableAlchemyEditor] public DroppedItemData DroppedItemData { get; private set; }

        public virtual ItemWrapper CreateWrapper()
        {
            return new ItemWrapper(this);
        }

        public virtual ItemWrapper CopyWrapper(ItemWrapper itemWrapper)
        {
            return new ItemWrapper(itemWrapper);
        }
    }
}
