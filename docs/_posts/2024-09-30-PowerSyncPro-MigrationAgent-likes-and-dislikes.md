---
layout: post
title:  "PowerSyncPro Migration Agent likes and competition dislikes"
description: Let's take look at PowerSyncPro Migration Agent to see what I love about the product and loathe about other products
date:   2024-09-30 11:01:58 +0100
category: microsoft-365
tags: microsoft-365 migration
image: /android-chrome-192x192.png
comments_id: 40
---
<h1>{{ page.title }}</h1>

After writing [PowerSyncPro](https://powersyncpro.com) Directory Sync in PowerShell over Christmas in 2018, I added the first migration agent in 2020.  The migration agent is all about making the end user's life easier after migration.  Since then the tool has been rewritten in C# using .Net Core.   I wanted to talk about things I am particularly proud of and also mention areas where I think other tools are lacking.   I'd love to hear your feedback on the product, as I do listen to everything that is said about PowerSyncPro and will often look to incorporate ideas and features into the backlog.

So let's get started with the things that I love about the PowerSyncPro Migration Agent

Scalability

1. **User Centric**

    The thing I am most proud of is that finally there is a migration agent that thinks about the user as the most important piece.   Up to now the focus has been on data migration, and the tools have improved in these areas (although IMHO all of them do have very serious shortcomings too, but that's for another day)  Anyway, back to the user.  The Migration Agent helps the user get up and working after a migration as quickly as possible, be that an Active Directory migration, an M365 migration or going from AD/Hybrid joined to Entra joined.   We will help the user retain their Windows profile and settings, we will put their applications back in a position where they can simply log on and get back to work.  No more long complex instructions about how to unlink OneDrive, or delete credential caches.  Just wait for the agent to do its job, and get back to yours.   We are always looking at and thinking about new ways that we can help the end user.

2. **Predictability**

    We aim for a success rate beyond 99% after initial testing.  We want the tool to be 100% predictable and resilient to the unexpected.  e.g. closing the lid on a laptop while a migration is in progress will obviously stop the migration, but upon the machine being up and running the migration will carry on where it left off.  Similarly with network or power interruptions.   If we see an recurring issue, e.g. a WMI corruption that prevents the agent from performing a task, then rather than stopping the migration or skipping the task we will just fix the corruption on the fly and carry on with the migration.

    Another example is how we handle Bitlocker encrypted devices, we will temporarily disable the protectors to avoid a PIN at startup from holding up the migration and enable the protectors again afterwards, while we then also escrow the recovery keys into AD and Entra ID.

    Predictability is a key goal for us and will always be what we strive for as we continue to innovate.


3. **Security**

    The way the agents communicate with PowerSyncPro is via an initial Pre Shared Key (PSK).  We use that to first authenticate that the agent is really 'valid' to talk to the service, and along with the computer/domain name that trio allows an agent to be granted access to register.  The registration process then upgrades the encryption/signing to public/private keys via certificates.  Each agent has their own certificate which we use within the SSL tunnel to encrypt and sign our payloads.   This way it lessens the risk of man in the middle attacks.   We have had this process externally penetration tested by CQURE who did a great job identifying areas of improvement which we have since undertaken to make the solution as secure as we can make it.

    The migration agent runs as the local system account, this avoids having to have any local admin account on the machine, and guarantees that we can accomplish what we need to get done.  We don't need any special ports opened, as we recommend that you present the PowerSyncPro server using the standard TCP port 443 for https/SSL, but as above we don't trust the SSL and will sign and encrypt everything within that anyway to protect the integrity of the communication, and the machine.

4. **Custom Workflow**

    We added two places during the migration process where you can inject your own scripts, this is at the start of the migration before we leave the source AD/tenant, and at the end of the migration after we have joined the target AD/tenant.  This allows for an unlimited extensibility and customisation of the migration workflow.   We use this for things like replacing End Point Protection with the desired tool from the target, or making registry changes to remove things that were tattooed by policies from the source.   The list is endless really, and anything you can do in command line, PowerShell or any kind of scripting you can do here.  Both of these extension points take the form of a zip file with a cmdline.cmd trigger file that kickstarts the process.  The zip file itself is signed and encrypted for transit to the target computer (using the public key from that specific agent) so that only the machine that receives the zip file can read it.  We extract the zip file contents only when needed and remove them again afterwards, again per the Security comments, we think about security as an integral part of what we deliver.

5. **User Experience**

    A recent addition is the ability to customise pretty much everything about any dialog/message shown to the end user.  This can be configured for multiple languages and the agent will check the user's language settings and show the correct dialog with the correct controls and labels based on their language.  So a single runbook can be sent to machines worldwide and show messages in Chinese, German, French, Spanish, etc with a fall back to a default language which is often English but could be something else too.  You are in control of what is shown to the end user.

6. **Central Logging**

    The migration agent will write messages into the Application Event log on the machine where it is installed, but those messages are also rolled up and sent to the PowerSyncPro server.  From the server you can check on progress of every machine and see the log messages in near real time.  The great thing about this is if you see a pattern, or a specific issue then you can resolve it remotely by making a change to a policy in source or target, or by creating a new runbook or updating an existing runbook.  The migration agent will always check for updates to its assigned runbooks before it starts to execute them, this includes machines that are faltering (since we retry if we encounter something unexpected)   The upshot is that as a migration engineer you can see what is going on, and can often resolve issues without needing to touch the device

7. **Scalability**

    PowerSyncPro works for small and large scale migrations.  The PowerSyncPro server can be scaled up to handle many tens of thousands of machines migrating in parallel.  We have built in controls to avoid the server being overwhelmed including the migration agents retrying if there are issues and the log messages being queued on the device before being rolled up to the server.  We are confident that PowerSyncPro can handle the largest of migrations with ease.   The beauty of the migration agent is that while it needs access to the PowerSyncPro server, it is tolerant to network outages, and the messages between the agent and server are generally small.

## Things I think need work in other tools

1. **Avoid manual intervention**

    Some ISVs require the migration engineer to intervene, e.g. for Offline Domain Join why on earth would you as an engineer want to manually create ODJ blobs and put them on a location that is accessible by multiple machines.  PowerSyncPro handles the ODJ creation internally and they are never persisted and only sent to the agent that specifically requested it.   

    Similarly some ISVs require you to create the SID translation tables and again place them somewhere that multiple machines can read.  SIDs are key information for would-be attackers.  Why do you want to make their life easier by putting them all into one place for them to easily access?   

    Another bugbear is that if a migration agent finds that the target user has already logged onto the device and therefore has a Windows profile.  Some tools will fail the migration and require you to get onto the device and delete the profile and then reattempt the migration.   Doesn't that seem like a bit of a pain?

2. **Security**

    Already mentioned above, having to create ODJ files and translation files and putting them somewhere more public is to me like taking all your valuable possessions and putting them neatly into boxes labelled secret and placing them just outside your front door.  Why would that seem like a good idea?

    Tools that require an administrative account on every device, or that require any network ports other than https are in my opinion just not worth the risk.  Migrations are stressful enough without opening up more attack vectors.

3. **English only**

    The majority of the world does not speak English, so why do you want a tool that requires every end user to speak and understand English?  Surely you want a tool that can adapt to the languages that your business users speak.  A user who can understand what is going on is much less likely to raise a support ticket...

4. **Partial Agents**

    There are many tools there that label themselves as migration agents, but a lot of them only go a part of the way and sometimes only focus on one aspect like Outlook profile only, or they handle device migration but don't take care of the M365 applications.   Why would you want a tool that only does half of the job, how will you take care of the other half?   Are you expecting your users to read a post migration manual?  If so, let me know how successful that was...  We've found that if you think getting users to read a short email from IT is hard, getting them to read an understand a multi page document with instructions on what to do, where invariably the issue they come up against isn't quite in the right sequence based on the document, or the software dialogs are subtly different on the version that they happen to have...   

5. **Shoot and Pray Agents**

   There are some ISVs that have an agent, but without any central control or reporting.  This is a bit like closing your eyes, spinning around 20 times and then try to shoot a basketball into the basket with nothing but net.   It just isn't going to happen.  You need centralised oversight over what is going on with the agents and migrations to get feedback on how things are working, be able to report on how far through the migration you are, and react to warnings and errors you see in near real time.


So there you have it, my picks for things to improve in other tools and for things that I like/love about PowerSyncPro Migration Agent.   I'm sure if you ask someone else on the team or any of our partners, then they will have their own list.  I'd love to hear what is on your list of likes and dislikes!
