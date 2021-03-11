Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18C9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573F564FAB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhCKOyX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhCKOx5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:53:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 608C064F93;
        Thu, 11 Mar 2021 14:53:56 +0000 (UTC)
Date:   Thu, 11 Mar 2021 09:53:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Subject: Re: Clock sync priorities
Message-ID: <20210311095354.19bfbe1f@gandalf.local.home>
In-Reply-To: <20210311094401.7c6bf259@gandalf.local.home>
References: <20210311094401.7c6bf259@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Mar 2021 09:44:01 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Dario, feel free to comment on this as well. The host-guest is the
> information stored in each guest file that tells it how its TSC matches the
> host (if -C is not used in the record). The ts2nsecs is done on the host
> where it reads the perf data to find out how the kernels converts the TSC
> to nanoseconds, and this information is stored in each trace.dat file (host
> and guest). This email is about how those will affect the current options
> listed above.

Correction, it's the ts2nsecs that is not done if -C is specified on the
record command line. The host / guest is done if the two can agree on a
protocol.

If -C is not specified, and the host knows exactly how the guest TSC is
set, and it has information (from perf) on how to convert TSC to
nanoseconds, then it will use the TSC clock by default and place the
information needed to convert TSC to nanoseconds in each trace.dat file.

-- Steve
