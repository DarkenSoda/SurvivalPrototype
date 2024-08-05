using UnityEngine;
using UnityEngine.Events;

namespace Game.Player
{
    public class PlayerAnimationEventsHandler : MonoBehaviour
    {
        public UnityEvent OnUse;

        public void Use()
        {
            OnUse?.Invoke();
        }
    }
}
