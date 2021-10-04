Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68B0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 18:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B286140D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 18:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbhJDSoz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 14:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235696AbhJDSoz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 14:44:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A89E861409;
        Mon,  4 Oct 2021 18:43:05 +0000 (UTC)
Date:   Mon, 4 Oct 2021 14:43:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 12/21] trace-cmd library: Fix possible memory leak in
 read_ftrace_printk()
Message-ID: <20211004144303.191807b4@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-13-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-13-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:23 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some error paths in read_ftrace_printk() may lead to a memory leak.
> Improved the error handling of this internal function to avoid it.

Again, I don't see a possible memory leak.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 9b23063e..60d75d47 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -777,33 +777,39 @@ out:
>  static int read_ftrace_printk(struct tracecmd_input *handle)
>  {
>  	unsigned int size;
> -	char *buf;
> +	char *buf = NULL;
> +	int ret;
>  
>  	if (handle->file_state >= TRACECMD_FILE_PRINTK)
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
> +		handle->file_state = TRACECMD_FILE_PRINTK;
> +		goto out; /* OK? */
> +	}
>  
>  	buf = malloc(size + 1);
> -	if (!buf)
> -		return -1;
> -	if (do_read_check(handle, buf, size)) {
> -		free(buf);
> -		return -1;
> +	if (!buf) {
> +		ret = -1;
> +		goto out;
>  	}
> +	ret = do_read_check(handle, buf, size);
> +	if (ret < 0)
> +		goto out;
>  
>  	buf[size] = 0;
>  
>  	tep_parse_printk_formats(handle->pevent, buf);
>  
> -	free(buf);
> -
>  	handle->file_state = TRACECMD_FILE_PRINTK;
> +	ret = 0;
>  
> -	return 0;
> +out:
> +	free(buf);
> +	return ret;
>  }
>  
>  static int read_and_parse_cmdlines(struct tracecmd_input *handle);

