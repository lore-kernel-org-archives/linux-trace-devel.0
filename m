Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CA8C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 15:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3C161972
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 15:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhCVPeF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhCVPdd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 11:33:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 173BF61984;
        Mon, 22 Mar 2021 15:33:32 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:33:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Remove all die()s from trace-cmd library
Message-ID: <20210322113330.4778d3fa@gandalf.local.home>
In-Reply-To: <20210322115422.272718-1-tz.stoyanov@gmail.com>
References: <20210322115422.272718-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 13:54:22 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The die() call is used for a fatal error. It terminates the current
> program with exit(). The program should not be terminated from a library
> routine, the die() call should not be used in trace-cmd library context.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 10 ++++------
>  lib/trace-cmd/trace-util.c  | 21 +--------------------
>  2 files changed, 5 insertions(+), 26 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 2093a3dc..5398154f 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1088,7 +1088,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
>  	int index;
>  
>  	if (!page->ref_count)
> -		die("Page ref count is zero!\n");
> +		return;
>  
>  	page->ref_count--;
>  	if (page->ref_count)
> @@ -1147,7 +1147,7 @@ void tracecmd_free_record(struct tep_record *record)
>  		return;
>  
>  	if (!record->ref_count)
> -		die("record ref count is zero!");
> +		return;
>  
>  	record->ref_count--;
>  
> @@ -1155,7 +1155,7 @@ void tracecmd_free_record(struct tep_record *record)
>  		return;
>  
>  	if (record->locked)
> -		die("freeing record when it is locked!");
> +		return;


The above is really valuable in debugging. We should change them from die()
to a new function, perhaps called "bug()" that works just like die, but
will only die if the user explicitly asks to do so.

Because these "die()" calls have found several bugs in the past.

These are probably the few places I would say do a fprintf(stderr, ...) as
well even when not debugging, because when they are hit, it means something
horrible went wrong.

>  
>  	record->data = NULL;
>  
> @@ -1318,7 +1318,6 @@ static int get_page(struct tracecmd_input *handle, int cpu,
>  
>  	if (offset & (handle->page_size - 1)) {
>  		errno = -EINVAL;
> -		die("bad page offset %llx", offset);
>  		return -1;
>  	}
>  
> @@ -1326,7 +1325,6 @@ static int get_page(struct tracecmd_input *handle, int cpu,
>  	    offset > handle->cpu_data[cpu].file_offset +
>  	    handle->cpu_data[cpu].file_size) {
>  		errno = -EINVAL;
> -		die("bad page offset %llx", offset);
>  		return -1;
>  	}
>  
> @@ -1892,7 +1890,7 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
>  
>  		record = handle->cpu_data[cpu].next;
>  		if (!record->data)
> -			die("Something freed the record");
> +			return NULL;

I know I hate it when libraries do output, but the above really should be
at least printed (maybe not crash). Because they are equivalent to a
"WARN_ON()" in the kernel.

And when I screw something up, these are the first notifications I see
telling me I screwed something up ;-)

I know I told you that we should get rid of all prints from the library, as
I hate seeing them in applications (libgtk is horrible with that). But now
seeing what is calling it, I change my mind about it.


>  
>  		if (handle->cpu_data[cpu].timestamp == record->ts)
>  			return record;
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 538adbc2..ce2e7afb 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -378,25 +378,6 @@ void __noreturn __die(const char *fmt, ...)
>  	va_end(ap);
>  }
>  
> -void __weak __noreturn die(const char *fmt, ...)
> -{
> -	va_list ap;
> -
> -	va_start(ap, fmt);
> -	__vdie(fmt, ap);
> -	va_end(ap);
> -}
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

We should make these internal functions, that always call warning() (which
we probably should change to tracecmd_warning()), and with some flag set,
would still crash the application.

-- Steve


> -
>  #define LOG_BUF_SIZE 1024
>  static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
>  {
> @@ -547,7 +528,7 @@ int tracecmd_count_cpus(void)
>  
>  	fp = fopen("/proc/cpuinfo", "r");
>  	if (!fp)
> -		die("Can not read cpuinfo");
> +		return 0;
>  
>  	while ((r = getline(&pbuf, pn, fp)) >= 0) {
>  		char *p;

