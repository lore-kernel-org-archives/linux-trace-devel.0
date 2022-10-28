Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29990ECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 22:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJ1WnF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 18:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ1WnD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 18:43:03 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B34071C3E6D;
        Fri, 28 Oct 2022 15:43:02 -0700 (PDT)
Received: from W11-BEAU-MD.localdomain (unknown [76.135.50.127])
        by linux.microsoft.com (Postfix) with ESMTPSA id 40BDE20B929B;
        Fri, 28 Oct 2022 15:43:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 40BDE20B929B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1666996982;
        bh=exwdkJJVkHgeu5CgSV2tmHuOY0gdLfJcpPIolWHpg8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dTyoGuSawivvWpRVYXxRALBgm2Kj4zrfSXexegAktFWYFJyhXE3wpl9L/fhSc+DM2
         z4dovTLDNY6Zf5EtVJQZij9nAO0dfkWa2K1+NA5Z+kXQHQkcSAY78rxv5Ia6qdCe7q
         KuGxUV6gJPwKyPSk+39IPC1+lXZgzRcEhhDGbdgU=
Date:   Fri, 28 Oct 2022 15:42:56 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        dcook@linux.microsoft.com, alanau@linux.microsoft.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] tracing/user_events: Fixup enable faults asyncly
Message-ID: <20221028224256.GA202@W11-BEAU-MD.localdomain>
References: <20221027224011.2075-1-beaub@linux.microsoft.com>
 <20221027224011.2075-3-beaub@linux.microsoft.com>
 <a18e940d-8423-0294-23b4-f2702313f3eb@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a18e940d-8423-0294-23b4-f2702313f3eb@efficios.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 28, 2022 at 06:19:10PM -0400, Mathieu Desnoyers wrote:
> On 2022-10-27 18:40, Beau Belgrave wrote:
> > When events are enabled within the various tracing facilities, such as
> > ftrace/perf, the event_mutex is held. As events are enabled pages are
> > accessed. We do not want page faults to occur under this lock. Instead
> > queue the fault to a workqueue to be handled in a process context safe
> > way without the lock.
> > 
> > The enable address is disabled while the async fault-in occurs. This
> > ensures that we don't attempt fault-in more than is necessary. Once the
> > page has been faulted in, the address write is attempted again. If the
> > page couldn't fault-in, then we wait until the next time the event is
> > enabled to prevent any potential infinite loops.
> 
> I'm also unclear about how the system call initiating the enabled state
> change is delayed (or not) when a page fault is queued.
> 

It's not, if needed we could call schedule_delayed_work(). However, I
don't think we need it. When pin_user_pages_remote is invoked, it's with
FOLL_NOFAULT. This will tell us if we need to fault pages in, we then
call fixup_user_fault with unlocked value passed. This will cause the
fixup to retry and get the page in.

It's called out in the comments for this exact purpose (lucked out
here):
mm/gup.c
 * This is meant to be called in the specific scenario where for locking reasons
 * we try to access user memory in atomic context (within a pagefault_disable()
 * section), this returns -EFAULT, and we want to resolve the user fault before
 * trying again.

The fault in happens in a workqueue, this is the same way KVM does it's
async page fault logic, so it's not a new pattern. As soon as the
fault-in is done, we have a page we should be able to use, so we
re-attempt the write immediately. If the write fails, another queue
happens and we could loop, but not like the unmap() case I replied with
earlier.

> I would expect that when a page fault is needed, after enqueuing work to the
> worker thread, the system call initiating the state change would somehow
> wait for a completion (after releasing the user events mutex). That
> completion would be signaled by the worker thread either if the page fault
> fails, or if the state change is done.
> 

I didn't see a generic fault-in + notify anywhere, do you know of one I
could use? Otherwise, it seems the pattern used is check fault, fault-in
via workqueue, re-attempt.

> Thoughts ?
> 
> Thanks,
> 
> Mathieu
> 

Thanks,
-Beau
