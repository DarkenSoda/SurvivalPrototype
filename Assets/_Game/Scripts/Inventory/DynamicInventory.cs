using System;
using System.Collections.Generic;
using System.Linq;
using Game.Items.Data;
using Game.UI.Inventory;
using Utilities.DataStructures;

namespace Game.InventorySystem
{
    public class DynamicInventory : SortedMultiDictionary<ItemData, Slot>
    {
        public event Action OnInventoryChanged;

        public void AddSlot(Slot slot)
        {
            // find a slot that already contains the item and not full
            IEnumerable<Slot> slots = GetValues(slot.ItemWrapper.ItemData);
            var existingSlot = slots
                .Where(s => s.Amount < s.ItemWrapper.ItemData.MaxStack)
                .FirstOrDefault();

            if (existingSlot != null)
            {
                existingSlot.Amount++;
                return;
            }

            Add(slot.ItemWrapper.ItemData, slot);
            OnInventoryChanged?.Invoke();
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
