using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public abstract class StorageView : MonoBehaviour
    {
        [SerializeField] protected UIDocument document;
        [SerializeField] protected StyleSheet styleSheet;
        [SerializeField] protected int slotCount = 20;

        protected static VisualElement ghostIcon;
        protected bool isDragging = false;
        public bool IsVisible => container.style.visibility == Visibility.Visible;

        protected int draggedSlotIndex;

        protected VisualElement root;
        protected VisualElement container;

        protected Slot[] slots;

        public abstract IEnumerator Initialize();
        public abstract void OnPointerUp(PointerUpEvent e);

        public virtual void OnSlotPressed(PointerDownEvent e, int index)
        {
            isDragging = true;
            draggedSlotIndex = index;

            SetGhostIconPosition(e.position);
            ghostIcon.style.backgroundImage = slots[index].Sprite.texture;
            ghostIcon.style.visibility = Visibility.Visible;
        }

        public virtual void OnPointerMove(PointerMoveEvent e)
        {
            if (!isDragging)
                return;

            SetGhostIconPosition(e.position);
        }

        protected static void SetGhostIconPosition(Vector2 position)
        {
            ghostIcon.style.left = position.x - ghostIcon.layout.width / 2;
            ghostIcon.style.top = position.y - ghostIcon.layout.height / 2;
        }

        // protected virtual void OnDestroy()
        // {
        //     container.UnregisterCallback<PointerMoveEvent>(OnPointerMove);
        //     container.UnregisterCallback<PointerUpEvent>(OnPointerUp);

        //     foreach (var slot in slots)
        //     {
        //         slot.OnPointerDownAction -= OnSlotPressed;
        //     }
        // }
    }
}
