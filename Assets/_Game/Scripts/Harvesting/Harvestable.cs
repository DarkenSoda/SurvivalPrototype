using Game.Items;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Game.Harvesting
{
    public class Harvestable : MonoBehaviour, IHarvestable
    {
        [SerializeField] private HarvestData data;
        public HarvestableType Type => data.Type;

        private int currentHealth;

        private void Awake()
        {
            currentHealth = data.MaxHealth;
        }

        public void Harvest(int damage)
        {
            currentHealth -= damage;

            if (currentHealth <= 0)
            {
                DropItems();
                Destroy(gameObject);
            }
        }

        private void DropItems()
        {
            foreach (var drop in data.Drops)
            {
                for (int i = 0; i < Random.Range(drop.MinAmount, drop.MaxAmount + 1); i++)
                {
                    float randomOffsetX = Random.Range(-data.RandomOffset, data.RandomOffset);
                    float randomOffsetY = Random.Range(-data.RandomOffset, data.RandomOffset);
                    float randomOffsetZ = Random.Range(-data.RandomOffset, data.RandomOffset);
                    Vector3 randomOffsetVector = new Vector3(randomOffsetX, randomOffsetY, randomOffsetZ);
                    Vector3 spawnPosition = transform.position + data.DropOffset + randomOffsetVector;

                    var droppedItem = Instantiate(drop.ItemData.DroppedItemData.DroppedPrefab, spawnPosition, Quaternion.identity);
                    droppedItem.Initialize(drop.ItemData);
                }
            }
        }
    }
}
