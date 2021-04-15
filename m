Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DD7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF23261008
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhDONe4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233115AbhDONey (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:34:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6646261008;
        Thu, 15 Apr 2021 13:34:30 +0000 (UTC)
Date:   Thu, 15 Apr 2021 09:34:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Suppress trace library warnings
Message-ID: <20210415093428.1a3a1678@gandalf.local.home>
In-Reply-To: <20210415080316.3482986-1-tz.stoyanov@gmail.com>
References: <20210415080316.3482986-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Apr 2021 11:03:16 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Suppress all warnings from libtraceevent, libtracefs and libtracecmd if
> the trace-cmd application does not run in debug mode.

Actually, don't we have a -q option to turn off warnings from trace-cmd?

From the man page:

       -q
           Quiet non critical warnings.

Which I see, currently doesn't work, but should. Not being able to parse
events is something we should keep displaying by default, but it should
not be displayed if -q is on the command line.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-cmd.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> index 7376c5a5..7de0671e 100644
> --- a/tracecmd/trace-cmd.c
> +++ b/tracecmd/trace-cmd.c
> @@ -35,6 +35,23 @@ void warning(const char *fmt, ...)
>  	fprintf(stderr, "\n");
>  }
>  
> +int tep_vwarning(const char *name, const char *fmt, va_list ap)
> +{
> +	int ret = errno;
> +
> +	if (!tracecmd_get_debug())
> +		return ret;
> +
> +	if (errno)
> +		perror(name);
> +
> +	fprintf(stderr, "  ");
> +	vfprintf(stderr, fmt, ap);
> +	fprintf(stderr, "\n");
> +
> +	return ret;
> +}
> +
>  void pr_stat(const char *fmt, ...)
>  {
>  	va_list ap;

