Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A1EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 18:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6458F6140D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 18:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhJDSqc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 14:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235454AbhJDSqb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 14:46:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2309C61409;
        Mon,  4 Oct 2021 18:44:42 +0000 (UTC)
Date:   Mon, 4 Oct 2021 14:44:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 13/21] trace-cmd library: Fix possible memory leak in
 read_and_parse_cmdlines()
Message-ID: <20211004144440.7c4b2add@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-14-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-14-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:24 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some error paths in read_and_parse_cmdlines() may lead to a memory leak.
> Improved the error handling of this internal function to avoid it.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 60d75d47..9fd7e6e8 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -2999,20 +2999,26 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
>  {
>  	struct tep_handle *pevent = handle->pevent;
>  	unsigned long long size;
> -	char *cmdlines;
> +	char *cmdlines = NULL;
> +	int ret;
>  
>  	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
>  		return 0;
>  
> -	if (read_data_and_size(handle, &cmdlines, &size) < 0)
> -		return -1;
> +	ret = read_data_and_size(handle, &cmdlines, &size);

This function only returns an allocated cmdline on success. That was the
point of this function, was that you didn't have to check and free the
return value.

-- Steve


> +	if (ret < 0)
> +		goto out;
> +	if (!size) {
> +		handle->file_state = TRACECMD_FILE_CMD_LINES;
> +		goto out;
> +	}
>  	cmdlines[size] = 0;
>  	tep_parse_saved_cmdlines(pevent, cmdlines);
> -	free(cmdlines);
> -
>  	handle->file_state = TRACECMD_FILE_CMD_LINES;
> -
> -	return 0;
> +	ret = 0;
> +out:
> +	free(cmdlines);
> +	return ret;
>  }
>  
>  static void extract_trace_clock(struct tracecmd_input *handle, char *line)

