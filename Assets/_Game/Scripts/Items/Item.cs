using System;
using Game.Items.Data;
using Game.Items.Wrappers;
using UnityEngine;

namespace Game.Items
{
    public abstract class Item
    {
        public ItemWrapper Wrapper { get; private set; }

        public Item(ItemWrapper itemWrapper)
        {
            Wrapper = itemWrapper;
        }

        public abstract void Use();
    }
}
