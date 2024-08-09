using System;
using System.Collections.Generic;
using System.Linq;
using Game.Items.Data;
using Game.Items.Wrappers;
using Game.UI.Inventory;
using Utilities.DataStructures;

namespace Game.InventorySystem
{
    public class DynamicInventory : SortedMultiDictionary<ItemData, Slot>
    {
        public event Action OnInventoryChanged;
     
        public DynamicInventory(IComparer<ItemData> comparer) : base(comparer) { }

        public Slot AddItem(ItemWrapper item)
        {
            // find a slot that already contains the item and not full
            IEnumerable<Slot> slots = GetValues(item.ItemData);
            var existingSlot = slots
                .Where(s => s.Amount < s.ItemWrapper.ItemData.MaxStack)
                .FirstOrDefault();

            if (existingSlot != null)
            {
                existingSlot.SetAmount(existingSlot.Amount + 1);
                return null;
            }

            Slot slot = new InventorySlot();
            slot.Set(item, 1);
            Add(item.ItemData, slot);
            OnInventoryChanged?.Invoke();

            return slot;
        }

        public void RemoveSlot(Slot slot)
        {
            Remove(slot.ItemWrapper.ItemData, slot);
            OnInventoryChanged?.Invoke();
        }

        public IEnumerable<Slot> GetAllSlots()
        {
            foreach (var slots in Values)
            {
                foreach (var slot in slots)
                {
                    yield return slot;
                }
            }
        }
    }
}
