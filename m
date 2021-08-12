Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F608C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 03:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC486104F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 03:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhHLDrP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 23:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHLDrO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 23:47:14 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE0760FE6;
        Thu, 12 Aug 2021 03:46:49 +0000 (UTC)
Date:   Wed, 11 Aug 2021 23:46:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-ID: <20210811234648.4f847ac2@rorschach.local.home>
In-Reply-To: <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
        <20210811112249.555463f2@oasis.local.home>
        <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 10:27:35 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Let me confirm this, so eprobes can be attached to synthetic event?
> IMHO, I rather like to prevent attaching eprobe_event on the other
> dynamic events. It makes hard to check when removing the base dynamic
> events...
> 
> For the above example, we can rewrite it as below to trace filename
> without attaching eprobe_events on the synthetic event.
> 
>   echo 'my_open pid_t pid; char file[]' > synthetic_events
> 
>   echo 'e:myopen syscalls.sys_enter_open file=+0($filename):ustring' > dynamic_events
>   echo 'e:myopen_ret syscalls.sys_exit_open ret=$ret' > dynamic_events
>  
>   echo 'hist:keys=common_pid:fname=file' > events/eprobes/myopen/trigger
>   echo 'hist:keys=common_pid:fname=$fname:onmatch(eprobes.myopen).trace(my_open,common_pid,$fname)' > events/eprobes/myopen_ret
> 

The problem is that the above wont work :-(

For example, I can use this program:

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>

static const char *file = "/etc/passwd";

int main (int argc, char **argv)
{
	int fd;

	fd = open(file, O_RDONLY);
	if (fd < 0)
		perror(file);
	close(fd);
	return 0;
}

Which if you do the above, all you'll get from the myopen is "(null)".

That's because the "/etc/passwd" is not paged in at the start of the
system call, and because tracepoints can not fault, the "ustring" will
not be mapped yet, it can not give you the content of the file pointer.
This was the entire reason we are working on eprobes to attach to
synthetic events in the first place.

The trick is to use the synthetic event to pass the filename pointer to
the exit of the system call, which the system call itself would map the
pointer to "file", and when the eprobe reads it with ":ustring" from
the exit of the system call it gets "/etc/passwd" instead of "(null)".

Your above example doesn't fix this.

-- Steve
