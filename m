Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97044C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 20:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5012920854
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 20:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfCMUc6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 16:32:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43448 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfCMUc6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 16:32:58 -0400
Received: from patrickm (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 1A688335D01;
        Wed, 13 Mar 2019 20:32:57 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:32:54 -0700
From:   Patrick McLean <chutzpah@gentoo.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190313133254.09e13435@patrickm>
In-Reply-To: <20190313150602.0bed3d1f@gandalf.local.home>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
        <20190313114235.7fc6ce3b@patrickm>
        <20190313150602.0bed3d1f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 15:06:02 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 13 Mar 2019 11:42:35 -0700
> Patrick McLean <chutzpah@gentoo.org> wrote:
> 
> > (especially when trace-cmd and trace-cmd are
> > separate packages)  
> 
> That should be a fun stunt. ;-)
> 
> But yeah, we are looking into separating KernelShark out of trace-cmd
> in the future, but depending on libftrace.so (the guts of trace-cmd)
> when that is ready. First we need to finish libtraceevent.so, which
> will live in the Linux kernel git repo under tools/lib/traceeevent.
> Would that be an issue in packaging libtraceevent?
> 

Oops, editing error ;).

That is likely not an issue for distros that pick a kernel and stick
with it, they would just package the one that ships with the kernel
that version chose (barring any breaks with stable releases). On
distros that track upstream kernels, that would be kind of a pain to
deal with, but potentially still manageable by packaging the library
with the kernel (potentially with some LD_LIBRARY_PATH magic).

On Gentoo it would be very difficult to deal with, since kernels are
built by users, but I suspect that is kind of a niche. In practice
there would probably be a package that uses the kernel source tree to
build a "system" version (that is what is currently done with perf,
though unfortunately it lags a bit behind kernel releases).

I would imagine kernel developers would have to come up with a way to
handle it themselves, since they would have user space packages that
depend on a library produced from their kernel source tree.

I assume it will have a fairly stable API/ABI, so one would not have to
worry about recompiling userspace tools when a kernel gets updated?

