Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A76C43219
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 19:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345487AbiAXT0h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 14:26:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46656 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344966AbiAXTWi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 14:22:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89D94B81257
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 19:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ABCC36AF4;
        Mon, 24 Jan 2022 19:22:35 +0000 (UTC)
Date:   Mon, 24 Jan 2022 14:22:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 04/20] trace-cmd library: Inherit compression
 algorithm from input file
Message-ID: <20220124142234.1edb194d@gandalf.local.home>
In-Reply-To: <20220119082715.245846-5-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
        <20220119082715.245846-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Jan 2022 10:26:59 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When a new trace file output handler is allocated, based on given trace
> file input handler - use the same compression algorithm.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  2 ++
>  lib/trace-cmd/trace-input.c                   | 16 +++++++++++++++
>  lib/trace-cmd/trace-output.c                  | 20 +++++++++++++++++++
>  3 files changed, 38 insertions(+)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index f8f0ba15..bcc4c9f3 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -261,6 +261,8 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
>  
>  unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
>  size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
> +int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
> +				     const char **name, const char **version);
>  
>  int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
>  bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 49ada92f..a81112f0 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -4661,6 +4661,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
>  	return handle->file_version;
>  }
>  
> +/**
> + * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
> + *				      used to compress the trace file

The above is to be short and fit on one line:

	get name and version of compression algorithm

is good enough.

> + * @handle: input handle for the trace.dat file
> + * @name: return, name of the compression algorithm.
> + * @version: return, version of the compression algorithm.

Put in a description here.

> + *
> + * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
> + * algorithm are stored in @name and @version. The returned strings must *not* be freed.
> + */
> +int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
> +				     const char **name, const char **version)
> +{
> +	return tracecmd_compress_proto_get_name(handle->compress, name, version);
> +}
>

-- Steve
