using System;
using System.Collections.Generic;
using UnityEngine;

namespace Game.Harvesting
{
    [CreateAssetMenu(fileName = "HarvestData", menuName = "Scriptable Objects/Harvesting/Harvest Data")]
    public class HarvestData : ScriptableObject
    {
        [field: Header("Harvestable Data")]
        [field: SerializeField, Range(1, 20)] public int MaxHealth { get; private set; } = 5;
        [field: SerializeField] public HarvestableType Type { get; private set; }

        [field: Header("Drops")]
        [field: SerializeField] public Vector3 DropOffset { get; private set; }
        [field: SerializeField] public float RandomOffset { get; private set; } = 0.5f;
        [field: SerializeField] public List<Drop> Drops { get; private set; }
    }
}
