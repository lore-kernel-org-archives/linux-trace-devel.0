Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3407C3DA78
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Jan 2023 23:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjAMXFz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 18:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjAMXFu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 18:05:50 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E72E7F47A
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 15:05:49 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b17so17391930pld.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 15:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HBq8fgiAd/Uhxo9Ai/ng0Wq3i4LlvKAt71Zdymj0pxw=;
        b=JDdUJpBq5CA6E8RArTff4JGAp96s4+t7NWHUBxFc2u7rCKNqIATBIqPjF4+kMldlzL
         9R8Y3hFZtHGb/uJjg9D2Q8XjNh01wXT0FyTEM/hBiuzgSYZHscXVWkbKBu8/uiEXaCYp
         BEJpkyQzoilLmQkoB9UQgnxJdqyHl9P3zZf1nuIe61VZOFsXPh3kMxsBSw+llkozWCm7
         ufilxWR84b3b/Qxzn8Hg9x/hizCt0MtifhVJXZyVPXTwngOSCE6WBsSNjgZYGu4zeyMj
         pwh5/ZCqyWUXwaBvhD2YH4R71YQYzVbhpXKj9XyPeYECjFTLgc6m2NQEuxgeDbxRVzyR
         zz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBq8fgiAd/Uhxo9Ai/ng0Wq3i4LlvKAt71Zdymj0pxw=;
        b=sZZgliyEtx40zxzPs1ZGpGqOYimcxKNEM8+OAMHHB/sXDh3aKcHL4kxsTjqKI+rfW9
         D8K/zed0753U5O9U7Z/zhFhXcwA7+hRVVPSRz2Rq0qpQ7QqMoZXnoOvI5iPMFgksEFtl
         vfFPoaiKHpfDPIGZKUOQ/d1Eeox7kvSKIvlzrZw09PNFneHIHERZFQf4ToGXdO4B53ew
         RUS/Xg9LN3sLDjQ+BjFhm5uhX6ma2y+HvbfqEY2qqNhN3mEv/CF9wveCU3L6o9o7gPH0
         PC/UY0Uewmr4mysrcoWyZLVjHvRUnCmYip6fS0zlHFuVGF9jc4bKAseLvIQ/02ICeo1s
         hyrA==
X-Gm-Message-State: AFqh2kqCAeY6+MHhbIv78nlUug1/U0yP1GPfK5xlmiZlt4rTs2kdPAhk
        Z0tTkiauhUEMSvO/RoPOEQZkRBwg/7w=
X-Google-Smtp-Source: AMrXdXsMwQtyk39SKlEkUlJBIF/rxQcdZ90Z/oOFx2xncS4fQWsGWzDMcjvfK5IIo5cssG0Lbg+/hQ==
X-Received: by 2002:a17:903:3312:b0:194:6d4b:e1da with SMTP id jk18-20020a170903331200b001946d4be1damr339454plb.0.1673651148771;
        Fri, 13 Jan 2023 15:05:48 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b00189fd83eb95sm14813954plg.69.2023.01.13.15.05.47
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:05:48 -0800 (PST)
Date:   Sat, 14 Jan 2023 12:05:44 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: open code execvp routine to avoid multiple
 execve syscalls
Message-ID: <Y8HjyE3qnmsAtrM9@mail.google.com>
References: <20230105220727.0660a0e4@gandalf.local.home>
 <Y8HiIR9IrfWFG+MY@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8HiIR9IrfWFG+MY@mail.google.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 14, 2023 at 11:58:41AM +1300, Paulo Miguel Almeida wrote:
> In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
> is launched via the libc's execvp() routine. The way that execvp() routine
> works is by invoking execve syscall for every entry on the $PATH if
> command specified is neither absolute nor relative which can come across
> as a bit cryptic to untrained eyes.
> 
> - absolute path example:
> 
>         # trace-cmd record -p function_graph \
>                 -g __x64_sys_execve -O nofuncgraph-irqs \
>                 -n __cond_resched --max-graph-depth 1  \
>                 -F /usr/bin/echo "ftrace" > /dev/null
> 
>         # trace-cmd report
>         echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();
> 
> - PATH-dependent path example:
> 
>         # trace-cmd record -p function_graph \
>                 -g __x64_sys_execve -O nofuncgraph-irqs \
>                 -n __cond_resched --max-graph-depth 1  \
>                 -F echo "ftrace" > /dev/null
> 
>         # trace-cmd report
>         echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
>         echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();
> 
> Open code the libc's execvp routine into trace-cmd so ftrace will only
> start recording once the command is found when it needs to be found in
> PATH.
> 
> Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> ---
> Changelog:
> 
> - v2: open code execvp routine into trace-cmd. (Req. Steve Rostedt)
> - v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/
> ---

Ignore this patch. I just realised that I didn't tweak the CUnit tests.
I will submit another patch shortly.

- Paulo A.
