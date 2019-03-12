Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C27C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 15:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E0572147C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 15:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfCLPfJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfCLPfI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 11:35:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1102083D;
        Tue, 12 Mar 2019 15:35:07 +0000 (UTC)
Date:   Tue, 12 Mar 2019 11:35:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Claudio <claudio.fontana@gliwa.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 00/46] Libtraceevent MAN pages
Message-ID: <20190312113506.52ca2568@gandalf.local.home>
In-Reply-To: <CACqStodFFrxyQR1YD-uL2swMT8nyVSYQJCJzzX=NV2vrRd5sfQ@mail.gmail.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <438810f6-6a04-aa9d-a38a-1d0e04c03c5c@gliwa.com>
        <CACqStodFFrxyQR1YD-uL2swMT8nyVSYQJCJzzX=NV2vrRd5sfQ@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 8 Mar 2019 15:47:14 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Steven could describe it in more details, but we work on common
> tracing platform - set of libraries, which will expose the tracing
> functionality, currently available for trace-cmd and kernelshark only,
> to any application.

[ Just came back from SCaLE 17x conference ]

Note, the libtraceevent is currently just a way to parse the data read
by the Linux kernel trace events. The format files exist in the tracefs
file system under events/<system>/<event>/format (e.g.
events/sched/sched_switch/format).

The library is used by trace-cmd, perf, powertop and mce utils.
Currently, each has their own copy. We are working on making this into
a shared library where the code no longer needs to be duplicated.

There's also going to be an effort to create libftrace, that will take
the functionality of trace-cmd and move it into a library, such that
any tool can start ftrace tracing, and record data. But that's not going
to happen until after we finish getting libtraceevent out.

-- Steve
