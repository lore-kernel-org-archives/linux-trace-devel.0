Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9098C3DA78
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 Jan 2023 04:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjANE7C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjANE7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 23:59:00 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD70C35AB
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 20:58:59 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id g23so9803987plq.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Jan 2023 20:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mCUW9Uz73slV5UyDa4FHtrEgkSRFfTPHjg/JzI76IJ4=;
        b=f+S87jPXTO8rYq3dETiB4ON8mLX9j8sSLmjB3H1yw/K2HXR8SV93LI5QNaP2wyEskN
         gEkbfjgMUexPbkuM7HXYVvAf6C3JMto/IUaRRn8pqhdkx94K+PPBseqRDbmHuXcuzJsB
         YqT/aspMhy1RxFbjlX41uyKHe6Ygdvukb+pM6jCrbFZAa9ZQvGE14atGEs3LSl8YASWY
         Of+rQNqYi/s1jl9h7iQ9CVSCg0Wt2+UlJ27zIBu6ggJopZiyJHqMmRBUnwEqA/rvX5a3
         fFkGlaEjOVLV+3ls0/u1ATSIaw9+8ATQ1wfsYkuhHu0O25LRALrLzMu8PqvLbuVg3++J
         PbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCUW9Uz73slV5UyDa4FHtrEgkSRFfTPHjg/JzI76IJ4=;
        b=H84nnTl28XDwWrNSFf98SUcwnKrJ/+BLMHbfb1sARGvW5EHE7CzsfR6pkFV8b1EgiS
         lj8KFNOgFkSQn/dzPHck/69UgZaTt3k5PQ5zyx2BmmCQufQBdYvvrQc7PLoOrYZ0pM0n
         mp9UK3MZBPrmBHJep8uJGvDPnFafJMfUoUduXUVFt9aCkCBKpKuqPqwCVzTYgZXdofiY
         H8jSlOcUsWspY/DvgTkWK6oB7fhkMVomtij1aYPddnYcPSv+u5WJgPWAKgjPYbseGsQb
         3/GYv1fOm6FPbux4nyOYSyJ8/h8bxA2FGMbtaGRTEauDgLa2+yb2VuU8nYgqD9sDj8C7
         uiDQ==
X-Gm-Message-State: AFqh2kqxLBnsXt29PKjtA2EJItMBsbgEKAEBcRWuY6Y4wAeLgDQnLcXL
        5vfmJx4Z3FB0qCLck2U/ltaQtF56mT0=
X-Google-Smtp-Source: AMrXdXuAxTqNyVqA6qdRxa43cj6AKA205YBZNo3vJVgblxO5C6KRrEZAm0hnsxYW0fZGOyAQJRfzIA==
X-Received: by 2002:a17:903:3312:b0:194:6d4b:e1da with SMTP id jk18-20020a170903331200b001946d4be1damr535319plb.0.1673672339042;
        Fri, 13 Jan 2023 20:58:59 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id c6-20020a170903234600b00189b2b8dbedsm15004593plh.228.2023.01.13.20.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 20:58:58 -0800 (PST)
Date:   Sat, 14 Jan 2023 17:58:54 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     paulo.miguel.almeida.rodenas@gmail.com
Subject: Re: [PATCH v2] trace-cmd: open code execvp routine to avoid multiple
 execve syscalls
Message-ID: <Y8I2jseKDuV0PzUJ@mail.google.com>
References: <20230105220727.0660a0e4@gandalf.local.home>
 <Y8HiIR9IrfWFG+MY@mail.google.com>
 <Y8HjyE3qnmsAtrM9@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8HjyE3qnmsAtrM9@mail.google.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 14, 2023 at 12:05:44PM +1300, Paulo Miguel Almeida wrote:
> On Sat, Jan 14, 2023 at 11:58:41AM +1300, Paulo Miguel Almeida wrote:
> > In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
> > is launched via the libc's execvp() routine. The way that execvp() routine
> > works is by invoking execve syscall for every entry on the $PATH if
> > command specified is neither absolute nor relative which can come across
> > as a bit cryptic to untrained eyes.
> > 
> > - absolute path example:
> > 
> >         # trace-cmd record -p function_graph \
> >                 -g __x64_sys_execve -O nofuncgraph-irqs \
> >                 -n __cond_resched --max-graph-depth 1  \
> >                 -F /usr/bin/echo "ftrace" > /dev/null
> > 
> >         # trace-cmd report
> >         echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();
> > 
> > - PATH-dependent path example:
> > 
> >         # trace-cmd record -p function_graph \
> >                 -g __x64_sys_execve -O nofuncgraph-irqs \
> >                 -n __cond_resched --max-graph-depth 1  \
> >                 -F echo "ftrace" > /dev/null
> > 
> >         # trace-cmd report
> >         echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
> >         echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();
> > 
> > Open code the libc's execvp routine into trace-cmd so ftrace will only
> > start recording once the command is found when it needs to be found in
> > PATH.
> > 
> > Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> > ---
> > Changelog:
> > 
> > - v2: open code execvp routine into trace-cmd. (Req. Steve Rostedt)
> > - v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/
> > ---
> 
> Ignore this patch. I just realised that I didn't tweak the CUnit tests.
> I will submit another patch shortly.
> 
> - Paulo A.

False alarm Steve. You can review this patch as it is :-)

The error I was getting before:

---
Suite: trace-cmd
  Test: Simple record and report ...passed
  Test: Test convert from v7 to v6 ...passed
  Test: Use libraries to read file ...FAILED
    1. tracecmd-utest.c:441  - data.counter > 0
  Test: Test max length ...passed

Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests      4      4      3      1        0
             asserts     24     24     23      1      n/a

Elapsed time =    0.193 seconds
---

After git bisect'ing the error I realised that my commit has nothing
to do with the CUnit test failure given that this particular test case
has been failing for me since its introduction to the code base on
commit <d83b6628927326d158>.

Regardless of what fix it requires, I'm assuming that would be done
in a different patch anyway. So as soon as this one is reviewed and
merged, I'm happy to further investigate the other :-)

thanks!

- Paulo A.
