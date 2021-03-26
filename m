Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85453C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 18:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E4F619B6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 18:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhCZSXd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 14:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhCZSXB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 14:23:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A059C61A36;
        Fri, 26 Mar 2021 18:23:00 +0000 (UTC)
Date:   Fri, 26 Mar 2021 14:22:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] trace-cmd: Remove all die()s from trace-cmd library
Message-ID: <20210326142259.4c9dfc67@gandalf.local.home>
In-Reply-To: <20210325083932.553120-1-tz.stoyanov@gmail.com>
References: <20210325083932.553120-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Mar 2021 10:39:32 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -353,12 +353,12 @@ trace_load_plugins(struct tep_handle *tep, int flags)
>  	return list;
>  }
>  
> -void __noreturn __vdie(const char *fmt, va_list ap)
> +void __vlib_fatal(const char *fmt, va_list ap)
>  {
>  	int ret = errno;
>  
>  	if (errno)
> -		perror("trace-cmd");
> +		perror("libtracecmd");
>  	else
>  		ret = -1;
>  


> -void __weak __noreturn die(const char *fmt, ...)
> +void _lib_fatal(const char *fmt, ...)

Looks good, but I wonder if we should make these functions hidden, or at
least rename them to: tracecmd_lib_fatal(), and also make them weak, to
allow applications to override them (display pop ups, like KernelShark can
do).

-- Steve


>  {
>  	va_list ap;
>  
>  	va_start(ap, fmt);
> -	__vdie(fmt, ap);
> +	__vlib_fatal(fmt, ap);
>  	va_end(ap);
>  }
>  
