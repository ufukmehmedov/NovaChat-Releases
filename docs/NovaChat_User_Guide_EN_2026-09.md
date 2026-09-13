# NovaChat User Guide

Plain-language guidance for users without technical experience.

**English edition - September 2026 - NovaChat 0.7.21**  
**Public distribution:** `v0.7.21-dist.9`  
**Components:** Android `0.7.21-android-alpha45` - Linux `0.7.21-alpha24` - Windows `0.7.21-alpha25` - NovaRelay `0.7.21-alpha7`

Ruen IT Services - *Privacy in mind. Reliability in practice.*

> NovaChat is designed to give people more control over the infrastructure behind private conversations. This guide explains the system in practical language and avoids unnecessary technical detail.

## 1. Why does NovaChat exist?

NovaChat began with a simple question: when we have a private conversation, why should the entire communication infrastructure depend on systems that we cannot see or control?

The goal is not to copy other messaging apps. The goal is to offer a simpler and more transparent communication model for people who want more control over the infrastructure they use.

### Core ideas

- **Privacy by default.** Encryption is not a feature added later; it is a basic behavior of the system.
- **Infrastructure control.** The communication server - the relay - can run on infrastructure chosen by users or an organization.
- **No unnecessary data collection.** NovaChat does not aim to build a central account around a phone number, advertising profile, or uploaded address book.
- **Local-first behavior.** If a recipient is offline, a private message waits on the sender device instead of being stored on the relay.
- **Simplicity.** The intended flow is simple: connect, see the person, write the message, send it.
- **Transparency.** The relay cannot read message content, but it can see some technical connection data needed to operate the service.

NovaChat is still alpha software. The interface and some commands may change. This guide reflects the September 2026 generation of NovaChat, with dist.9 as the public binary baseline.

## 2. How does NovaChat work?

### Your device

Your Android phone, Windows PC, or Linux computer runs the NovaChat client. You write the message on your device, and the message is encrypted on that device.

### The relay server

The relay is the meeting point where users find each other and encrypted packets are routed to the correct person. The relay is not intended to be a permanent archive of private messages.

Think of the relay as a courier that routes closed and sealed envelopes to the right person. It knows who the envelope is for, but it cannot read what is inside.

### The other person's device

If the other person is online, the encrypted message passes through the relay and is opened only on the recipient's device.

### If the other person is offline

For private messages, the message is not kept on the relay. It waits on the sender's device and is sent when the recipient comes online again. Up to 3 private messages can wait for one offline user.

Broadcast is different: it is a live message area. Someone who is not online at that moment will not receive the Broadcast message later.

### What can the relay see?

The relay cannot read the text of a message. To operate the connection, however, some technical data is visible: the connection IP address, the chosen display name, a technical device identifier, online/offline status, and connection times.

End-to-end encryption protects message content. It does not mean that the Internet leaves no technical traces at all.

## 3. Installation

Official releases: https://github.com/ufukmehmedov/NovaChat-Releases/releases

### Android

1. Open the official release page and download the newest NovaChat Android APK.
2. Tap the APK file. If Android asks for permission to install from that source, allow it only for the official NovaChat APK you downloaded.
3. Open NovaChat. On first launch it asks for a display name, relay address, and relay password.

NovaChat is distributed as an APK outside the Play Store, so Android may request an additional confirmation. Download only from the official NovaChat-Releases page.

### Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.ps1 | iex
```

Then open a new PowerShell window and start NovaChat with:

```powershell
novachat
```

The installer is designed for the normal user profile and does not require running PowerShell as Administrator.

### Linux

Open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.sh | bash
```

Then start NovaChat with:

```bash
novachat
```

## 4. First launch and connection

You need three things: a name, a relay address, and a relay password.

1. **Enter your name.** This is the display name other users will see. It is not a phone number or email account.
2. **Enter the relay address.** Example: `novachat.ruenitservices.com:7778`.
3. **Do not add `http://` or `https://`.** The relay is not a web page.
4. **Enter the relay password.** This password is used to connect to the relay. It is different from the phone lock or optional NovaChat app lock.
5. **Check the connection.** When the relay status becomes online, Contacts begins to show Broadcast and users.

### Retrying and errors

`Retrying...` means a temporary network problem and NovaChat will retry automatically. A red `ERROR:` means a problem that requires action - for example an incorrect relay password, invalid relay address, or a relay host that does not exist.

Do not use `/resetprofile` as the first response to a normal connection problem. It clears local relay profiles and E2EE identities.

## 5. Getting to know the main screen

The main areas are:

- **Status** - current connection state to the relay.
- **Relay** - the relay address currently in use.
- **Security: E2EE enabled** - indicates that message content is protected with end-to-end encryption.
- **Contacts** - Broadcast and individual contacts.
- **Commander** - the input area for messages and commands. `/help` is always available.

NovaChat supports English, Bulgarian, and Turkish UI/status text. The current development source contains a broader status-localization pass planned for the next public binary distribution after dist.9.

## 6. Private chat

1. Open a person. On Android, tap the name. On Windows/Linux, select the person and press Enter.
2. Write the message in the input field.
3. On Android tap Send; on desktop press Enter.

If the person is online, the message is encrypted immediately and routed through the relay.

If the person is offline, the private message waits on your device and is sent when the person comes online again. Up to 3 messages can wait for the same offline user.

NovaChat preserves the real time when a waiting message was originally written. If it is delivered on a later day, the original date is shown as well.

### Edit your last message

In a private conversation, type `/edit` to change your most recent outgoing message. NovaChat places the old text back in Commander so you can edit it and submit the replacement.

The dist.9 desktop fixes corrected a race where the first Backspace or typed character could previously be lost after `/edit`.

Broadcast messages are live messages and are not edited later.

### Clear local chat history

Type `/clear` inside an open conversation to remove the local history of that conversation from your device. This does not delete the other person's copy.

## 7. What is Broadcast?

Broadcast is not a permanent group-chat archive. It is a live message area for short messages to everyone currently connected to the same relay.

Three rules:

1. Only people who are online at that moment receive it.
2. There is no offline queue.
3. It is not designed as permanent chat history.

Use Broadcast for short live announcements. Use private chat when a message is for one person, should be delivered later if that person is offline, or should remain as local private-chat history.

## 8. Background operation and notifications

On Android, NovaChat is designed to maintain the relay connection in the background when Android and the network allow it.

A small connection indicator shows that the NovaChat background service is running. An envelope icon indicates an unread message.

Useful commands:

- `/notificationon` - enable unread-message notifications.
- `/notificationoff` - disable unread-message notifications.
- `/notificationtest` - test notifications.
- `/soundon` - enable new-message sound.
- `/soundoff` - disable new-message sound.
- `/soundtest` - test message sound.

### Switching between Wi-Fi and mobile data

NovaChat watches Android network changes and wakes the connection logic when connectivity returns. Android alpha45 improved retry behavior around DNS/socket errors and stale connection workers, reducing the risk of getting stuck in a `Waiting for internet` state after network changes.

A brief Wi-Fi/LTE handover can still cause a short reconnect. The important behavior is automatic recovery instead of remaining stuck indefinitely.

## 9. Using more than one relay

Each relay is a separate world. NovaChat can keep more than one relay profile on one device, for example separate relays for Family, Work, and Friends.

Users, messages, contacts, and cryptographic identity belonging to one relay are never mixed with another relay.

### Add a relay

Type:

```text
/relayadd
```

NovaChat asks for a relay profile label, relay address, and relay password.

### Manage relays

- `/relays` - show saved relay profiles.
- `/relayconnect R2` - connect R2.
- `/relaydisconnect R2` - disconnect only R2.
- `/relayremove R2` - remove the R2 profile and its local data.

The primary relay profile R1 cannot be removed directly with `/relayremove`. Use `/resetprofile` only when a full reset is intentionally required.

## 10. Security and privacy

### End-to-end encryption (E2EE)

A message is encrypted on the sender's device and opened on the recipient's device. The relay routes the encrypted packet and cannot read the message text in plaintext.

The relay is also designed to reject unencrypted text-message payloads, adding protection against accidentally sending a normal chat message without encryption.

### App lock

`/secureon` makes NovaChat request the phone's fingerprint, PIN, password, or pattern when the app is opened. This is different from E2EE: E2EE protects a message over the network; `/secureon` protects access to the app on the phone.

- `/secureon` - enable device-credential protection.
- `/secureoff` - disable app-entry protection.

### What the relay can see

The relay can see technical connection data such as IP address, visible display name, technical device identifier, online/offline status, and connection times.

The relay cannot read message text, plaintext private-message content, the message before encryption, or a decryption key.

A display name is not the same as cryptographic identity. A fresh installation or `/resetprofile` can create a new technical identity.

## 11. Commands - quick reference

| Command | What it does |
|---|---|
| `/help` | Open Help with the command list. |
| `/clear` | Clear local history of the open conversation. |
| `/edit` | Edit your latest outgoing private message. |
| `/cancel` | Cancel an active edit flow. |
| `/clearoffline` | Remove unnecessary old offline contacts while preserving relevant unread/pending state. |
| `/changename` | Change your visible name. |
| `/notificationon` | Enable unread-message notifications. |
| `/notificationoff` | Disable unread-message notifications. |
| `/notificationtest` | Test notifications. |
| `/soundon` | Enable new-message sound. |
| `/soundoff` | Disable new-message sound. |
| `/soundtest` | Test message sound. |
| `/secureon` | Require the phone lock when opening NovaChat. Android only. |
| `/secureoff` | Disable app-entry lock. Android only. |
| `/relays` | Show saved relay profiles. |
| `/relayadd` | Add a new relay profile. |
| `/relayconnect R2` | Connect R2. |
| `/relaydisconnect R2` | Disconnect R2. |
| `/relayremove R2` | Remove local R2 profile. R1 cannot be removed this way. |
| `/++` | Increase text size one step. Android only. |
| `/--` | Decrease text size one step. Android only. |
| `/resetprofile` | Reset the complete local NovaChat profile. Last resort. |
| `/quit` | Exit the desktop client. In dist.9 Ctrl+C no longer exits NovaChat. |

On Android you can open people and channels by tapping. On desktop, use arrow keys + Enter. Commander is mainly for messages, settings, and special actions.

## 12. Updates, local data, and changing devices

The Windows and Linux installers are designed to preserve the existing NovaChat profile and local data. On Android, a new APK signed with the same NovaChat signing key updates the existing app without requiring a new setup.

Windows and Linux check the official NovaChat-Releases source when starting. If a newer version is available, NovaChat asks for confirmation. The package is downloaded and verified before installation and restart.

Android also checks official releases. If an update exists, NovaChat offers Install / Not now, verifies SHA-256 and application signing, and then opens the Android package installer.

Automatic checking does not mean silent installation. Updates happen only after user confirmation.

Private-chat history is stored locally on the device. Moving to another device does not automatically transfer the old device's history.

`/resetprofile` deletes local relay profiles, contacts, and E2EE identities and returns NovaChat to first-run setup.

## 13. Troubleshooting

### Retrying or ERROR

- For `Retrying...`, check Internet access first; NovaChat retries automatically with controlled delays.
- For red `ERROR:`, verify that the relay address uses `host:port` without `http://` or `https://`.
- If the error is about the password, do not repeatedly retry the same wrong password.
- For an ordinary network interruption, do not reset the profile; NovaChat is designed to reconnect when the network returns.

### The other person looks offline but says they have Internet

A working Internet connection and an open NovaChat relay connection are not identical. Wi-Fi/5G switching, NAT changes, or a brief outage can interrupt a socket for a few seconds. Android alpha45 improved automatic recovery after such transitions.

### Desktop input, clipboard, and mouse notes for dist.9

- Linux multiline paste remains editable until Enter; password paste stays masked.
- Windows supports paste fallbacks for Ctrl+V, Shift+Insert, and right-click input events.
- Ctrl+C no longer exits NovaChat; use `/quit`.
- Windows 10 classic Console Host right-click/selection copy remains a known limitation. Windows Terminal is preferred when available.
- Linux wheel parsing was improved. Under tmux, mouse-wheel navigation may need an explicit tmux binding; arrow keys and PageUp/PageDown remain available.

## 14. Good usage habits

- Share the relay address and password only with people you trust.
- Do not write the relay address as a web URL; do not add `http://` or `https://`.
- Download new versions only from the official NovaChat-Releases page.
- Use a screen lock on your phone; if you want, also protect NovaChat with `/secureon`.
- Do not use Broadcast as a permanent group chat; use it for live announcements.
- Prefer private chat for important two-person conversations.
- For connection problems, check the network and relay details before resetting the profile.
- If you use more than one relay, know which group labels such as R1/R2 belong to.

### Frequently asked questions

**Does NovaChat need my phone number?**  
No. NovaChat does not use a central phone-number account model.

**Can the relay read my messages?**  
Message text is end-to-end encrypted; the relay cannot read the content in plaintext.

**So the relay sees absolutely nothing?**  
No. Connection metadata such as IP address, display name, technical device identifier, online status, and timing information can be visible.

**Can I write to someone who is offline?**  
Yes. In private chat, up to 3 messages can wait on your device and will send when the person comes online.

**Will Broadcast be delivered later to someone who was offline?**  
No. Broadcast is live and happens in the moment.

**If I leave the app, does the connection stop?**  
On Android, the background service may continue while the system and network allow it. On Windows/Linux, the connection exists while the NovaChat process is running.

**Can two people use the same display name?**  
Yes. Display name alone is not identity; NovaChat uses separate technical device identities in the background.

**Will I see users from another relay?**  
No. Relay profiles are isolated from one another.

## 15. 60-second quick start

1. Install NovaChat from the official source.
2. Enter your name.
3. Enter the relay address, for example `novachat.ruenitservices.com:7778`, without `http://`.
4. Enter the relay password provided by the administrator.
5. When Status becomes online, choose a person.
6. Write and send the message. If the person is offline, a private message waits on your device.
7. If you cannot find something, type `/help`.

**NovaChat in one sentence:** A simple communication tool that uses relay infrastructure you choose, encrypts message content end to end, and keeps data on the user's device when possible.

## Release update: v0.7.21-dist.9

Public distribution published 13 September 2026.

Public component versions:

- Android `0.7.21-android-alpha45`
- Linux `0.7.21-alpha24`
- Windows `0.7.21-alpha25`
- NovaRelay `0.7.21-alpha7`

### Desktop reliability changes

- Linux drains buffered input reliably and keeps pasted text editable until Enter. Multiline paragraph structure is preserved and password paste remains masked.
- Windows adds paste fallbacks for Ctrl+V, Shift+Insert, and right-click input records. Ctrl+C no longer closes NovaChat; `/quit` is the explicit desktop exit command.
- `/edit` applies the prefilled message before processing the first editing key, fixing the lost-Backspace / lost-first-character race.
- Linux recognizes SGR/X10 mouse-wheel reports without letting mouse escape sequences leak into chat text.
- Terminal/input modes are restored more safely on exit, closing a Linux secret-paste echo window.

### Known limitations in dist.9

- Windows 10 classic Console Host right-click/selection copy is not fully resolved; native Windows 10/11 clipboard acceptance remains partly unverified.
- Under tmux, wheel navigation can depend on tmux bindings and mouse mode. Arrow keys and PageUp/PageDown remain the dependable fallback.
- Physical Linux clipboard acceptance and online edit confirmation remain partly unverified.

### Current development source after dist.9

The current development source also contains a focused EN/BG/TR localization pass for status messages, notifications, navigation, edit/cancel flows, queued-message text, delivery states, and connection/error messages. That localization pass is newer than the dist.9 public binaries and is intended for the next distribution.

---

**Ruen IT Services**  
*Privacy in mind. Reliability in practice.*

NovaChat - more control and fewer unnecessary intermediaries in private communication.
