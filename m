Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955ECC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 01:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B07613F0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 01:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhD2Bfy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 21:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhD2Bfy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 21:35:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D91B613F0;
        Thu, 29 Apr 2021 01:35:08 +0000 (UTC)
Date:   Wed, 28 Apr 2021 21:35:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [POC PATCH 00/10] Add trace file compression
Message-ID: <20210428213506.7791db62@oasis.local.home>
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Apr 2021 10:38:52 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new PoC implementation for adding a compression to trace file version 7.
> A basic infrastructure for compression support is added into the trace-cmd
> library. The zlib is used for compression, but more libraries and algorithms
> can be added. Only part of the trace file metadata is compressed: 
>  - ftrace events format
>  - format of recorded events
>  - information about the mapping of function addresses to the function names
>  - trace_printk() format strings
>  - information of the mapping a PID to a process name
> 
> Note: not all trace-cmd commands are tested with these changes. These are
> verified to work with compressed trace files:
>  trace-cmd record
>  trace-cmd report
>  trace-cmd dump
> 
> Todo list, in order to have complete trace file compression:
>  - Compress trace file options.
>  - Compress trace data.
>  - Add support for more compression libraries.
>  - Add new trace-cmd command to convert trace files from version 6 to
>    version 7 and vise versa.
>  - Add compression support to all trace-cmd commands.
>  - Update trace-cmd documentation.
> 
> This patch set depends on "[PATCH 0/6] Bump trace file version"
> and should be applied on top of it.
> https://lore.kernel.org/linux-trace-devel/20210422071718.483383-1-tz.stoyanov@gmail.com/
> 
> Tzvetomir Stoyanov (VMware) (10):
>   trace-cmd: Add APIs for library initialization and free
>   trace-cmd library: Add support for compression algorithms
>   trace-cmd library: Compress part of the trace file
>   trace-cmd library: Read compressed trace file
>   trace-cmd library: Add new API to get compression of input handler
>   trace-cmd library: Inherit compression algorithm from input file
>   trace-cmd library: Extend the create file APIs to support different
>     compression
>   trace-cmd record: Add new parameter --compression
>   trace-cmd dump: Add support for trace files version 7
>   trace-cmd library: Add support for zlib compression library

I'm not able to apply these patches as I'm getting conflicts from your
previous series that bumps the version number, as if what you sent to
the mailing list was not what you have in your git repo.

Can you please resend the version update patch series.

-- Steve


> 
>  lib/trace-cmd/Makefile                        |  11 +
>  .../include/private/trace-cmd-private.h       |  42 ++-
>  lib/trace-cmd/include/trace-cmd-local.h       |   7 +
>  lib/trace-cmd/trace-compress-zlib.c           | 172 ++++++++++
>  lib/trace-cmd/trace-compress.c                | 289 +++++++++++++++++
>  lib/trace-cmd/trace-input.c                   | 304 +++++++++++++-----
>  lib/trace-cmd/trace-output.c                  | 268 ++++++++++++---
>  lib/trace-cmd/trace-util.c                    |  12 +
>  tracecmd/trace-cmd.c                          |  11 +-
>  tracecmd/trace-dump.c                         | 164 ++++++++--
>  tracecmd/trace-record.c                       |  18 +-
>  tracecmd/trace-restore.c                      |   4 +-
>  tracecmd/trace-usage.c                        |   1 +
>  13 files changed, 1152 insertions(+), 151 deletions(-)
>  create mode 100644 lib/trace-cmd/trace-compress-zlib.c
>  create mode 100644 lib/trace-cmd/trace-compress.c
> 

