using UnityEngine;

namespace Game.Items.Data
{
    [CreateAssetMenu(fileName = "New Consumable Item", menuName = "Scriptable Objects/Items/Consumable Item")]
    public class ConsumableItemData : ItemData
    {
        [field: Header("Consumable Data")]
        [field: SerializeField] public int Health { get; private set; }
        [field: SerializeField] public int Hunger { get; private set; }
        [field: SerializeField] public int Thirst { get; private set; }
    }
}
