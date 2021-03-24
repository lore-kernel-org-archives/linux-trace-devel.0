Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0029EC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F15619FF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhCXPeN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236627AbhCXPd5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:33:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB90061992;
        Wed, 24 Mar 2021 15:33:56 +0000 (UTC)
Date:   Wed, 24 Mar 2021 11:33:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 19/23] trace-cmd: Print times in TimeShift options as
 unsigned in trace-cmd dump
Message-ID: <20210324113355.08690148@gandalf.local.home>
In-Reply-To: <20210324130418.436206-20-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-20-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:04:14 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Fixed "trace-cmd dump" subcommand to print unsigned times from
> Time Shift option in a trace.dat file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-dump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
> index 31b9d201..f5b864f7 100644
> --- a/tracecmd/trace-dump.c
> +++ b/tracecmd/trace-dump.c
> @@ -373,7 +373,7 @@ static void dump_option_timeshift(int fd, int size)
>  {
>  	long long *scalings = NULL;
>  	long long *offsets = NULL;
> -	long long *times = NULL;
> +	unsigned long long *times = NULL;
>  	long long trace_id;
>  	unsigned int count;
>  	unsigned int flags;

You also want to make the following change:

	for (i = 0; i < count; i++)
-		do_print(OPTIONS, "\t%lld * %lld %lld [offset * scaling @ time]\n",
+		do_print(OPTIONS, "\t%lld * %lld %llu [offset * scaling @ time]\n",
			 offsets[i], scalings[1], times[i]);

Which actually is the more important one.

-- Steve
