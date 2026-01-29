import os
import sys
import requests

# ===================================================================
# Utility function to log messages to standard error
# ===================================================================
def log(msg: str):
    """
    Print log messages to stderr to separate from standard output
    used for workflow outputs (VERSION, FOUND).
    """
    print(msg, file=sys.stderr)

# ===================================================================
# Check if a URL exists (HTTP status 200)
# ===================================================================
def url_exists(url: str) -> bool:
    """
    Sends a HEAD/GET request to the URL and returns True if the
    resource exists (status code 200), False otherwise.
    """
    try:
        headers = {
            "User-Agent": (
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/120 Safari/537.36"
            )
        }
        # Use GET with streaming to avoid downloading large files
        r = requests.get(url, headers=headers, timeout=10, stream=True)
        r.close()
        return r.status_code == 200
    except Exception as e:
        log(f"Request error: {e}")
        return False

# ===================================================================
# Main script
# ===================================================================

def main():
    """
    Determines the next available game version for the specified channel.
    Prints workflow outputs for GitHub Actions:
      - VERSION=<version number>
      - FOUND=true/false
    """
    # -------------------------------------------------------------------
    # Read environment variables
    # MANUAL_VER : optional manual version override
    # CHANNEL    : release channel (release / pre-release)
    # LAST_KNOWN_VER : last version found in GitHub releases
    # -------------------------------------------------------------------
    manual_version = os.getenv("MANUAL_VER", "").strip()
    channel = os.getenv("CHANNEL", "release")
    last_known = int(os.getenv("LAST_KNOWN_VER", "0"))

    # -------------------------------------------------------------------
    # Handle manual version trigger
    # -------------------------------------------------------------------
    if manual_version:
        log(f"Manual trigger: v{manual_version} ({channel})")
        print(f"VERSION={manual_version}")
        print("FOUND=true")
        return

    # -------------------------------------------------------------------
    # Determine next version automatically
    # -------------------------------------------------------------------
    next_version = last_known + 1

    # Construct patch URL for the given channel and version
    url = (
        f"https://game-patches.hytale.com/patches/"
        f"windows/amd64/{channel}/0/{next_version}.pwr"
    )

    log(f"Checking {channel} v{next_version}")
    log(f"URL: {url}")

    # -------------------------------------------------------------------
    # Check if the patch exists
    # -------------------------------------------------------------------
    if url_exists(url):
        log("New version found")
        print(f"VERSION={next_version}")
        print("FOUND=true")
    else:
        log("No update found")
        print("FOUND=false")

# ===================================================================
# Entry point
# ===================================================================
if __name__ == "__main__":
    main()
