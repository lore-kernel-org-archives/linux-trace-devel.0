Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0E6C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 09:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0074260F11
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 09:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbhHLJo5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235439AbhHLJo4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 05:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D28A60FC4;
        Thu, 12 Aug 2021 09:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628761471;
        bh=T+hIg+QRJ1Z84eguJqbtPNh4k+7EYEKvFPe14RPj9CA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=is/icZZs88mccR4X1pskyEfmHlbgJ0QqRHPaOC71PTmF3qKssKjUAIuYIInweipet
         SEh3ZVWxfqyAffDEaED6Fc2g1944o0fsaG6q+xydGRwBvlGaTtXxAWRPGhHploXkit
         LTG/LHoL8kv2bj2/psZ7GSxBaq7lqL0PTQtrp6O/V3xZ1p4TIYBjKCblZB4tdIABKz
         l45Ku/ke89jYKgRS9MxeezX1PHFuF9A8fB2YPQdPaPyZws1cdUqwIu8e6NGrjT9sH8
         mpg2pdXb+YPFz/aDnx/e6eXyyka1YEjOhmZ8chQgZqq2LEszIXBc4+LSwhyXLaFwM4
         wYs3/HUInpd4w==
Date:   Thu, 12 Aug 2021 18:44:29 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210812184429.176d1416ff922ade4b5342fb@kernel.org>
In-Reply-To: <20210811234648.4f847ac2@rorschach.local.home>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
        <20210811112249.555463f2@oasis.local.home>
        <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
        <20210811234648.4f847ac2@rorschach.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Aug 2021 23:46:48 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 12 Aug 2021 10:27:35 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > Let me confirm this, so eprobes can be attached to synthetic event?
> > IMHO, I rather like to prevent attaching eprobe_event on the other
> > dynamic events. It makes hard to check when removing the base dynamic
> > events...
> > 
> > For the above example, we can rewrite it as below to trace filename
> > without attaching eprobe_events on the synthetic event.
> > 
> >   echo 'my_open pid_t pid; char file[]' > synthetic_events
> > 
> >   echo 'e:myopen syscalls.sys_enter_open file=+0($filename):ustring' > dynamic_events
> >   echo 'e:myopen_ret syscalls.sys_exit_open ret=$ret' > dynamic_events
> >  
> >   echo 'hist:keys=common_pid:fname=file' > events/eprobes/myopen/trigger
> >   echo 'hist:keys=common_pid:fname=$fname:onmatch(eprobes.myopen).trace(my_open,common_pid,$fname)' > events/eprobes/myopen_ret
> > 
> 
> The problem is that the above wont work :-(
> 
> For example, I can use this program:
> 
> #include <stdio.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/types.h>
> 
> static const char *file = "/etc/passwd";
> 
> int main (int argc, char **argv)
> {
> 	int fd;
> 
> 	fd = open(file, O_RDONLY);
> 	if (fd < 0)
> 		perror(file);
> 	close(fd);
> 	return 0;
> }
> 
> Which if you do the above, all you'll get from the myopen is "(null)".
> 
> That's because the "/etc/passwd" is not paged in at the start of the
> system call, and because tracepoints can not fault, the "ustring" will
> not be mapped yet, it can not give you the content of the file pointer.
> This was the entire reason we are working on eprobes to attach to
> synthetic events in the first place.

I think that is another limitation. If you run this program,

static const char *file = "/etc/passwd";

int main (int argc, char **argv)
{
	char buf[BUFSIZE];
	int fd;

	strlcpy(buf, file, BUFSIZE);
	fd = open(buf, O_RDONLY);
	if (fd < 0)
		perror(file);
	read(fd, buf, BUFSIZE);
	close(fd);
	return 0;
}

you'll not see any filename from the "myopen_ret" or the synthetic event.
Thus, the user-space page fault must be handled by the other way. (e.g.
making a special worker thread and run it before the task returns to
user space.)
Using eprobe over synthetic event does not solve the root cause (and
it can introduce another issue.)

Thank you,

> 
> The trick is to use the synthetic event to pass the filename pointer to
> the exit of the system call, which the system call itself would map the
> pointer to "file", and when the eprobe reads it with ":ustring" from
> the exit of the system call it gets "/etc/passwd" instead of "(null)".
> 
> Your above example doesn't fix this.
> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
