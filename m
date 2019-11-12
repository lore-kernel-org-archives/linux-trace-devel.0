Return-Path: <SRS0=qtAn=ZE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4558C17441
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 14:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7185222CF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 14:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfKLOkk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 09:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLOkk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 09:40:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F42B20679;
        Tue, 12 Nov 2019 14:40:39 +0000 (UTC)
Date:   Tue, 12 Nov 2019 09:40:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Donnefort <vincent.donnefort@arm.com>
Cc:     <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Message-ID: <20191112094037.651a156f@gandalf.local.home>
In-Reply-To: <20191112120314.GA41032@e120877-lin.cambridge.arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
        <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
        <20191111175203.252cc439@gandalf.local.home>
        <20191112120314.GA41032@e120877-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 Nov 2019 12:03:15 +0000
Vincent Donnefort <vincent.donnefort@arm.com> wrote:

> Hi Steve,
> 
> Thank you for your review. I also thought that we could avoid having a new
> option and try to write /proc/sys/kernel/threads-max into saved_cmdlines_size,
> before recording the trace. Do you think that would be a more suitable
> solution?

That's an interesting approach. I still think that having a parameter
would be good as well, but then use the threads-max approach if one is
not supplied.

-- Steve
