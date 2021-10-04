Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D9EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2485761354
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhJDPoy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235275AbhJDPoy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 11:44:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F28636113A;
        Mon,  4 Oct 2021 15:43:04 +0000 (UTC)
Date:   Mon, 4 Oct 2021 11:43:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 08/21] trace-cmd library: Reuse within the library
 the function that checks file state.
Message-ID: <20211004114303.1aee4576@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-9-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:19 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Make the function, that checks if the next file state is valid, global
> for the trace-cmd library, so it can be reused. It is important the same check
> logic to be used in the whole library.

FYI, Normally this would be broken into two patches.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/trace-cmd-local.h |  2 +
>  lib/trace-cmd/trace-input.c             |  1 +
>  lib/trace-cmd/trace-output.c            | 66 ++++++++-----------------
>  lib/trace-cmd/trace-util.c              | 28 +++++++++++
>  4 files changed, 51 insertions(+), 46 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index 821b5cdb..7f3b45a8 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -31,5 +31,7 @@ void tracecmd_info(const char *fmt, ...);
>  #endif
>  #endif
>  
> +bool check_file_state(unsigned long file_version, int current_state, int new_state);
> +bool check_out_state(struct tracecmd_output *handle, int new_state);

The first just adding the check_out_state.



> @@ -1661,3 +1630,8 @@ out_free:
>  	tracecmd_output_close(handle);
>  	return NULL;
>  }
> +
> +__hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
> +{
> +	return check_file_state(handle->file_version, handle->file_state, new_state);
> +}
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 9bc94822..db7ce7ee 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -624,3 +624,31 @@ bool tracecmd_is_version_supported(unsigned int version)
>  		return true;
>  	return false;
>  }

The second patch, adding the file_version parameter, as currently nothing
uses this, and it really isn't part of what this patch should do.

But I'll just take this as is for now.

-- Steve


> +
> +__hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
> +{
> +	switch (new_state) {
> +	case TRACECMD_FILE_HEADERS:
> +	case TRACECMD_FILE_FTRACE_EVENTS:
> +	case TRACECMD_FILE_ALL_EVENTS:
> +	case TRACECMD_FILE_KALLSYMS:
> +	case TRACECMD_FILE_PRINTK:
> +	case TRACECMD_FILE_CMD_LINES:
> +	case TRACECMD_FILE_CPU_COUNT:
> +		if (current_state == (new_state - 1))
> +			return true;
> +		break;
> +	case TRACECMD_FILE_OPTIONS:
> +		if (current_state == (new_state - 1))
> +			return true;
> +		break;
> +	case TRACECMD_FILE_CPU_LATENCY:
> +	case TRACECMD_FILE_CPU_FLYRECORD:
> +		if (current_state == TRACECMD_FILE_OPTIONS)
> +			return true;
> +		break;
> +	}
> +
> +	return false;
> +}
> +

