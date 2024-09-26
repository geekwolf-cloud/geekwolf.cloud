---
layout: post
title:  "What do I like about PowerSyncPro DirSync and dislike about the competition"
description: Let's take look at PowerSyncPro Directory Sync to see what I love about the product and loathe about other products
date:   2024-09-24 08:20:13 +0100
category: microsoft-365
tags: microsoft-365 migration
image: \android-chrome-192x192.png
comments_id: 39
---
<h1>{{ page.title }}</h1>

I first wrote [PowerSyncPro](https://powersyncpro.com) Directory Sync in PowerShell over Christmas in 2018.  Since then the tool has been rewritten in C# using .Net Core.   I wanted to talk about things I am particularly proud of and also mention areas where I think other tools fall down.   I'd love to hear your feedback on the product, as I do listen to everything that is said about PowerSyncPro and will often look to incorporate ideas and features into the backlog.

So let's get started with the things that I particularly love

1. **Architecture**

    I like the architecture that underpins PowerSyncPro.  It makes the code easier to understand and follow even to someone like me who while I'm half decent at scripting and used to program several decades ago, I definitely do not class myself a .Net developer.  I also like that we have the remote agents (Sync, Password and soon to be added Proxy) which gives you much more choice around how you deploy PowerSyncPro, taking into account hard network boundaries, security boundaries and operational boundaries.  It also opens the way to SaaS as you can have those agents on premises for Active Directory, but leave the rest in Azure or another cloud provider.

2. **Performance**

    I am always mindful about performance.  PowerSyncPro Directory Sync was definitely built with performance in mind.   We run as many jobs in parallel as possible, unlike tools like Entra Connect Sync which does on job at a time, we will run all the imports at once, and then as soon as the imports are finished to allow a sync job to run then the sync job will kick off. The same with the export job, as soon as the syncs for that target directory are done then we will run the export.   This is what allows PowerSyncPro at a customer to delta sync 14 directories, with 500k users and around 20 million attributes in approximately 1 minute.  Even doing full imports and syncs run incredibly fast, making PowerSyncPro a very valuable Agile-like tool where you can make configuration changes and check the impact of those changes much more quickly than even the goliaths in this space.

I would go as far to say that I have never seen any directory synchronisation tool that is as efficient and performant as PowerSyncPro.

3. **Security**

    We talked about PowerSyncPro being built from the ground up with performance in mind, well the same is true for security.   There is always more work to do on security, and there will be changes around supporting administrators coming from Entra ID and the likes, but within PowerSyncPro we always check on security of the code.   The way the agents communicate with PowerSyncPro is via an initial Pre Shared Key (PSK).  We use that to first authenticate that the agent is really 'valid' to talk to the service, and along with the computer/domain name that trio allows an agent to be granted access to register.  The registration process then upgrades the encryption/signing to public/private keys via certificates.  Each agent has their own certificate which we use within the SSL tunnel to encrypt and sign our payloads.   This way it lessens the risk of man in the middle attacks.   We have had this process externally penetration tested by CQURE who did a great job identifying areas of improvement which we have since undertaken to make the solution as secure as we can make it.

    It is recommended that you run PowerSyncPro using Group Managed Service Accounts (gMSA) for the best security.  That way the encryption keys that we use for sensitive data within the database is protected using DPAPI NG to the gMSA, making it harder to gain access to that sensitive data.  Using encryption outside of the database itself also means that database backups are protected since you need the encryption keys to gain access to the data.

4. **Complex Expressions**

    Complex Expressions in PowerSyncPro can be used when scoping which objects you want to sync, when matching a source object to a target object, and when mapping attribute values into the target object.   These expressions are essentially nested if/then/else statements with your own C# code as expressions.   Things like take the left part of mail becomes mail.Split('@')[0], or make displayName a combination of first name and last name becomes givenName + " " + sn.   These expressions can of course get way more sophisticated, and so far we've not yet found something that we can't do with complex expressions.  We can always add our own helper methods, so we have the ability to extend the permitted language elements within the C# snippets.  Incredibly powerful while retaining the performance we expect (BTW the example above of the large client is one who uses many complex expressions, so we know it scales pretty well.

5. **Scheduling**

    I am particularly proud of the schedule screen.  This is built by PowerSyncPro based on the sync profiles you have, and that you have said you want to run on the schedule.   The screen allows you to see at a glance all the jobs that will run, how they are nested and you can interact with those jobs through right clicking on the names.   This means that when you are operating PowerSyncPro after doing the configuration, you will spend most of your time on this screen and then branching off to reporting by clicking on the hyperlinked numbers for warnings and errors, which brings me nicely onto my last item in this list

6. **Reporting**

    Directory Sync reporting can't be talked about without talking about whatif, single object report and the message log.   

    The whatif report is a report that shows you what will happen when the next export runs.  It is an approval gate after configuration changes have been made.  So after you create a sync profile or make a change to one, then that sync profile won't export until you have verified the whatif report to ensure PowerSyncPro will do what you expect and not just what you asked.  This is a huge and important safety net that allows you to experiment with configuration changes and check on the impact before releasing that change into your live environment.

    The single object report allow you to see everything we know about a single object.   You will be able to see 
    * the relationships that this object has with others (it might be a source or target object)
    * the attributes that the object has and will have after the next sync
    * for computers, you can see the migration batches that this computer is a part of
    * for users, you can see the computers that this user has a Windows profile on
    * errors/warnings from the logs are also shown for this single object

    Finally the message log...  we touched on this in Schedule as the message log is the raw log of all Directory Sync messages, which are filtered when you click on the hyperlinked number of errors or warnings in the schedule.  The aim here is to give you good actionable messages including the context so you can find and resolve issues as quickly as possible

## Things I think need work in other tools

1. **Software as a Service (SaaS)**

    The fact that other tools run on SaaS is often touted as an advantage, but do you actually trust the vendor or would you prefer to keep that data under your own control and protection?   I don't get what some other vendors limit your choice around how to deploy the software.  Running on servers is very comfortable for people, especially if Active Directory is in the mix.  Yes people trust Microsoft but is that because they actually trust Microsoft or is it because there is not a lot of choice if you want to benefit from their latest innovations?

2. **Intuitive installer**

    Some ISVs don't have an intuitive installer and require you to edit config files or database settings natively.  I am not a fan of that as it is too easy to make a mistake and totally mess up an installation.   Having a robust installer is critical

3. **Avoid hard limitations**

    Some tools place limits on the number of objects, or the number of complex mappings/overrides/transformations, or the total size.  You definitely want to avoid those tools and go for one that can easily handle whatever you throw at it.

4. **Extensibility and adaptability**

    You don't want to pick a tool that is rigid in what you can do with it.  You need support for say Active Directory schema extensions.  You need a tool that can support locked down environments, e.g. where RC4 is totally disabled in Active Directory.  Some tools work well with plain vanilla environments, but outside of a lab, who has one of those lying around?

5. **Configuration templates**

    You need to be up and running quickly, which is where configuration templates are essential, yet some ISVs don't provide templates and you have to configure everything yourself.  





So there you have it, my picks for things to improve in other tools and for things that I like/love about PowerSyncPro.   I'm sure if you ask someone else on the team or any of our partners, then they will have their own list.  I'd love to hear what is on your list of likes and dislikes!
