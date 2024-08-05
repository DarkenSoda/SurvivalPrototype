using System;
using UnityEngine;

namespace Game.Items.Data
{
    [Serializable]
    public class DroppedItemData
    {
        [field: SerializeField] public DroppedItem DroppedPrefab { get; private set; }
        [field: SerializeField] public Vector3 Position { get; private set; }
        [field: SerializeField] public Quaternion Rotation { get; private set; }
        [field: SerializeField] public Vector3 Scale { get; private set; } = Vector3.one;
    }
}
