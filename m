Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35997 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbeH3Pva (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 11:51:30 -0400
Received: by mail-wm0-f68.google.com with SMTP id j192-v6so1714188wmj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Aug 2018 04:49:43 -0700 (PDT)
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
 <20180829164224.20677-8-y.karadz@gmail.com>
 <20180829224312.25c7a16e@vmware.local.home>
 <5df48f08-af41-ed48-9227-d36528b52734@gmail.com>
Message-ID: <41c7443b-036b-4257-a7f5-5e17e06debc2@gmail.com>
Date: Thu, 30 Aug 2018 14:49:40 +0300
MIME-Version: 1.0
In-Reply-To: <5df48f08-af41-ed48-9227-d36528b52734@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 30.08.2018 14:48, Yordan Karadzhov (VMware) wrote:
> 
> 
> On 30.08.2018 05:43, Steven Rostedt wrote:
>>>   set(PLUGIN_LIST "")
>>> +ADD_PLUGIN(NAME sched_events
>>> +           SOURCE sched_events.c SchedEvents.cpp)

I guess I have to change the name of the function from ADD_PLUGIN to 
BUILD_PLUGIN, because this is what it actually does.

Thanks!
Yordan

>> Do all plugins need to be added like this? Is there a way to make a
>> default rule for a "plugin" directory, that we add source files of this
>> type and have them created automatically just by adding in the source
>> files?
>>
>>> +
>>> +# list(APPEND PLUGIN_LIST "sched_events default") # This plugin will 
>>> be loaded by default
>>> +list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded 
>>> by default
>>> +
> 
> Yes, in order to add a plugin you have to do two things. First you have 
> call the ADD_PLUGIN function. Second, you have to add the plugin to the 
> list of plugin names, specifying if the plugin will be loaded by default.
> 
> It is possible to make it working just by adding the source files but I 
> am not a big fan of this approach. If we go this way we have to enforce 
> very strict rules for naming the files. Note that this plugin is build 
> form one .c file and one .cpp file, however the plugin for renamed 
> threads will have only one .c file. And in the future we may have 
> plugins having .py files.
> 
> Thanks!
> Yordan
> 
> 
>>> +install(TARGETS sched_events
>>> +        LIBRARY DESTINATION/usr/local/lib/kshark/)
>>> +
