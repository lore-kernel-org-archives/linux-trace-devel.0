Return-Path: <SRS0=01Tb=JF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34130 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757239AbeFSNNr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jun 2018 09:13:47 -0400
Received: by mail-wm0-f68.google.com with SMTP id l15-v6so18813071wmc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Jun 2018 06:13:47 -0700 (PDT)
Subject: Re: [PATCH 3/4] trace-filter: Change the naming convention used in
 trace-filter-hash
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180615212131.28121-1-y.karadz@gmail.com>
 <20180615212131.28121-4-y.karadz@gmail.com>
 <20180618112427.4a5c318e@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <71d0f8d4-a3d8-0845-77ed-534206d0f258@gmail.com>
Date: Tue, 19 Jun 2018 16:13:42 +0300
MIME-Version: 1.0
In-Reply-To: <20180618112427.4a5c318e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steve,

On 18.06.2018 18:24, Steven Rostedt wrote:
> 
> Hi Yordan,
> 
> I pulled in the first two patches.
> 
> On Sat, 16 Jun 2018 00:21:30 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> trace-filter-hash implements a set of hashing tools, used when
>> filtering the trace data. So far these tools are used for a task
>> filtering exploiting the unique Id of the task (pid). The same
>> instruments can be used by an application for event filtering,
>> using the unique Id of the trace event. In this patch the naming
>> convention used in trace-filter-hash is changed, in order to avoid
>> confusion in the case when the tools are used for event filtering.
>>
> 
> I'm not against this patch, and it makes sense. The change log could
> use a little improvement though. I had to read it twice to figure out
> what you were trying to do. What about something like this:
> 
> ===
> The trace-filter-hash code implements a set of hashing utilities for
> filtering the trace data. Currently, only tasks are filtered with this
> utility via its pid. To use this tool for filtering other items such as
> events, a name change is required for the structures and functions
> used. Instead of using the term "task", use the term "id", which is
> more generic, and will be less confusing when using the
> trace-filter-hash for filtering events and such.
> ===
> 

Indeed, your version of the log message explains this patch much better.
Thank you very much!
Yordan

> Or something similar to the above. Again, the patch is fine, just the
> change log was hard to understand.
> 
> -- Steve
> 
> 
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>
