---
layout: post
title:  "What do I like and dislike about PowerSyncPro DirSync"
description: Let's take look at PowerSyncPro Directory Sync to see what I like about the product, and which features need more work
date:   2024-09-24 08:20:13 +0100
category: microsoft-365
tags: microsoft-365 migration
image: \android-chrome-192x192.png
comments_id: 39
---
<h1>{{ page.title }}</h1>

I first wrote PowerSyncPro Directory Sync in PowerShell over Christmas in 2018.  Since then the tool has been rewritten in C# using .Net Core.   I wanted to talk about things I am particularly proud of and also mention areas where I think there is room for improvement.   I'd love to hear your feedback on the product, as I do listen to everything that is said about PowerSyncPro and will often look to incorporate ideas and features into the backlog.

So let's get started with the things that I think need work

## Things I think need work in PowerSyncPro DirSync

1. **Software as a Service (SaaS)**

    PowerSyncPro is currently designed to run on a Windows server.  This was an intentional choice as most larger organisations still prefer their Active Directory/Entra ID information to be more protected, and while they trust Microsoft to some extent, that is often out of necessity then by choice.  While we have made the PowerSyncPro install process as simple as possible, we do see clients get caught up on SSL certificate configuration.   To take that pain away we will create a SaaS version of PowerSyncPro, but without ditching the existing architecture, so that you as a customer or partner have a choice.

    Initially the SaaS architecture will still be on request, as in you contact the PowerSyncPro team and an instance will be spun up for you, but if demand is strong then we will follow that up with more automation so that you can spin up/tear down instances yourself and perhaps even changing the licencing model into a metered model, again aiming to make your life easier.

2. **PowerSyncPro installer**

    The installer for the PowerSyncPro service does a decent job, but it needs more streamlining around the SSL certificates area.  Currently I think the two screens are a bit confusing for partners, so adjusting that to make things simpler is worthwhile.  I would also like you to be able to re-run the installer to modify the configuration, for example if you first ran the installer without wanting to have remote agents, but later decide that you do, then I think you should be able to re-run the installer, tick the option to have remote agents and let the installer update the configuration for you.  That way you don't have to manually edit things like appsettings.json

3. **Exchange Online support**

    While PowerSyncPro has support for distribution groups via the Exchange Online PowerShell module.  This all feels a bit clunky and needs to be extended to users as well.  We are of course limited as the Exchange Online team are thusfar resisting opening up a REST based interface more akin to graph.  They do now use REST under the covers but it is a private API so there is significant risk in using that directly.  

    Also we need to extend the Exchange Online reach to users, so that we can set move of the attributes that are either not exposed in Entra ID, or are exposed but are made read-only from the Graph API under different conditions.  I am not sure why MS made this all so complicated, instead of just allowing it via Graph and they sort out the complication of data stores, but it is what it is and we should leverage what we can

4. **Use of custom attributes in Entra ID**

    PowerSyncPro does not currently read the custom attributes from Entra ID.  The reason is that these attributes are sometimes edited only from Graph and other times they must be edited from Exchange Online.  This makes them pretty complicated attributes to support, but they are very useful for matching between two Entra ID tenants, so we should add support for them

5. **Wider use of templates**

    We have a set of templates for helping you create Directory Sync profiles, but we need to extend that set to more scenarios, in particular Google Workspace to Entra ID and Active Directory would be a welcomed addition.   These templates make creating a sync profile so much simpler that it is worth investing time into creating basic templates.   Of course not every migration/configuration is the same so you will still be able to customise the profile so that it meets all your requirements.

## Things I like in PowerSyncPro DirSync

1. **Architecture**

    I like the architecture that underpins PowerSyncPro.  It makes the code easier to understand and follow even to someone like me who while I'm half decent at scripting and used to program several decades ago, I definitely do not class myself a .Net developer.  I also like that we have the remote agents (Sync, Password and soon to be added Proxy) which gives you much more choice around how you deploy PowerSyncPro, taking into account hard network boundaries, security boundaries and operational boundaries.  It also opens the way to SaaS as you can have those agents on premises for Active Directory, but leave the rest in Azure or another cloud provider.

2. **Performance**

    I am always mindful about performance.  PowerSyncPro Directory Sync was definitely built with performance in mind.   We run as many jobs in parallel as possible, unlike tools like Entra Connect Sync which does on job at a time, we will run all the imports at once, and then as soon as the imports are finished to allow a sync job to run then the sync job will kick off. The same with the export job, as soon as the syncs for that target directory are done then we will run the export.   This is what allows PowerSyncPro at a customer to delta sync 14 directories, with 500k users and around 20 million attributes in approximately 1 minute.  Even doing full imports and syncs run incredibly fast, making PowerSyncPro a very valuable Agile-like tool where you can make configuration changes and check the impact of those changes much more quickly than even the goliaths in this space.

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


So there you have it, my picks for things to improve and for things that I like/love about PowerSyncPro.   I'm sure if you ask someone else on the team or any of our partners, then they will have their own list.  I'd love to hear what is on your list of likes and dislikes!
