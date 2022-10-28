Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F84C38A02
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 21:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ1V6g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJ1V6f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 17:58:35 -0400
X-Greylist: delayed 511 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Oct 2022 14:58:34 PDT
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A03624CC80
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Oct 2022 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1666993801;
        bh=CxE35lwUXKGlQFAjcsHZjpVXc8qtcYvKLQQG59ZWquw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=F8s5nowY9pS5onzDOrgBhcNQEXzNp6wneOWOgvYpzlSY+0kxZSlG/uNG2Oq6vS9Qv
         Ee0HVKeX0LGz+XpMTkPKTrhhnOWv9Wp57t5UAQswx4ukGTdSdxJcrnm2GHwEQnK3/T
         DjJ8pUbZnGRfXGb5alg550OlMI385zZFX8SOeqRwGGwWe62jf0nTRkd3adeM5yBw6j
         Tz+zNrHjv0NxZEY+vtl7xSvCDZFhHXij2YwA3GtBPvpJlUpTgWVzcXMAt7LSW9Q0wE
         RiltiLwedvZYwSn1UwvOgPHJVTGwVT+RVEAv//BdcADLOueD5LlKC3MTNnzHZgHL8X
         m6HFzmQ4905lA==
Received: from [172.16.0.185] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4Mzbn541FGz1553;
        Fri, 28 Oct 2022 17:50:01 -0400 (EDT)
Message-ID: <96d9f066-2f39-78e6-9be7-f9c69235615e@efficios.com>
Date:   Fri, 28 Oct 2022 17:50:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC PATCH 0/2] tracing/user_events: Remote write ABI
To:     Beau Belgrave <beaub@linux.microsoft.com>, rostedt@goodmis.org,
        mhiramat@kernel.org, dcook@linux.microsoft.com,
        alanau@linux.microsoft.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221027224011.2075-1-beaub@linux.microsoft.com>
Content-Language: en-US
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20221027224011.2075-1-beaub@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-10-27 18:40, Beau Belgrave wrote:
> As part of the discussions for user_events aligned with user space
> tracers, it was determined that user programs should register a 32-bit
> value to set or clear a bit when an event becomes enabled. Currently a
> shared page is being used that requires mmap().
> 
> In this new model during the event registration from user programs 2 new
> values are specified. The first is the address to update when the event
> is either enabled or disabled. The second is the bit to set/clear to
> reflect the event being enabled. This allows for a local 32-bit value in
> user programs to support both kernel and user tracers. As an example,
> setting bit 31 for kernel tracers when the event becomes enabled allows
> for user tracers to use the other bits for ref counts or other flags.
> The kernel side updates the bit atomically, user programs need to also
> update these values atomically.

Nice!

> 
> User provided addresses must be aligned on a 32-bit boundary, this
> allows for single page checking and prevents odd behaviors such as a
> 32-bit value straddling 2 pages instead of a single page.
> 
> When page faults are encountered they are done asyncly via a workqueue.
> If the page faults back in, the write update is attempted again. If the
> page cannot fault-in, then we log and wait until the next time the event
> is enabled/disabled. This is to prevent possible infinite loops resulting
> from bad user processes unmapping or changing protection values after
> registering the address.

I'll have a close look at this workqueue page fault scheme, probably 
next week.

> 
> NOTE:
> User programs that wish to have the enable bit shared across forks
> either need to use a MAP_SHARED allocated address or register a new
> address and file descriptor. If MAP_SHARED cannot be used or new
> registrations cannot be done, then it's allowable to use MAP_PRIVATE
> as long as the forked children never update the page themselves. Once
> the page has been updated, the page from the parent will be copied over
> to the child. This new copy-on-write page will not receive updates from
> the kernel until another registration has been performed with this new
> address.

This seems rather odd. I would expect that if a parent process registers 
some instrumentation using private mappings for enabled state through 
the user events ioctl, and then forks, the child process would 
seamlessly be traced by the user events ABI while being able to also 
change the enabled state from the userspace tracer libraries (which 
would trigger COW). Requiring the child to re-register to user events is 
rather odd.

What is preventing us from tracing the child without re-registration in 
this scenario ?

Thanks,

Mathieu

> 
> Beau Belgrave (2):
>    tracing/user_events: Use remote writes for event enablement
>    tracing/user_events: Fixup enable faults asyncly
> 
>   include/linux/user_events.h      |  10 +-
>   kernel/trace/trace_events_user.c | 396 ++++++++++++++++++++-----------
>   2 files changed, 270 insertions(+), 136 deletions(-)
> 
> 
> base-commit: 23758867219c8d84c8363316e6dd2f9fd7ae3049

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

