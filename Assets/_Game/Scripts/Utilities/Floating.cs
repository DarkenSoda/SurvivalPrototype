using UnityEngine;
using DG.Tweening;
using System.Collections;

namespace Game.Utilities
{
    public class Floating : MonoBehaviour
    {
        [SerializeField] private float height = 0.5f;
        [SerializeField] private float duration = 0.5f;

        private float startY;

        private void Awake()
        {
            startY = transform.localScale.y / 2;
            StartCoroutine(FloatingRoutine());
        }

        private IEnumerator FloatingRoutine()
        {
            while (true)
            {
                Tween up = transform.DOLocalMoveY(startY + height, duration);
                Tween down = transform.DOLocalMoveY(startY, duration);
                yield return transform.DOLocalMoveY(startY + height, duration).WaitForCompletion();
                yield return transform.DOLocalMoveY(startY, duration).WaitForCompletion();
            }
        }

        private void OnDestroy()
        {
            transform.DOKill();
        }
    }
}
