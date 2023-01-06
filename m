Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56380C3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 03:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjAFDHj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 22:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjAFDHc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 22:07:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1818B17
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 19:07:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E94061CB0
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 03:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A697DC433EF;
        Fri,  6 Jan 2023 03:07:29 +0000 (UTC)
Date:   Thu, 5 Jan 2023 22:07:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: document expected behaviour of execvp for
 record command
Message-ID: <20230105220727.0660a0e4@gandalf.local.home>
In-Reply-To: <Y7eC9o4JDO7XWjlw@mail.google.com>
References: <Y7dUo6woh9Y31cdl@mail.google.com>
        <20230105181317.32dcafa7@gandalf.local.home>
        <Y7eC9o4JDO7XWjlw@mail.google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 6 Jan 2023 15:09:58 +1300
Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com> wrote:

> That's a good point. I thought about it for a while and this is really a pickle.
> 
> I'll dump the things I'm thinking about and peharps you can help me
> choosing between the approaches :-)
> 
> Launching executables via:
> 
> libc->execvp: It avoid some sorts of TOCTOU race conditions by trying to
> execve executables and leave it up to the kernel to do a 'single'
> file-exists validation (best case scenario) instead of validate whether
> file exists twice, once in user-space and again in kernel (best case
> scenario).
> 
> bash: As a counter point (and also because that's most
> likely how trace-cmd will be executed). Bash actually does the
> open-coding execvp() approach as shown below:
> 
> # trace-cmd record -p function_graph \
> 	-g __x64_sys_execve -O nofuncgraph-irqs \
> 	--max-graph-depth 1  \
> 	-F /usr/bin/bash -c "ls" > /dev/null
> 
> 
> ls-178525 [010] 197387.772776: funcgraph_entry:      ! 775.074 us |  __x64_sys_execve(); # for /usr/bin/bash
> ls-178525 [010] 197387.775568: funcgraph_entry:      ! 993.453 us |  __x64_sys_execve(); # for /usr/bin/ls
> 
> I guess this will boil down to whether you want to make trace-cmd as
> 'transparent' as possible (in comparison to running the command without
> prepending trace-cmd) OR if you actually care about/want to abide by
> the TOCTOU 'guarantees' that libc implements for userspace applications
> 
> Let me know your thoughts. I'm flexible with either approach

I think I rather do it the bash way. I don't believe TOCTOU is important
here.

-- Steve
