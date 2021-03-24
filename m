Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C049EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8993B61A1C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhCXSDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236414AbhCXSCr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 14:02:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C0561A1A;
        Wed, 24 Mar 2021 18:02:46 +0000 (UTC)
Date:   Wed, 24 Mar 2021 14:02:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 02/23] trace-cmd: Extend trace-cmd dump subcommand to
 display the clock
Message-ID: <20210324140244.00e1736a@gandalf.local.home>
In-Reply-To: <20210324135728.3559392c@gandalf.local.home>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-3-tz.stoyanov@gmail.com>
        <20210324135728.3559392c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 13:57:28 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Shouldn't "trace-cmd dump" also show the clock that's stored in the file,
> or will it only show the option?
> 
> I'd like to see the file as well, but all I get is:
> 
>         [Tracing clock]
>                  No tracing clock saved in the file
> 
> Which isn't true. It's just not an option.

Or it is at least inconsistent:

[root@bxtest trace-cmd.git]# ./tracecmd/trace-cmd dump

 Tracing meta data in file trace.dat:
        [Initial format]
                6       [Version]
                0       [Little endian]
                8       [Bytes in a long]
                4096    [Page size, bytes]
        [Header page, 205 bytes]
        [Header event, 205 bytes]
        [Ftrace format, 15 events]
        [Events format, 104 systems]
        [Kallsyms, 6978379 bytes]
        [Trace printk, 4997 bytes]
        [Saved command lines, 2015 bytes]
        8 [CPUs with tracing data]
        [13 options]
        [Flyrecord tracing data]
        [Tracing clock]
                 No tracing clock saved in the file


[root@bxtest trace-cmd.git]# ./tracecmd/trace-cmd dump --clock
        [Tracing clock]
                [tsc2nsec]


-- Steve
