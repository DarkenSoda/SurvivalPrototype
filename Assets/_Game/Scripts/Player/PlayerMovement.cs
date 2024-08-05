using System;
using UnityEngine;

namespace Game.Player
{
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField] private float speed = 5f;
        [SerializeField] private float gravityScale = 1f;

        private CharacterController cc;
        private Vector2 inputVector;
        private Vector3 moveDir;
        private Transform mainCamera;
        
        private float gravity = 9.81f;
        private float yVel;

        private void Awake()
        {
            cc = GetComponent<CharacterController>();
            mainCamera = Camera.main.transform;
        }

        private void Update()
        {
            inputVector.x = Input.GetAxisRaw("Horizontal");
            inputVector.y = Input.GetAxisRaw("Vertical");

            HandleMovement();
            // Rotate();
        }

        private void FixedUpdate()
        {
            HandleGravity();
        }

        private void HandleMovement()
        {
            if (inputVector == Vector2.zero)
                return;

            moveDir = new Vector3(inputVector.x, 0, inputVector.y);
            float directionAngle = Mathf.Atan2(moveDir.x, moveDir.z) * Mathf.Rad2Deg + mainCamera.eulerAngles.y;
            moveDir = Quaternion.Euler(0, directionAngle, 0) * Vector3.forward;

            cc.Move(moveDir * speed * Time.deltaTime);
        }

        private Vector3 GetHorizontalVelocity()
        {
            return new Vector3(cc.velocity.x, 0, cc.velocity.z);
        }

        // private void Rotate()
        // {
        //     float cameraAngle = mainCamera.eulerAngles.y;
        //     transform.rotation = Quaternion.Euler(0, cameraAngle, 0);
        // }

        private void HandleGravity()
        {
            // TODO: Change ground detection
            if (cc.isGrounded)
            {
                yVel = 0;
                return;
            }

            yVel += gravity * gravityScale * Time.deltaTime;
            cc.Move(yVel * Time.deltaTime * Vector3.down);
        }
    }
}
