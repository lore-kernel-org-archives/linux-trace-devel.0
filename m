Return-Path: <SRS0=qtAn=ZE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93350C43331
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 19:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B32B2196E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 19:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKLTJX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 14:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfKLTJX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 14:09:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575BB21783;
        Tue, 12 Nov 2019 19:09:22 +0000 (UTC)
Date:   Tue, 12 Nov 2019 14:09:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Donnefort <vincent.donnefort@arm.com>
Cc:     <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Message-ID: <20191112140920.6bbed145@gandalf.local.home>
In-Reply-To: <20191112190101.GA178419@e120877-lin.cambridge.arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
        <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
        <20191111175203.252cc439@gandalf.local.home>
        <20191112120314.GA41032@e120877-lin.cambridge.arm.com>
        <20191112094037.651a156f@gandalf.local.home>
        <20191112190101.GA178419@e120877-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 Nov 2019 19:01:02 +0000
Vincent Donnefort <vincent.donnefort@arm.com> wrote:

> This was not a good idea in the end. We can't rely on the sysctl entries
> threads-max or pid_max, as the pid/comm map is static and the maximum is
> defined by PID_MAX_DEFAULT. I do not see any way of getting this value from
> user-space.
> 
> We could though, as an alternative, use a hard-coded value of 32768 for
> --cmdlines-size. Without being perfect, this should still be true for most of
> the systems. PID_MAX_DEFAULT depends on CONFIG_BASE_SMALL and hasn't changed
> since Linux started using Git.

But that does take up a bit of memory in the kernel, which isn't
probably needed. What we could do, is periodically record the contents
of the file, and update the map at the end of the record.

Perhaps I should even make it so that we can just get notifications
when it does get updated. But that would require a kernel change.

-- Steve
