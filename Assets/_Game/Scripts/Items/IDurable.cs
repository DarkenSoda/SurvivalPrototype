using System;

namespace Game.Items.Data
{
    public interface IDurable
    {
        float CurrentDurability { get; set; }
        event Action OnDurabilityChanged;
    }
}
