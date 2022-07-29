Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA780C00140
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Jul 2022 00:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiG2ACp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 20:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiG2ACl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 20:02:41 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 361FD4C62D;
        Thu, 28 Jul 2022 17:02:41 -0700 (PDT)
Received: from kbox (unknown [76.135.27.191])
        by linux.microsoft.com (Postfix) with ESMTPSA id C693820FE893;
        Thu, 28 Jul 2022 17:02:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C693820FE893
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1659052960;
        bh=5HsiSU6m/N6TMarfRdE3+yKjdjkRJvzIxn0ww+MA5EQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G3wnN+IxGKceZ3K5xAhgyW4p7SUtOA5jHr6JAFv1X7+vk02/skz386Uve2498aWq7
         LiObo1cOVNJrUHdjfE1jJdKCqpjuVWW6DVONZrS6MIDdozga1kI8x8bdqJFc7IoDD2
         iVsQw6wmdjvybihrILNDnuSbu29/vnz6mZ4wB52I=
Date:   Thu, 28 Jul 2022 17:02:34 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: Re: tracing/user_events: Tracking broken status and feedback
Message-ID: <20220729000234.GA2746@kbox>
References: <20220725231900.GA2389@kbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725231900.GA2389@kbox>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jul 25, 2022 at 04:19:00PM -0700, Beau Belgrave wrote:
> To help keep track of what is required to remove the broken status from
> user_events I am starting this thread. I would like to use this thread
> to provide status on the work that has been done so far and to have a
> discussion about when the broken status can be removed.
> 
> Feedback threads from 5.18 version of user_events:
> 1. https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/
> 2. https://lore.kernel.org/all/1651771383.54437.1652370439159.JavaMail.zimbra@efficios.com/
> 
> All the feedback has been addressed in the patchsets 1 and 2 (see below).
> Here are the details: 
> 
> 1. Use bits vs bytes in event enabled memory mappings.
> Fixed in patchset 1.
> 
> 2. Pack ABI structures where size is used.
> Fixed in patchset 1.
> 
> 3. Don't trust user strings for string formatting.
> Fixed in patchset 1.
> 
> 4. Move to refcount APIs vs atomic for tracking references.
> Fixed in patchset 1.
> 
> 5. Ensure event_mutex is held during registration.
> Fixed in patchset 2.
> 
> With these, I believe I have addressed all issues to remove the
> "broken status".
> 
> Here is the list of additional feedback (and status) that I don't believe
> should have a bearing on removing the "broken status":
> 
> 1. Kernel vs user tracers in ABI.
> This is not done, the plan is to build a libtracepoint library that allows
> working with both kernel and user tracers in user programs. Steven is
> working on this at the moment. I don't believe this is required to remove
> the broken status, but it will help prove the ABI by having it.
> 
> No patchset yet.
> 
> 2. Container/namespace isolation of events.
> user_events utilizes tracefs for user facing files in the ABI. I've created
> an RFC patchset showing how if tracefs offered an isolated directory
> structure per-namespace the user_events ABI is unaffected. This is true for
> other ABIs that tracefs hosts, if they would like to integrate. I don't
> believe this is required to remove the broken status, however, it's useful
> to have to see how the ABI is unaffected while we work toward enabling
> isolation within tracing.
> 
> See patchset 3.
> 
> Patchsets:
> 1. https://lore.kernel.org/all/20220425184631.2068-1-beaub@linux.microsoft.com/
> 2. https://lore.kernel.org/all/20220328223225.1992-1-beaub@linux.microsoft.com/
> 3. https://lore.kernel.org/all/20220707215828.2021-1-beaub@linux.microsoft.com/
> 
> Thanks,
> -Beau

Steven had feedback on patchset 1 here:
https://lore.kernel.org/all/20220726180115.69320865@gandalf.local.home/

I've updated patchset 1 and 3 to address this feedback.

Updated patchsets:
1. https://lore.kernel.org/all/20220728233309.1896-1-beaub@linux.microsoft.com/
3. https://lore.kernel.org/all/20220728235241.2249-1-beaub@linux.microsoft.com/

Thanks,
-Beau
