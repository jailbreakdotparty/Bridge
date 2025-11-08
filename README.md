# Bridge
### An *internal* app opener & extractor for jailed iDevices running iOS 16.0 - 26.0.1. (limited support for 26.1+)
[Latest Release](https://github.com/jailbreakdotparty/Bridge/releases/latest) • [Support Server](https://jailbreak.party/discord) • [Website](https://jailbreak.party) • [Documented Applications (coming soon)]()

> **For people with limited support:** You'll be able to open most of the applications listed inside of the "Documented Applications" link, however, exporting bundles will not be possible for most. Also, you will not be using an applist that's generated from your own device, so any new applications added after 26.0.1 will not appear, and some applications listed may not open properly.

> [!WARNING]
> This tool does **not** show any applications that were installed by the user. If you are looking to see both user-installed applications and internal ones, or if you are on iOS 26.1+ and want to get around the limitations listed, consider using [Antrag](https://github.com/khcrysalis/Antrag).

### What is an internal application in this situation?
- These are applications such as view services and UI testing applications, which are not normally readable or openable to the user. They don't appear anywhere in SpringBoard or the Settings app, but some of these applications could give your device more functionality or are just fun to play around with. 

### Readable Partitons
- `/Applications`: This is where most internal applications live, such as view services and UI testing applications. Some non-removable stock apps also live here too, such as the Phone and Messages app.
- `/System/Library/CoreServices`: This is where some of the other internal applications live, including stuff like SpringBoard. It seems that more important and central internal applications live here, which are relied on by the system.

### Features
- Open Application: This one is self-explaintory, but there's two methods to opening an application. The first one uses a Private API, and is usually the default. The second one uses the shortcuts app, and should be used if the first method fails. You can change the method for opening the application by clicking the icon in the top-right.
- Export Application Bundle: This exports the bundle of the application, which is basically the application's core files. **This tool cannot extract these application's containers.**
- Favorite Applications: You can favorite applications you want to get to quickly. They'll show up in the "Favorites" dropdown.

## Sounds great. How do I set it up?
1. Install the [Bridge Helper Shortcut](https://jailbreak.party/bridge-helper) onto your iPhone/iPad.
2. Sideload Bridge using your preferred method.

### If you are on iOS 16.0 - iOS 26.0.1 and want to fetch applications from your own device (recommended):
4. Open Bridge, and click "Begin Setup."
5. This will redirect you to the Shortcuts app. Wait patiently for your applist to be generated. This should take less than 30 seconds.
6. Once completed, re-open Bridge, and click "Import Applist."
7. Profit 🔥

### If you are on iOS 26.1+ or do not want to fetch applications from your own device:
4. Click either "Skip & Use Static Applist" or "Continue."
5. Done 🔥
