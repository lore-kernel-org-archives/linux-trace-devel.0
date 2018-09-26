Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f49.google.com ([209.85.128.49]:38947 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbeIZNdy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 09:33:54 -0400
Received: by mail-wm1-f49.google.com with SMTP id q8-v6so1058250wmq.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Sep 2018 00:22:22 -0700 (PDT)
Subject: Re: Some issues I found with KernelShark 1.0 prototype
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180925123320.71d0d580@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <31d115c7-a846-9da8-7ccd-483b0475db1f@gmail.com>
Date: Wed, 26 Sep 2018 10:22:17 +0300
MIME-Version: 1.0
In-Reply-To: <20180925123320.71d0d580@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On 25.09.2018 19:33, Steven Rostedt wrote:
> Hi Yordan,
> 
> While writing my presentation I found a few slight issues that we need
> to address.
> 
>   1. Need to show the task in the info window when hovering over the CPU
>      plot between events, but not idle 

OK, I will tray implementing this.

> 
>   2. Is there a way to do a quick zoom out. When I zoom in with a lot of
>      data, I find that it's quite slow to zoom back out to the original
>      screen.

Yes, this is trivial. We just have to find a way to make it intuitive.
Maybe adding another button?


>   3. We need a "File exists, do you want to overwrite" type dialog box
>      when saving a session over a file that already exists.

Hmm, I thought that it asks before overwriting. I will check this again.

> 
>   4. When restoring a session, the full path of the file being loaded
>      should be shown. I noticed this because I was loading a trace.dat
>      file from a different directory, and I wasn't sure which file it
>      found, as I have several trace.dat files.

The full path of the loaded file is shown as part of the name of the 
window. It will be "KernelShark(/some/path/somefile.dat)"

> 
>   5. I noticed a glitch when loading a session with both the A and B
>      markers are set here only one marker was shown in the list view.
>      I can put the session and trace.dat file someplace that you can
>      test this if you want.
> 

There is some regression in the import/export session code. I also 
noticed some problems there. Will do a careful look.

Thanks a lot for reporting all this issues!
Looking forward to see your talk.

cheers,
Yordan


> But so far it looks great! Tomorrow I'll be presenting my talk at 11am
> your time. It will hopefully be live streamed if they don't have the
> issues that they had at Embedded Recipes. I'll email the list the link
> when I have it.
> 
> -- Steve
> 
