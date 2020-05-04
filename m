Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9380BC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 20:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB9A20707
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 20:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgEDUAM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 16:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgEDUAM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 16:00:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55496206A5;
        Mon,  4 May 2020 20:00:11 +0000 (UTC)
Date:   Mon, 4 May 2020 16:00:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] trace-cmd: Fix trace-cmd report crash while
 displaying trace.dat in specific use case
Message-ID: <20200504160009.2223160a@gandalf.local.home>
In-Reply-To: <20200504062711.107867-2-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
        <20200504062711.107867-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 May 2020 09:27:08 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The trace-cmd report command crashes while displaying a file recorded with "--proc-map" and "-B" options:
> #trace-cmd record --proc-map  -B test -e sched -F sleep 1
> The "--proc-map" options saves the address map of "sleep" into the trace.dat file. This
> information is used by KernelShark. The "-B" options traces the specified events into a
> ftrace instance "test".
> When such file is opened using libtracecmd APIs, the proc-map is parsed and saved into
> a tracecmd_input handler, as linked list "pid_maps". Later, when the ftrace instance
> "test" is parsed, a copy of this handler is used to fill it with the instance's trace data.
> Both tracecmd_input handlers share the same "pid_maps" list, thus leads to a double
> free of the list, when  handlers are destroyed.
> As this "pid_maps" is not used in ftrace buffers, the "pid_maps" list of the copy can be
> initialized to NULL.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>


FYI, I changed the subject and body to this:

trace-cmd: Fix trace-cmd report crash while displaying trace.dat with --proc-map and -B options
  
The trace-cmd report command crashes while displaying a file recorded with
"--proc-map" and "-B" options:

 # trace-cmd record --proc-map  -B test -e sched -F sleep 1

The "--proc-map" options saves the address map of "sleep" into the trace.dat
file. This information is used by KernelShark. The "-B" option traces the
specified events into a ftrace instance "test".

When such a file is opened using libtracecmd APIs, the proc-map is parsed and
saved into a tracecmd_input handler, as linked list "pid_maps". Later, when
the ftrace instance "test" is parsed, a copy of this handler is used to fill
it with the instance's trace data.  Both tracecmd_input handlers share the
same "pid_maps" list, thus leads to a double free of the list when the
handlers are destroyed.  As this "pid_maps" is not used in ftrace buffers,
the "pid_maps" list of the copy can be initialized to NULL.

-- Steve
