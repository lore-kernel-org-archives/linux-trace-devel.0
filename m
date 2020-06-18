Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CE9C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 15:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9278F2080D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 15:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgFRPrA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgFRPrA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 11:47:00 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A8472070A;
        Thu, 18 Jun 2020 15:46:59 +0000 (UTC)
Date:   Thu, 18 Jun 2020 11:46:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent sync
Message-ID: <20200618114657.34351921@oasis.local.home>
In-Reply-To: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
References: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Jun 2020 14:43:42 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> kernel/traceevent/plugins commits, should be added in
> trace-cmd/traceevent/plugins:
>     "libtraceevent: Remove unneeded semicolon"
>         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eebe80c982546ce1041b7dcf3c461406f1e7e88f
>      "tools lib traceevent: Fix memory leakage in filter_event"
>         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f84ae29a6169318f9c929720c49d96323d2bbab9
>      "tools lib traceevent: Take care of return value of asprintf"
>         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8ff18be1f5c6ba1c2befb043bea6e7eaf9f8987

The above are fine.

>      "tools lib traceevent: Added support for pkg-config"
>         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cc03e1a8f82dff36fb329469c28cbfe7d2e6156a

Hmm, do we need this? If the plan is to make traceevent its own
package, I don't think we need to have pkg-config for trace-cmd.

>      "tools lib traceevent: Remove hard coded install paths from
> pkg-config file"
>         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53dbabfe50262eeebb56ce18789c3c885f15e6ac

Same for this one. I don't think the libraries should be installed via trace-cmd.


> 
> kernel/traceevent/plugins commits, should be added in
> trace-cmd/traceevent/plugins:
>      "tools lib traceevent: update KVM plugin"
>          https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2f465deef7ce8c722121b782dd91c284f5ae80ca

This is good.

Thanks Tzvetomir!

-- Steve
