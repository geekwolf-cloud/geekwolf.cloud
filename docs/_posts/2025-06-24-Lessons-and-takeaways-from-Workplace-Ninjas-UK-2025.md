---
layout: post
title:  "Lessons and takeaways from Workplace Ninjas UK 2025"
description: The things I learned from Workplace Ninjas UK 2025, some real nuggets and eye-opening threats that I'd not really thought about before
date:   2025-06-24 10:24:13 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 59
---
<h1>{{ page.title }}</h1>


Apologies for the delays in blogging.  I've been working hard on PowerSyncPro and other fun projects that have kept me away from GeekWolf.  I had the pleasure of attending **Workplace Ninjas UK 2025**, it delivered deep technical insights, candid conversations with experts, and some much-needed reality checks around modern identity, security, and endpoint management. Here are some of the standout takeaways and lessons I brought back:

---

## 🔐 Identity & security insights

### Entra External ID limitations

Entra External ID doesn't support multi-tenant application registrations. If you're thinking about managing identities across environments, use a dedicated workforce tenant. Just one tenant is sufficient for the dev, test, staging, prod environments - but **separate authentication from collaboration and infrastructure** responsibilities for better governance and clarity.

### Bypassing app registrations with access tokens

You can use `-AccessToken` with `Read-Host` in PowerShell to authenticate to Microsoft Graph **without app registrations**. Just pull the bearer token from your browser (like in Azure Portal) using developer tools. It's incredibly fast—and **also an enormous attack surface**. Eye-opening in terms of how quickly access can be gained.  Adding Conditional Access and requiring Session Control for token protection helps mitigate risk here.

### Why locking down admin portals matters

This simple misuse of access tokens reinforces **why locking down who can access administrative portals is crucial**. If someone can impersonate a privileged user via token, they’ve got free rein.

### The danger of application ownership

Be careful with assigning **owners** to app registrations and enterprise apps. Owners can create secrets or certificates, effectively assuming the app’s full permissions. Think of it as letting someone **become** the app. If you're not explicitly giving them that power — **don't make them an owner**.

### Enterprise app secret injection

Even though the UI doesn’t expose it, secrets **can** be added to enterprise applications — including those based on multi-tenant app registrations. To lock this down, use the **App Instance Property Lock** on every app registration.

---

## 🧩 RBAC, guests & management

### PIM groups + permanent roles = loophole

Don’t mix **PIM groups with permanent roles** and eligible members. This creates a security gap where users aren’t "elevated", allowing lower-privilege roles (like User Admin) to change their password or reset MFA. That’s a big risk.

### Use restricted management units (RMUs)

Want to protect sensitive accounts and groups? Use **Restricted Management Units** to cordon off access. Only explicitly authorised users should be able to make changes to anything inside these units.

### Lock down guest access

Always block guests from accessing the **Azure portal**, and assign them the most restrictive roles. Without this, any guest account can be used for **reconnaissance** on your tenant—and you'd be surprised how much they can see.

### Decode access tokens with jwt.ms

Need to inspect an access token? Use [jwt.ms](https://jwt.ms/) to instantly parse and decode it. Great tool for debugging and understanding token claims.

---

## 💻 Endpoint security & hardening

A lot of great discussion around securing Windows 11 environments, especially for enterprise. Here's what to enable:

- **Virtualisation-based security (VBS)**
- **LSA protection** (Monitor via Code Integrity event logs)
- **Credential Guard**
- **Custom compliance policies**: Intune defaults just check config—not that features are actually working
- **Windows Hello for Business (WHfB)** with **ESS enabled**
- **Windows LAPS** (in automatic account management mode)
- **BitLocker PIN**: Especially important since kernel DMA protection only kicks in *after* Windows boot
- **Administrator protection**: A system-managed admin account is created—just note it currently clashes with EPM
- **Personal data encryption**: Encrypts files with WHfB keys. Pair this with OneDrive redirection for backup (though note that backup files aren't encrypted)
- **Passwordless web sign-in**: Supported only on Entra-joined devices
- **Multi-factor WHfB unlock**: Combine PIN with biometrics for added protection
- **Token protection**: Stops tokens from being reused on a different device
- **Block legacy Windows Entra joins**: Earlier versions store certificates outside TPM—making them easy to steal. Microsoft is addressing this with AllowRecovery to push certs into TPM on detection

---

## 👋 Conversations that stood out

During a panel discussion, I raised my hand when Autopilot was presented as the *only* supported method for moving from hybrid join to Entra. I challenged that, and Microsoft came back on stage to clarify: while Autopilot is recommended, there **are legitimate cases—like M&A scenarios—where it's not practical**.

I also got the chance to speak with **Adam from Microsoft**, who authored an internal device migration script (minus user profiles). He was already aware of what we’re building with **PSP**, and was genuinely impressed with our work. Always encouraging to see your efforts resonating within Microsoft itself.

---

## Final thoughts

Workplace Ninjas UK never fails to deliver that unique blend of deep dives, real-world war stories, and community wisdom. This year was no different—plenty of new ideas, some strong warnings, and a lot to take back and implement.

Looking forward to putting these insights into practice—and already excited for the next event.
