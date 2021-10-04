Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C060C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEB561401
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhJDPhb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234984AbhJDPhb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 11:37:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51575613D5;
        Mon,  4 Oct 2021 15:35:42 +0000 (UTC)
Date:   Mon, 4 Oct 2021 11:35:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 07/21] trace-cmd library: Do not use local variables
 when reading CPU stat option
Message-ID: <20211004113540.7d5c470e@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-8-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:18 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Using a local variable to read all CPUSTAT options assumes that all of
> them are in a single option section. While this is true for the current
> trace file version format, this assumption limits the design of a more
> flexible format with multiple options sections. Use input handler context
> instead of the local variable.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 3d7f1c48..d020cfae 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -138,6 +138,7 @@ struct tracecmd_input {
>  
>  	struct host_trace_info	host;
>  	double			ts2secs;
> +	unsigned int		cpustats_size;
>  	char *			cpustats;

The above places cpustats_size (4 bytes) between ts2secs (8 bytes) and
cpustats (8 bytes) on 64 bit machines. Thus, it creates a hole of 4 bytes
of padding.

Best to try to place 4 bytes integers in pairs, where they always take up 8
bytes.

Above this, there's:

	// 8 bytes
	unsigned long long	trace_id;

	// pair 1
	int			fd;
	int			long_size;

	// pair 2
	int			page_size;
	int			page_map_size;

	// pair 3
	int			cpus;
	int			ref;

	// pair 4
	int			nr_buffers;	/* buffer instances */
	bool			use_trace_clock;

	// pair 5
	bool			read_page;
	bool			use_pipe;

	// uneven set of 4 bytes
	int			file_version;

	// 8 bytes
	struct cpu_data 	*cpu_data;

You can move the 4 byte field after file_version to fill in that hole.

>  	char *			uname;
>  	char *			version;
> @@ -2658,7 +2659,6 @@ static int handle_options(struct tracecmd_input *handle)
>  	unsigned short option;
>  	unsigned int size;
>  	char *cpustats = NULL;
> -	unsigned int cpustats_size = 0;
>  	struct input_buffer_instance *buffer;
>  	struct hook_list *hook;
>  	char *buf;
> @@ -2738,12 +2738,16 @@ static int handle_options(struct tracecmd_input *handle)
>  			break;
>  		case TRACECMD_OPTION_CPUSTAT:
>  			buf[size-1] = '\n';
> -			cpustats = realloc(cpustats, cpustats_size + size + 1);
> -			if (!cpustats)
> -				return -ENOMEM;
> -			memcpy(cpustats + cpustats_size, buf, size);
> -			cpustats_size += size;
> -			cpustats[cpustats_size] = 0;
> +			cpustats = realloc(handle->cpustats,
> +					   handle->cpustats_size + size + 1);
> +			if (!cpustats) {
> +				ret = -ENOMEM;
> +				return ret;
> +			}

Changing:

			if (!cpustats)
				return -ENOMEM;

to
			if (!cpustats) {
				ret = -ENOMEM;
				return ret;
			}

Doesn't make sense, as you are just adding a useless use of a local
variable.

-- Steve


> +			memcpy(cpustats + handle->cpustats_size, buf, size);
> +			handle->cpustats_size += size;
> +			cpustats[handle->cpustats_size] = 0;
> +			handle->cpustats = cpustats;
>  			break;
>  		case TRACECMD_OPTION_BUFFER:
>  			/* A buffer instance is saved at the end of the file */
> @@ -2813,8 +2817,6 @@ static int handle_options(struct tracecmd_input *handle)
>  
>  	}
>  
> -	handle->cpustats = cpustats;
> -
>  	return 0;
>  }
>  

