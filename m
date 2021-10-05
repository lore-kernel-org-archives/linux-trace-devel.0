Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F252C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Oct 2021 01:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5807B611AE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Oct 2021 01:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhJEBCt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 21:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhJEBCt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 21:02:49 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00FFF611AE;
        Tue,  5 Oct 2021 01:00:58 +0000 (UTC)
Date:   Mon, 4 Oct 2021 21:00:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 00/21] trace-cmd fixes and clean-ups
Message-ID: <20211004210057.6aff736b@rorschach.local.home>
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:11 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Various trace-cmd application and library fixes, clean-ups and internal
> refactoring, needed for trace file version 7 and compression changes.
> 
> This patch-set supersedes "[v2,00/87] Trace file version 7":
>    https://lore.kernel.org/linux-trace-devel/20210729050959.12263-1-tz.stoyanov@gmail.com/
> 
> v3 changes:
>  - fixed issues of split and convert commands with some corner cases
> v2 changes:
>  - more cleanups, forgotten in the first version
> 
> Tzvetomir Stoyanov (VMware) (21):

I accepted all the patches but:

>   trace-cmd library: Do not use local variables when reading CPU stat
>     option
>   trace-cmd library: Fix possible memory leak in read_ftrace_files()
>   trace-cmd library: Fix possible memory leak in read_event_files()
>   trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
>   trace-cmd library: Fix possible memory leak in read_ftrace_printk()
>   trace-cmd library: Fix possible memory leak in
>     read_and_parse_cmdlines()
>   trace-cmd library: Track maximum CPUs count in input handler
>   trace-cmd library: Refactor APIs for creating output handler
>   trace-cmd library: Refactor the logic for writing trace data in the
>     file

I'm going to run a quick test on them, and then push them upstream.

-- Steve
