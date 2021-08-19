Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9505C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94422610A0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhHSTLW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSTLW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:11:22 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 728F86056C;
        Thu, 19 Aug 2021 19:10:43 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:10:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 31/87] trace-cmd library: Fit CPU latency trace data
 in the new trace file version 7 format
Message-ID: <20210819151036.1e5b7303@oasis.local.home>
In-Reply-To: <20210729050959.12263-32-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-32-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:03 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -135,6 +135,7 @@ enum {
>  	TRACECMD_OPTION_TIME_SHIFT,
>  	TRACECMD_OPTION_GUEST,
>  	TRACECMD_OPTION_TSC2NSEC,
> +	TRACECMD_OPTION_BUFFER_LAT,

I just realized that this will break the parsing.

You can't add an enum in the middle. That will cause all the other
enums to shift in value,  and these are already a file API.

>  	TRACECMD_OPTION_HEADER_INFO,

For example, if you saved a file before this patch, the
TRACECMD_OPTION_HEADER_INFO will be one number, and stored in the
trace.dat file.

Then if you try to read that same trace.dat file after this patch, it
will interpret the TRACECMD_OPTION_HEADER_INFO as
TRACECMD_OPTION_BUFFER_LAT, which will obviously be incorrect.

-- Steve



>  	TRACECMD_OPTION_FTRACE_EVENTS,
>  	TRACECMD_OPTION_EVENT_FORMATS,
