Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1D6C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F48E60295
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhCXVxk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234623AbhCXVxL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 17:53:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F412661A1E;
        Wed, 24 Mar 2021 21:53:10 +0000 (UTC)
Date:   Wed, 24 Mar 2021 17:53:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Remove all die()s from trace-cmd library
Message-ID: <20210324175309.4e154757@gandalf.local.home>
In-Reply-To: <20210324135143.445443-1-tz.stoyanov@gmail.com>
References: <20210324135143.445443-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:51:43 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -366,36 +366,32 @@ void __noreturn __vdie(const char *fmt, va_list ap)
>  	vfprintf(stderr, fmt, ap);
>  
>  	fprintf(stderr, "\n");
> -	exit(ret);
> +	return ret;
>  }
>  
> -void __noreturn __die(const char *fmt, ...)
> +#ifdef LIB_DIE

I wonder if it would be more useful not to have it as a compile time
define, but instead a global variable:

static bool lib_die;

void tracecmd_die_on_error(void)
{
	lib_die = true;
}

Make the "die()" functions into static variables here.

void __hidden _lib_fatal(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	if (lib_die)
		__vdie(fmt, ap);
	else
		__vwarning(fmt, ap);
	va_end(ap);
}

That way if we run trace-cmd with the --debug option, it could then call
the tracecmd_die_on_error() function, and it will crash on any "fatal"
places.

-- Steve


> +
> +void __noreturn _lib_fatal(const char *fmt, ...)
>  {
>  	va_list ap;
> +	int ret;
>  
>  	va_start(ap, fmt);
> -	__vdie(fmt, ap);
> +	ret = __vlib_fatal(fmt, ap);
>  	va_end(ap);
> +	exit(ret);
>  }
>  
> -void __weak __noreturn die(const char *fmt, ...)
> +#else
> +void _lib_fatal(const char *fmt, ...)
>  {
>  	va_list ap;
>  
>  	va_start(ap, fmt);
> -	__vdie(fmt, ap);
> +	__vlib_fatal(fmt, ap);
>  	va_end(ap);
>  }
> -
> -void __weak *malloc_or_die(unsigned int size)
> -{
> -	void *data;
> -
> -	data = malloc(size);
> -	if (!data)
> -		die("malloc");
> -	return data;
> -}
> +#endif
>  
