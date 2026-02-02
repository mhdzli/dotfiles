# YouTube Manager (ytmgr)

A YouTube video player and downloader similar to your aria2 download manager (dlmgr).

## Features

- **Play videos** directly from clipboard using ffplay + yt-dlp
- **Download videos** to a queue system
- **Multiple progress views**: Terminal, Notification, or Silent
- **Clipboard integration**: Works with both X11 (xclip) and Wayland (wl-paste)
- **Queue management**: Add, remove, and view download queue
- **Notifications**: Desktop notifications for start, complete, and error states

## Requirements

- `yt-dlp` - YouTube downloader
- `ffplay` (part of ffmpeg) - Video player
- `xclip` (for X11) or `wl-copy`/`wl-paste` (for Wayland)
- `fuzzel`, `dmenu`, `rofi`, or similar menu program (set via $MENU environment variable)
- `notify-send` - For desktop notifications

### Installation

```bash
# Install dependencies (Arch Linux)
sudo pacman -S yt-dlp ffmpeg xclip wl-clipboard fuzzel

# Install dependencies (Debian/Ubuntu)
sudo apt install yt-dlp ffmpeg xclip wl-clipboard fuzzel

# Or using pip for yt-dlp
pip install -U yt-dlp
```

## Setup

1. Copy the scripts to your bin directory (e.g., `~/.local/bin/youtube_manager/`):
   - `ytmgr` - Main script
   - `yt_nf_start` - Start notification helper
   - `yt_nf_complete` - Complete notification helper
   - `yt_nf_error` - Error notification helper

2. Make them executable:
```bash
chmod +x ytmgr yt_nf_start yt_nf_complete yt_nf_error
```

3. Add the directory to your PATH or create a symlink:
```bash
# Option 1: Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin/youtube_manager:$PATH"

# Option 2: Create symlink
ln -s ~/.local/bin/youtube_manager/ytmgr ~/.local/bin/ytmgr
ln -s ~/.local/bin/youtube_manager/yt_nf_start ~/.local/bin/yt_nf_start
ln -s ~/.local/bin/youtube_manager/yt_nf_complete ~/.local/bin/yt_nf_complete
ln -s ~/.local/bin/youtube_manager/yt_nf_error ~/.local/bin/yt_nf_error
```

4. Set your menu program:
```bash
# Add to your shell config (~/.bashrc, ~/.zshrc, etc.)
export MENU="fuzzel -d"  # or dmenu, rofi, etc.
```

## Usage

### Interactive Menu
Simply run:
```bash
ytmgr
```

This will show a menu with options:
- **Play Video** - Play video from clipboard URL immediately
- **Add to Download List** - Add video(s) from clipboard to download queue
- **Start Download** - Begin downloading queued videos
- **Stop Download** - Stop current downloads
- **Remove Link** - Remove video from download queue
- **View List** - View current download queue
- **Edit Config** - Edit yt-dlp configuration options
- **Exit** - Exit the program

### Command Line

```bash
# Add a video to download queue
ytmgr add "https://youtube.com/watch?v=..." "$HOME/Downloads/youtube"

# Start downloading
ytmgr start

# Stop downloading
ytmgr stop

# Play video from clipboard
ytmgr play
```

### Workflow Examples

**Quick Play:**
1. Copy YouTube URL to clipboard
2. Run `ytmgr`
3. Select "Play Video"

**Download for Later:**
1. Copy YouTube URL(s) to clipboard
2. Run `ytmgr`
3. Select "Add to Download List"
4. Choose download directory (or use default: `~/Downloads/youtube`)
5. Select "Start Download"
6. Choose progress display style (Terminal/Notification/Don't Show)

**Batch Download:**
1. Copy multiple YouTube URLs to clipboard (one per line)
2. Run `ytmgr`
3. Select "Add to Download List"
4. Select "All" when prompted
5. Select "Start Download"

## Configuration

### Configuration File
All yt-dlp options are managed through a config file at:
```
~/.local/share/ytmgr/config
```

The config file is automatically created on first run with all available options commented out. You can edit it:
- Through the menu: Run `ytmgr` → Select "Edit Config"
- Directly: `nano ~/.local/share/ytmgr/config` (or use your preferred editor)

### Available Configuration Options

#### Browser Cookies (for age-restricted/member-only content)
```bash
COOKIES_BROWSER="firefox"
# Options: chrome, firefox, safari, edge, chromium, brave, opera, vivaldi
```
This extracts cookies from your browser, allowing you to access:
- Age-restricted videos
- Member-only content
- Private videos you have access to

#### Authentication (for premium content)
```bash
# Regular login
USERNAME="your_email@example.com"
PASSWORD="your_password"

# Or OAuth2 (recommended for Google accounts)
USERNAME="oauth2"
PASSWORD=""
```

#### User Agent (avoid blocks/restrictions)
```bash
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
```
Useful for bypassing regional restrictions or bot detection.

#### Video Format/Quality
```bash
# Default: Best video up to 1080p with best audio
FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]"

# 4K videos
FORMAT="bestvideo[height<=2160]+bestaudio/best"

# 720p max (smaller files)
FORMAT="bestvideo[height<=720]+bestaudio/best"

# Audio only
FORMAT="bestaudio/best"

# Specific codec preference
FORMAT="bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
```

#### Rate Limiting (bandwidth control)
```bash
RATE_LIMIT="1M"    # 1 MB/s
RATE_LIMIT="500K"  # 500 KB/s
```

#### Proxy Settings
```bash
PROXY="http://proxy.example.com:8080"
PROXY="socks5://127.0.0.1:9050"  # Tor
```

#### Subtitles
```bash
# Auto-generated subtitles in English
SUBTITLES="--write-auto-sub --sub-lang en"

# Multiple subtitle languages
SUBTITLES="--write-sub --sub-lang en,es,fr"

# Embed subtitles in video
SUBTITLES="--write-auto-sub --sub-lang en --embed-subs"
```

#### Geo Bypass
```bash
# Bypass geographical restrictions
GEO_BYPASS="--geo-bypass"

# Bypass with specific country
GEO_BYPASS="--geo-bypass --geo-bypass-country US"
```

#### Extra Options
```bash
# Combine multiple options
EXTRA_OPTS="--no-playlist --embed-thumbnail --embed-metadata --add-metadata"

# Skip ads and sponsors (with SponsorBlock)
EXTRA_OPTS="--sponsorblock-mark all --sponsorblock-remove sponsor"

# Download only recent videos from a channel
EXTRA_OPTS="--dateafter now-1week"
```

### Common Configuration Examples

**For age-restricted videos:**
```bash
COOKIES_BROWSER="firefox"
```

**For premium YouTube content:**
```bash
USERNAME="oauth2"
PASSWORD=""
COOKIES_BROWSER="firefox"
```

**For slow connections:**
```bash
RATE_LIMIT="500K"
FORMAT="bestvideo[height<=720]+bestaudio/best"
```

**For audio podcasts/music:**
```bash
FORMAT="bestaudio/best"
EXTRA_OPTS="--embed-thumbnail --add-metadata"
```

**For archival (best quality + metadata):**
```bash
FORMAT="bestvideo+bestaudio/best"
EXTRA_OPTS="--embed-thumbnail --embed-metadata --embed-subs --write-description --write-info-json"
```

**Through VPN/Proxy:**
```bash
PROXY="socks5://127.0.0.1:9050"
GEO_BYPASS="--geo-bypass-country US"
```

### Data Directory
All configuration and queue files are stored in:
```
~/.local/share/ytmgr/
├── config        # Configuration file for yt-dlp options
├── dl_list       # Current download queue
├── dl_completed  # Completed downloads log
└── dl_error      # Failed downloads log
```

### Download Directory
Default: `~/Downloads/youtube`

You can change this by:
1. Editing the `dl_dir` variable in the `ytmgr` script, or
2. Choosing a different directory each time you add a video

## Keyboard Shortcuts

You can bind `ytmgr` to keyboard shortcuts in your window manager. For example:

```bash
# In i3/sway config
bindsym $mod+y exec ytmgr

# In Hyprland
bind = $mod, Y, exec, ytmgr
```

Or create specific shortcuts for different actions:
```bash
# Play immediately
bindsym $mod+Shift+y exec ytmgr play

# Add to queue
bindsym $mod+Ctrl+y exec ytmgr add "$(wl-paste)" "$HOME/Downloads/youtube"
```

## Troubleshooting

**Video won't play:**
- Check if yt-dlp and ffplay are installed
- Try updating yt-dlp: `pip install -U yt-dlp` or `sudo pacman -S yt-dlp`
- Check if the URL is valid

**Clipboard not working:**
- For X11: Install `xclip`
- For Wayland: Install `wl-clipboard`

**Menu doesn't appear:**
- Make sure `$MENU` environment variable is set
- Test your menu: `echo "test" | $MENU`

**Downloads fail:**
- Check internet connection
- Update yt-dlp (video sites change frequently)
- Check if the video is age-restricted or requires login
  - Try enabling browser cookies: `COOKIES_BROWSER="firefox"` in config
  - For members-only content, add authentication to config
- Try with a different format in the config file

**Age-restricted videos won't play/download:**
- Edit config: `ytmgr` → "Edit Config"
- Uncomment and set: `COOKIES_BROWSER="firefox"` (or your browser)
- Make sure you're logged into YouTube in that browser

**Member-only or private videos:**
- Set up authentication in the config file
- Use OAuth2 for Google accounts:
  ```bash
  USERNAME="oauth2"
  PASSWORD=""
  ```

## Notes

- Videos are downloaded in best quality up to 1080p by default
- The script validates URLs to ensure they're YouTube links
- Download queue persists between sessions
- Notification IDs (2226-2227) are different from dlmgr (2224-2225) to avoid conflicts
