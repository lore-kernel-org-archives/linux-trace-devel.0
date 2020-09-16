Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A5EC2BB84
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 19:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF56206B2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 19:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgIPTFn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 15:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgIPRqT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:46:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399AE20771;
        Wed, 16 Sep 2020 13:26:46 +0000 (UTC)
Date:   Wed, 16 Sep 2020 09:26:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Initial trace-cmd support for ftrace uprobes
Message-ID: <20200916092644.1d94cdc2@gandalf.local.home>
In-Reply-To: <20200916114709.291533-1-tz.stoyanov@gmail.com>
References: <20200916114709.291533-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Sep 2020 14:47:06 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Ftrace supports uprobes - trace events on user space applications.
> Trace-cmd cannot configure uprobes, in order to support it this new
> functionality is introduced: 
>  - Function name to file offset mapping, this information is extracted
>   from the dwarf and ELF headers in the binary file.
>  - New options are added to "trace-cmd record" for setting a uprobe:
>     --uprobe file:function
>     --uprobe-ret file:function

Thanks Tzvetomir,

I'll take a look at this.

-- Steve

> 
> Tzvetomir Stoyanov (VMware) (3):
>   trace-cmd: Internal refactoring of pid address map logic
>   trace-cmd: New internal APIs for reading ELF header
>   trace-cmd: [POC] Add support for uprobes
> 
>  Makefile                       |  10 +
>  include/trace-cmd/trace-cmd.h  |   9 +
>  tracecmd/Makefile              |   2 +
>  tracecmd/include/trace-local.h |  49 +-
>  tracecmd/trace-obj-debug.c     | 823 +++++++++++++++++++++++++++++++++
>  tracecmd/trace-record.c        | 193 ++++----
>  tracecmd/trace-uprobes.c       | 221 +++++++++
>  tracecmd/trace-usage.c         |   4 +
>  8 files changed, 1197 insertions(+), 114 deletions(-)
>  create mode 100644 tracecmd/trace-obj-debug.c
>  create mode 100644 tracecmd/trace-uprobes.c
> 

