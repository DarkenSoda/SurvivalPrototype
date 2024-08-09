using System;
using Game.Items.Wrappers;
using UnityEngine;
using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public class Slot : VisualElement
    {
        public Image Icon;
        public Label StackLabel;
        public int Index => parent.IndexOf(this);
        public int Amount = 0;
        public Sprite Sprite;
        public Action<PointerDownEvent, Slot> OnPointerDownAction;

        public ItemWrapper ItemWrapper { get; private set; }

        public Slot()
        {
            RegisterCallback<PointerDownEvent>(OnPointerDown);
        }

        private void OnPointerDown(PointerDownEvent evt)
        {
            if (evt.button != 0 || Sprite == null)
                return;

            OnPointerDownAction?.Invoke(evt, this);
            evt.StopPropagation();
        }

        public virtual void Set(ItemWrapper itemWrapper, int amount = 0)
        {
            ItemWrapper = itemWrapper;

            Sprite = itemWrapper?.ItemData ? itemWrapper.ItemData.Icon : null;
            Icon.image = itemWrapper?.ItemData ? itemWrapper.ItemData.Icon.texture : null;

            SetAmount(amount);
        }

        public void SetAmount(int amount)
        {
            Amount = amount;
            StackLabel.text = Amount > 1 ? Amount.ToString() : string.Empty;
        }

        public void Reduce()
        {
            SetAmount(Amount - 1);
            if (Amount <= 0)
                Set(null);
        }
    }
}
