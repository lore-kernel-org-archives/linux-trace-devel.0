Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEB4C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 15:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC0492146F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 15:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfC0PGP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfC0PGP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 11:06:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8BC2147C;
        Wed, 27 Mar 2019 15:06:14 +0000 (UTC)
Date:   Wed, 27 Mar 2019 11:06:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] tools/lib/traceevent: Rename input arguments of
 libtraceevent APIs from pevent to tep
Message-ID: <20190327110613.354d11e7@gandalf.local.home>
In-Reply-To: <20190327141946.4353-3-tstoyanov@vmware.com>
References: <20190327141946.4353-1-tstoyanov@vmware.com>
        <20190327141946.4353-3-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Mar 2019 16:19:43 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch renames "struct tep_handle *pevent" input arguments of libtraceevent
> APIs to "struct tep_handle *tep". This makes the API consistent with the chosen
> naming convention: tep (trace event parser), instead of the old pevent.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse-api.c     | 132 +++---
>  tools/lib/traceevent/event-parse-local.h   |   6 +-
>  tools/lib/traceevent/event-parse.c         | 473 ++++++++++-----------
>  tools/lib/traceevent/event-parse.h         | 120 +++---
>  tools/lib/traceevent/event-plugin.c        |   8 +-
>  tools/lib/traceevent/parse-filter.c        |   8 +-
>  tools/lib/traceevent/plugin_cfg80211.c     |   8 +-
>  tools/lib/traceevent/plugin_function.c     |   8 +-
>  tools/lib/traceevent/plugin_hrtimer.c      |  12 +-
>  tools/lib/traceevent/plugin_jbd2.c         |  12 +-
>  tools/lib/traceevent/plugin_kmem.c         |  28 +-
>  tools/lib/traceevent/plugin_kvm.c          |  44 +-
>  tools/lib/traceevent/plugin_mac80211.c     |   8 +-
>  tools/lib/traceevent/plugin_sched_switch.c |  16 +-
>  tools/lib/traceevent/plugin_scsi.c         |   8 +-
>  tools/lib/traceevent/plugin_xen.c          |   8 +-
>  16 files changed, 449 insertions(+), 450 deletions(-)
> 
>

Can you rebase the rest of these patches off of my repo:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

 Branch: tip/perf/core

Thanks,

-- Steve
