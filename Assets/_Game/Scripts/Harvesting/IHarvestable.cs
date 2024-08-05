namespace Game.Harvesting
{
    public interface IHarvestable
    {
        HarvestableType Type { get; }
        void Harvest(int damage);
    }
}
