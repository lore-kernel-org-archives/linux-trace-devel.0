Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97E2C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 16:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C26BC222DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbfBNQgh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbfBNQgh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 11:36:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A6C222DD;
        Thu, 14 Feb 2019 16:36:36 +0000 (UTC)
Date:   Thu, 14 Feb 2019 11:36:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: sched-plugin: Initialize
 plugin_sched_context_handler to zeros
Message-ID: <20190214113635.5ce4f1fb@gandalf.local.home>
In-Reply-To: <5c50aff8-2e73-9ea5-4c21-648274a674ee@vmware.com>
References: <20190214105635.3e0e1570@gandalf.local.home>
        <5c50aff8-2e73-9ea5-4c21-648274a674ee@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Feb 2019 16:33:03 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> On 14.02.19 г. 17:56 ч., Steven Rostedt wrote:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > Now that the sched plugin only requires a single wakeup event to process the
> > wakeup latency boxes, there's no guarantee that all the wakeup events saved
> > in plugin_sched_context_handler will be initialized.
> > 
> > Allocate plugin_sched_context_handler to zeros with calloc() instead of
> > malloc() to make sure the pointers it has are NULL and not left
> > uninitialized.
> > 
> > Fixes: e50d3bbfc9a4 ("kernel-shark: Add sched_waking event processing to sched_waking")
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---

> makes perfect sense.

Thanks Yordan,

Can you reply with an official "Reviewed-by" tag?

-- Steve
