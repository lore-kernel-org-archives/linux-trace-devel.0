Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C4EC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA39E21655
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfLLRZl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730092AbfLLRZl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 12:25:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4944321655;
        Thu, 12 Dec 2019 17:25:40 +0000 (UTC)
Date:   Thu, 12 Dec 2019 12:25:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Koepi <john.koepi@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: traceevent support for kernels with
 CONFIG_GCC_PLUGIN_STRUCTLEAK=y
Message-ID: <20191212122538.58747672@gandalf.local.home>
In-Reply-To: <CAJ8z9b0dJrkpDsU8-XWQbVVKqtocCPG+ARO4rkdboxLX_dJ2DA@mail.gmail.com>
References: <CAJ8z9b0dJrkpDsU8-XWQbVVKqtocCPG+ARO4rkdboxLX_dJ2DA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Dec 2019 19:07:46 +0200
John Koepi <john.koepi@gmail.com> wrote:

> > $ cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_io_submit/format
> > name: sys_enter_io_submit
> > ID: 897
> > format:
> > field:unsigned short common_type; offset:0; size:2; signed:0;
> > ...
> > field:struct iocb __attribute__((user)) * __attribute__((user)) * iocbpp; offset:32; size:8; signed:0;
> > ...  
> 
> Having __attribute__ leaked into syscalls format, it makes its
> impossible for the traceevent lib from the kernel/tools/lib to
> parse such fields, like in the example above.
> 
> This in its turn makes it impossible to use tracing for those syscalls:
> 
> > $ sudo perf record -e syscalls:sys_enter_io_submit -aR
> > libtraceevent: No such file or directory
> >  Error: expected type 4 but read 5  
> 
> Thus, tracing does not work for some syscalls in Arch Linux kernels.
> And I suppose for all kernels that built with structleak plugin support.
> 
> Reproduce: https://github.com/sitano/traceevent_attribute
> 
> My question:
> 
> Is it a bug that the traceevent lib does not support parsing __attribute__
> in syscalls formats?
> 
> or it is a bug of the SYSCALL_DEFINEx macroses / build system that
> they do allow C attributes to leak?
> 
> maybe this is already fixed in the latest kernel? or maybe I am missing
> something?

Thanks for the report. This looks like something we can have
libtraceveent handle, no need to change the kernel.

Could you file a bug report?

  https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---

-- Steve

