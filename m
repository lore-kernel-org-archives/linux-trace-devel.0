Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925D9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C81220885
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgGBRhb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgGBRhb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:37:31 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD952084C;
        Thu,  2 Jul 2020 17:37:30 +0000 (UTC)
Date:   Thu, 2 Jul 2020 13:37:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 00/15] Synchronize libtraceevent with trace-cmd
Message-ID: <20200702133729.7c0d1e41@oasis.local.home>
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I just noticed that I only see 1-9, I'm missing 10-15 and so is
patchwork.


On Thu, 25 Jun 2020 13:05:07 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Backported traceevent library patches from trace-cmd lib/traceevent
> 
> Jan Kiszka (2):
>   tools lib traceevent: Add more SVM exit reasons

>   tools lib traceevent: Fix reporting of unknown SVM exit reasons

Missing.


> 
> Julia Cartwright (1):
>   tools lib traceevent: Add plugin for decoding syscalls/sys_enter_futex

Missing.

> 
> Steven Rostedt (Red Hat) (2):
>   tools lib traceevent: Add --debug to trace-cmd report
>   tools lib traceevent: Add plugin for tlb_flush
> 
> Steven Rostedt (VMware) (3):
>   tools lib traceevent: Add -O offset for function plugin

Missing.

>   tools lib traceevent: Add builtin handler for trace_marker_raw

Missing.

>   tools lib traceevent: Change to SPDX License format

Missing.

> 
> Tom Zanussi (1):
>   tools lib traceevent: Add proper KBUFFER_TYPE_TIME_STAMP handling
> 
> Tzvetomir Stoyanov (VMware) (6):
>   tools lib traceevent: Remove trace-cmd plugin handling routines
>   tools lib traceevent: Move plugin options from trace-cmd to
>     libtraceevent.
>   tools lib traceevent: Introduced new traceevent API, for adding new
>     plugins directories.
>   tools lib traceevent: Add support for more printk format specifiers
>   tools lib traceevent: Optimize pretty_print() function

>   tools lib traceevent: Move kernel_stack event handler to "function"
>     plugin.

Missing.

-- Steve

> 
>  tools/lib/traceevent/event-parse-local.h      |   22 +-
>  tools/lib/traceevent/event-parse.c            | 1004 ++++++++++++-----
>  tools/lib/traceevent/event-parse.h            |   34 +-
>  tools/lib/traceevent/event-plugin.c           |  261 ++++-
>  tools/lib/traceevent/kbuffer-parse.c          |   43 +-
>  tools/lib/traceevent/kbuffer.h                |   19 +-
>  tools/lib/traceevent/plugins/Build            |    2 +
>  tools/lib/traceevent/plugins/Makefile         |    2 +
>  .../lib/traceevent/plugins/plugin_function.c  |  123 +-
>  tools/lib/traceevent/plugins/plugin_futex.c   |  123 ++
>  tools/lib/traceevent/plugins/plugin_hrtimer.c |   17 +-
>  tools/lib/traceevent/plugins/plugin_jbd2.c    |   17 +-
>  tools/lib/traceevent/plugins/plugin_kmem.c    |   17 +-
>  tools/lib/traceevent/plugins/plugin_kvm.c     |   42 +-
>  .../lib/traceevent/plugins/plugin_mac80211.c  |   17 +-
>  .../traceevent/plugins/plugin_sched_switch.c  |   17 +-
>  tools/lib/traceevent/plugins/plugin_tlb.c     |   66 ++
>  17 files changed, 1406 insertions(+), 420 deletions(-)
>  create mode 100644 tools/lib/traceevent/plugins/plugin_futex.c
>  create mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c
> 

