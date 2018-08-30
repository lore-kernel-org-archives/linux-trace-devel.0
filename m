Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbeH3SOo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 14:14:44 -0400
Date: Thu, 30 Aug 2018 10:12:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
Message-ID: <20180830101222.19649d50@gandalf.local.home>
In-Reply-To: <5df48f08-af41-ed48-9227-d36528b52734@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
        <20180829164224.20677-8-y.karadz@gmail.com>
        <20180829224312.25c7a16e@vmware.local.home>
        <5df48f08-af41-ed48-9227-d36528b52734@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 30 Aug 2018 14:48:38 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 30.08.2018 05:43, Steven Rostedt wrote:
> >>   set(PLUGIN_LIST "")
> >>   
> >> +ADD_PLUGIN(NAME sched_events
> >> +           SOURCE sched_events.c SchedEvents.cpp)  
> > Do all plugins need to be added like this? Is there a way to make a
> > default rule for a "plugin" directory, that we add source files of this
> > type and have them created automatically just by adding in the source
> > files?
> >   
> >> +
> >> +# list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be loaded by default
> >> +list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by default
> >> +  
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

OK, we'll just have to revisit this in the future. For now this is fine.

Thanks Yordan!

-- Steve
