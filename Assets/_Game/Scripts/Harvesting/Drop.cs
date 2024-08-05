using System;
using Game.Items.Data;

namespace Game.Harvesting
{
    [Serializable]
    public struct Drop
    {
        public ItemData ItemData;
        public int MinAmount;
        public int MaxAmount;
    }
}
