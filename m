Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D1DC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 21:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECFA9613F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 21:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhEMVXU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 17:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhEMVXT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 17:23:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4DC61182;
        Thu, 13 May 2021 21:22:08 +0000 (UTC)
Date:   Thu, 13 May 2021 17:22:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] trace-cmd library: Add tracecmd_info() log
 function
Message-ID: <20210513172206.3f3f577f@gandalf.local.home>
In-Reply-To: <20210507095333.1080910-3-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
        <20210507095333.1080910-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  7 May 2021 12:53:27 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -2934,6 +2934,20 @@ static void test_event(struct event_list *event, const char *path,
>  
>  	*save = event;
>  }
> +static void pr_stat(const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	if (!show_status)
> +		return;
> +
> +	va_start(ap, fmt);
> +	vprintf(fmt, ap);
> +	va_end(ap);
> +
> +	printf("\n");
> +}
> +
>  

Since we need to keep the library pr_stat() for backward compatibility, I
rename this to "print_event()" as that's what it was doing locally anyway.

Otherwise it conflicted with the old pr_stat() that I added back to
libtraceevent.

-- Steve
