Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21334C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 21:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6A8E64F91
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 21:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCPV3G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 17:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhCPV2u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 17:28:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0809764F5E;
        Tue, 16 Mar 2021 21:28:49 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:28:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 10/12] trace-cmd: Set order and priorities when applying
 timestamp corrections
Message-ID: <20210316172848.56a20068@gandalf.local.home>
In-Reply-To: <20210315061832.168495-11-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
        <20210315061832.168495-11-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Mar 2021 08:18:30 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There are multiple options that affect the event's timestamps while
> recording trace or displaying the trace file. Some of these options can
> be used together and the order and priorities for all of them should be
> strictly defined:
>  trace-cmd record --date , --ts-offset - only one of these can be used
>  trace-cmd record host-guest trace - guest timestamps are auto
> synchronized with host time stamps. If no trace clock is set by the user
> and "kvm" synch plugin is available, then "x86-tsc" trace clock is used
> and tsc timestamps are converted to nanoseconds in both host and guest
> trace events.
>  trace-cmd report --ts-offset, --ts2secs, --nodate
> 
> Event timestamps corrections are applied in this order, when the trace
> file is opened for reading:
>  1. If it is a guest trace file and there is information for
>     synchronization with the host events and is this synchronization is
>     enabled: synchronize guest events with host events.
>  2. If the user has specified --ts2secs, apply it.
>  3. If the user has not specified --ts2secs and there is information in
>     the trace file metadata for tsc to nanosecond conversion, apply it.
>  4. If the user has specified --ts-offset or --date, apply it. The
>     offsets specified by "report" command have higher priority that the
>     offsets specified by "record" command.
> 

I'll have to play with this a bit, but for now this looks fine.

-- Steve
