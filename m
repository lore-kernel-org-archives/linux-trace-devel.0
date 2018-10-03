Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44685 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbeJDCAN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 22:00:13 -0400
Received: by mail-wr1-f43.google.com with SMTP id 63-v6so7315546wra.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Oct 2018 12:10:32 -0700 (PDT)
Subject: Re: Still problem with red preempted boxes for tasks
To: Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20181003144835.23f09933@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b1b4b516-9b6a-87ea-7755-4d1952ce0444@gmail.com>
Date: Wed, 3 Oct 2018 22:10:30 +0300
MIME-Version: 1.0
In-Reply-To: <20181003144835.23f09933@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

Thanks a lot for this feedback!

I will try to fix this before the end of the week. Not sure I manage to 
understand what has to be done for the colors of the task plots but I 
guess you can show me at our next 1:1.

My talk tomorrow starts at 5 PM Sofia time (10 AM for you). I still 
don't have the link for the streaming but I hope to have it tomorrow.

cheers,
Yordan


On  3.10.2018 21:48, Steven Rostedt wrote:
> Hi Yordan,
> 
> While looking at my data, I found that the red empty boxes to represent
> preemption for task plots is still unreliable.
> 
> Down load this: http://rostedt.org/private/trace-views.tar.bz2
> 
> Then in the /tmp directory:
> 
>   /tmp$ tar xvf trace-views.tar.bz2
> 
> Start up KernelShark, and import view1.json. Notice the red preemption
> box and what tasks they are for. Then load view2.json and do the same,
> the view3.json, and that as well. You'll notice that each one gives
> different preemption boxes in the same location.
> 
> -- Steve
> 
> P.S. The session files really help with passing you debugging info like
> this :-)
> 
