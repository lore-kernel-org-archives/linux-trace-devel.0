Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RHS_DOB autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83173C31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 15:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 605F421734
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 15:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfFLPxr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfFLPxq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 11:53:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE15621019;
        Wed, 12 Jun 2019 15:53:45 +0000 (UTC)
Date:   Wed, 12 Jun 2019 11:53:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alan Mikhak <alanmikhak@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Message-ID: <20190612115344.3359003c@gandalf.local.home>
In-Reply-To: <CAOY98Nfv24YknzV36PZFnVLsPK6UcCxZiKfTJ-mv4dUsDUzaMA@mail.gmail.com>
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
        <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com>
        <20190612081252.6fd3d118@gandalf.local.home>
        <CAOY98Nfv24YknzV36PZFnVLsPK6UcCxZiKfTJ-mv4dUsDUzaMA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Jun 2019 08:31:30 -0700
Alan Mikhak <alanmikhak@gmail.com> wrote:

> Hi Steve and Yordan,
> 
> FYI, I ran the kernel get_maintainers.pl script when preparing this
> patch but the script didn't suggest linux-trace-devel@vger.kernel.org
> or either of you as maintainers.

Hi Alan,

Heh, that script is made to work with the Linux kernel. I never thought
about trying it against the trace-cmd.git repo. I may be able to make
that work, it shouldn't be too hard. I just need to create a
MAINTAINERS file.

I do have both: trace-cmd.org and kernelshark.org, that should show how
to submit patches.

Thanks!

-- Steve
