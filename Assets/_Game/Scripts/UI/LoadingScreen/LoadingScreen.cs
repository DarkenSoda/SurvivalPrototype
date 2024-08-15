using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using DG.Tweening;

namespace Game.UI.LoadingScreen
{
    public class LoadingScreen : MonoBehaviour
    {
        [SerializeField] private UIDocument document;
        [SerializeField] private AudioClip jumpSound;

        private VisualElement root;
        private List<VisualElement> images;
        private bool loadingScreenStarted;

        float duration = 0.2f;

        private void Start()
        {
            root = document.rootVisualElement;
            images = root.Query(className: "jump").ToList();

            StartCoroutine(Jump());
        }

        private void Update()
        {
            if (loadingScreenStarted)
                return;

            // incase you're stuck in the loading screen
            if (Input.GetKeyDown(KeyCode.Space))
            {
                StartCoroutine(Jump());
            }
        }

        private IEnumerator Jump()
        {
            loadingScreenStarted = true;
            for (int i = 0; i < 3; i++)
            {
                yield return JumpAnimation();
            }

            Destroy(gameObject);
        }

        private IEnumerator JumpAnimation()
        {
            foreach (var image in images)
            {
                AudioManager.Instance.PlaySFXClip(jumpSound, Camera.main.transform);
                yield return MoveAnimation(image);
            }
        }

        private IEnumerator MoveAnimation(VisualElement image)
        {
            image.ClearClassList();
            image.AddToClassList("jump");
            image.AddToClassList("jumpUp");
            yield return new WaitForSeconds(duration);

            image.ClearClassList();
            image.AddToClassList("jump");
            yield return new WaitForSeconds(duration);
        }

        private void OnDisable()
        {
            StopAllCoroutines();
        }
    }
}
