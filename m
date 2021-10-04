Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39D3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5415613DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhJDP5s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234735AbhJDP5r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 11:57:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675BF611AE;
        Mon,  4 Oct 2021 15:55:58 +0000 (UTC)
Date:   Mon, 4 Oct 2021 11:55:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 11/21] trace-cmd library: Fix possible memory leak in
 read_proc_kallsyms()
Message-ID: <20211004115557.30994c9e@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-12-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:22 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some error paths in read_proc_kallsyms() may lead to a memory leak.
> Improved the error handling of this internal function to avoid it.

How so?

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 39 +++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 32358ce9..9b23063e 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -739,34 +739,39 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
>  
>  static int read_proc_kallsyms(struct tracecmd_input *handle)
>  {
> -	struct tep_handle *pevent = handle->pevent;
> +	struct tep_handle *tep = handle->pevent;
>  	unsigned int size;
> -	char *buf;
> +	char *buf = NULL;
> +	int ret;
>  
>  	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
>  		return 0;
>  
> -	if (read4(handle, &size) < 0)
> -		return -1;
> -	if (!size)
> -		return 0; /* OK? */
> +	ret = read4(handle, &size);
> +	if (ret < 0)
> +		goto out;
> +	if (!size) {
> +		handle->file_state = TRACECMD_FILE_KALLSYMS;
> +		goto out; /* OK? */
> +	}
>  

Allocation of buf happens below. There's no reason to jump to out. It
should just return here. Then you don't need to initialize buf.

>  	buf = malloc(size+1);
> -	if (!buf)
> -		return -1;
> -	if (do_read_check(handle, buf, size)){
> -		free(buf);

buf is freed here on the error path in the original code.

> -		return -1;
> +	if (!buf) {
> +		ret = -1;
> +		goto out;

The above doesn't even make sense. The only thing jumping to out does here
is to free buf, in which case, there is no buf to free.

>  	}
> -	buf[size] = 0;
> -
> -	tep_parse_kallsyms(pevent, buf);
> +	ret = do_read_check(handle, buf, size);
> +	if (ret < 0)
> +		goto out;
>  
> -	free(buf);
> +	buf[size] = 0;
> +	tep_parse_kallsyms(tep, buf);

If you want to make another patch to do the slight updates to state that
this patch does (but does not express in the change log), that's fine. But
as this patch stands, it does not do what the change log states, so I'm
removing this patch from the series.

-- Steve


>  
>  	handle->file_state = TRACECMD_FILE_KALLSYMS;
> -
> -	return 0;
> +	ret = 0;
> +out:
> +	free(buf);
> +	return ret;
>  }
>  
>  static int read_ftrace_printk(struct tracecmd_input *handle)

