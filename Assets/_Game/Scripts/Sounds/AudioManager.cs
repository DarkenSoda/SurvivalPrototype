using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }
    [SerializeField] private AudioSource sfxSource;

    // TODO: Add Object Pooling for the audio sources

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this.gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(this.gameObject);
    }

    public void PlaySFXClip(AudioClip clip, Transform spawnPoint, float volume = 1f)
    {
        if (clip == null)
        {
            Debug.LogWarning("Audio clip is null");
            return;
        }

        // instantiate a new game object to play the sound
        AudioSource audioSource = Instantiate(sfxSource, spawnPoint.position, Quaternion.identity);

        // assign the audio clip to the audio source
        audioSource.clip = clip;

        // set the volume
        audioSource.volume = volume;

        // play the sound
        audioSource.Play();

        // destroy the game object after the sound has finished playing
        Destroy(audioSource.gameObject, audioSource.clip.length);
    }

    public void PlaySFXClipRandomPitch(AudioClip clip, Transform spawnPoint, float volume = 1f)
    {
        if (clip == null)
        {
            Debug.LogWarning("Audio clip is null");
            return;
        }

        // instantiate a new game object to play the sound
        AudioSource audioSource = Instantiate(sfxSource, spawnPoint.position, Quaternion.identity);

        // assign the audio clip to the audio source
        audioSource.clip = clip;

        // set random pitch
        audioSource.pitch = Random.Range(0.9f, 1.1f);

        // set the volume
        audioSource.volume = volume;

        // play the sound
        audioSource.Play();

        // destroy the game object after the sound has finished playing
        Destroy(audioSource.gameObject, audioSource.clip.length);
    }

    public void PlayRandomSFXClip(AudioClip[] clips, Transform spawnPoint, float volume = 1f)
    {
        if (clips == null || clips.Length == 0)
        {
            Debug.LogWarning("Audio clips are null or empty");
            return;
        }

        PlaySFXClip(clips[Random.Range(0, clips.Length)], spawnPoint, volume);
    }

    public void PlayRandomSFXClipRandomPitch(AudioClip[] clips, Transform spawnPoint, float volume = 1f)
    {
        if (clips == null || clips.Length == 0)
        {
            Debug.LogWarning("Audio clips are null or empty");
            return;
        }

        PlaySFXClipRandomPitch(clips[Random.Range(0, clips.Length)], spawnPoint, volume);
    }
}
