Return-Path: <SRS0=LjSD=RB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E11C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 16:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FF252184D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 16:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfBZQYJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 11:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbfBZQYJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 11:24:09 -0500
Received: from vmware.local.home (unknown [208.91.3.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4E372173C;
        Tue, 26 Feb 2019 16:24:08 +0000 (UTC)
Date:   Tue, 26 Feb 2019 11:24:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Can't use kvm_exit for the host side time stamp
Message-ID: <20190226112406.7abab75a@vmware.local.home>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Ceco,

I was walking Yordan down the code in the kernel to show him the ideas
I have about using kvm_exit as the trace event on the host side, when I
noticed that it's called *after* interrupts and preemption are enabled!

This totally breaks the design, as it is not a reliable event, because
the process running the guest is likely to get an interrupt or
preempted before recording that event, which can cause a huge
difference.

kvm_enter is fine, but the reason that kvm_exit is not, is because, in
order to record the reason for the exit, it needs to call into either
the Intel or AMD code (as they are different), and that is done after
interrupts and preemption are enabled.

Instead, we can trace the function kvm_read_l1_tsc, which happens while
interrupts are still enabled.

Would you be able to test with that function instead of using kvm_exit?
Also, if you still see a drift, try setting both trace clocks to
x86-tsc, and see if you still get a drift.

Thanks!

-- Steve
