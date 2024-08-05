using UnityEngine.UIElements;

namespace Game.UI.Inventory
{
    public static class VisualElementExtensions
    {
        public static VisualElement CreateChild(this VisualElement parent, string className = "")
        {
            var child = new VisualElement();
            child.AddToClassList(className);
            parent.Add(child);
            return child;
        }

        public static T CreateChild<T>(this VisualElement parent, string className = "") where T : VisualElement, new()
        {
            var child = new T();
            parent.Add(child, className);
            return child;
        }

        public static VisualElement Add(this VisualElement parent, VisualElement child, string className = "")
        {
            child.AddToClassList(className);
            parent.Add(child);
            return child;
        }
    }
}
