# Firefox Tweaks and Addons

## Addons

|Add On|How It Works / What It Does|Recommended|Notes|
|------|----|:-----------:|-----|
|[uBlockOrigin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)|In-Browser DNS Blocker|V||
|[AdGuard AdBlocker](https://addons.mozilla.org/en-US/firefox/addon/adguard-adblocker/)|In-Browser DNS Blocker|||
|[Tab Session Manager](https://addons.mozilla.org/en-US/firefox/addon/tab-session-manager/)|Saves all tabs on close|V|Fixes Firefox's issue where sometimes Firefox will start with no tabs even if `Open previous windows and tabs` is enabled|
|[audioff](https://addons.mozilla.org/en-US/firefox/addon/audioff-audio-device-selector/)|Allows you to select audio output device for each tab|V||
|[ClearURLs](https://addons.mozilla.org/en-US/firefox/addon/clearurls/)|Removes tracking from URLs|V||
|[NoScript Security Suite](https://addons.mozilla.org/en-US/firefox/addon/noscript/)|JavaScript Blocker||Can be tedious when opening new sites since some site relies heavily on JavaScript to even load|
|[YouTube Nonstop](https://addons.mozilla.org/en-US/firefox/addon/youtube-nonstop/)|Click `Are you still there?` prompt automatically|V|Allows YouTube 24/7 no prompt whatsoever|
|[Return Youtube Dislike](https://addons.mozilla.org/en-US/firefox/addon/return-youtube-dislikes/)|Shows Youtube Dislike Buttun and Dislike Count (Data May be Inaccurate)|V||
|[SponsorBlock - Skip Sponsorships on YouTube](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)|Skips Sponsor Content on YouTube Videos (Data maybe coming from other users)|V|Sometimes it skips something Non Sponsor Content, but its very rare|
|[Translate Web Pages](https://addons.mozilla.org/en-US/firefox/addon/translate-web-pages/)|Using Google Translate to translate selected content or the whole page|V|Sometimes not working|
|[User-Agent Switcher and Manager](https://addons.mozilla.org/en-US/firefox/addon/user-agent-string-switcher/)|Switch your browser User-Agent to fake devices or even version of browser||Useful for Developers|
|[Container proxy](https://addons.mozilla.org/en-US/firefox/addon/container-proxy/)|Allows per tab proxy||Useful for Developers|
|[Firefox Multi-Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)|Almost the same as Firefox's Multi Profile but did not seperate Add-Ons|||
|[Container Tabs Sidebar](https://addons.mozilla.org/en-US/firefox/addon/container-tabs-sidebar/)|Shows tabs on the left and tabs are grouped by container name||Useful if you use Firefox Multi-Account Containers|

## Tweaks

### Enable Old Colorways Theme

1. Open `about:config`
2. Set `browser.theme.retainedExpiredThemes` to String and its value to:

    ```text
    ["elemental-soft-colorway@mozilla.org", "elemental-balanced-colorway@mozilla.org", "elemental-bold-colorway@mozilla.org","graffiti-soft-colorway@mozilla.org", "graffiti-balanced-colorway@mozilla.org", "graffiti-bold-colorway@mozilla.org","lush-soft-colorway@mozilla.org", "lush-balanced-colorway@mozilla.org", "lush-bold-colorway@mozilla.org","foto-soft-colorway@mozilla.org", "foto-balanced-colorway@mozilla.org", "foto-bold-colorway@mozilla.org","cheers-soft-colorway@mozilla.org", "cheers-balanced-colorway@mozilla.org", "cheers-bold-colorway@mozilla.org","abstract-soft-colorway@mozilla.org", "abstract-balanced-colorway@mozilla.org", "abstract-bold-colorway@mozilla.org"]
    ```

3. Save

> Source
>
> [reddit](https://www.reddit.com/r/firefox/comments/uq26ao/bringing_back_your_preferred_colorways/) - the source for this guide  
> [github](https://github.com/FirefoxUX/create-theme-script/tree/master/themes/independent-voices) - seems to be the source of all themes made by Mozilla  

### Lazy Load Pinned Tabs [load only when viewed]

1. Open `about:config`
2. Set `browser.sessionstore.restore_pinned_tabs_on_demand` to Boolean and its value to `true`
3. Save

### Lazy Load Regular Tabs [load only when viewed]

1. Open `about:config`
2. Set `browser.sessionstore.restore_on_demand` to Boolean and its value to `true`
3. Save
