#!/bin/bash
# Dependencies: ffmpeg, yt-dlp, jq (optional)

# Set your YouTube API key if needed for metadata retrieval (optional)
API_KEY="YOUR_YOUTUBE_API_KEY"

# Function to fetch metadata (optional)
fetch_metadata() {
    video_id=$(echo $1 | sed 's/.*v=\([^&]*\).*/\1/')
    curl -s "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=${video_id}&key=${API_KEY}" | jq '.items[0].snippet.title'
}

if [ -z "$1" ]; then
    echo "Usage: $0 <youtube-url> [more-youtube-urls...]"
    exit 1
fi

for VIDEO_URL in "$@"
do
    # Fetch metadata (optional, can be used for playlist metadata too)
    TITLE=$(fetch_metadata "$VIDEO_URL")
    echo "Downloading: ${TITLE:-Video}"

    # Download the YouTube video(s) or playlist and extract audio to high-quality MP3
    yt-dlp -x --audio-format mp3 --audio-quality 0 "$VIDEO_URL" -o "%(playlist_title)s/%(title)s.%(ext)s"

    echo "Downloaded and converted to MP3: ${TITLE:-File}"
done
