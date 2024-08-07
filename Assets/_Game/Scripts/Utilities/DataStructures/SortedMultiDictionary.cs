using System;
using System.Collections;
using System.Collections.Generic;

namespace Utilities.DataStructures
{
    public class SortedMultiDictionary<K, V> : SortedDictionary<K, List<V>>
    {
        public void Add(K key, V value)
        {
            if (!ContainsKey(key))
            {
                Add(key, new List<V>());
            }

            this[key].Add(value);
        }

        public bool Remove(K key, V value)
        {
            if (!ContainsKey(key))
            {
                return false;
            }

            return this[key].Remove(value);
        }

        public bool Contains(K key, V value)
        {
            if (!ContainsKey(key))
            {
                return false;
            }

            return this[key].Contains(value);
        }

        public IEnumerable<V> GetValues(K key)
        {
            if (!ContainsKey(key))
            {
                return new List<V>();
            }

            return this[key];
        }

        public IEnumerable<V> GetAll()
        {
            foreach (var values in Values)
            {
                foreach (var value in values)
                {
                    yield return value;
                }
            }
        }
    }
}
