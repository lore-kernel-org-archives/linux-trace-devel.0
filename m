Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98717C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 02:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E2C42184C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 02:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfCNC6e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 22:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfCNC6e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 22:58:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 576FA2087C;
        Thu, 14 Mar 2019 02:58:33 +0000 (UTC)
Date:   Wed, 13 Mar 2019 22:58:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 45/46] tools/lib/traceevent: Man pages for
 trace_seq_putc() and trace_seq_puts()
Message-ID: <20190313225831.088f0af7@gandalf.local.home>
In-Reply-To: <20190308133654.21264-46-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-46-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:53 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for trace_seq_putc() and trace_seq_puts()
> as part of the libtraceevent APIs.
> 

I think all the trace_seq_* functions can be put in the same man pages,
and given a nice example on how to use them.

-- Steve
