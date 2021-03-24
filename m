Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130B2C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D307C61A1E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhCXVY4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238354AbhCXVYs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 17:24:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A43261A1E;
        Wed, 24 Mar 2021 21:24:48 +0000 (UTC)
Date:   Wed, 24 Mar 2021 17:24:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 22/23] trace-cmd: Save the trace clocks in TRACECLOCK
 option
Message-ID: <20210324172446.611276a4@gandalf.local.home>
In-Reply-To: <20210324130418.436206-23-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-23-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:04:17 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Save the content of the trace_clock file in the TRACECLOCK option in
> the trace.dat file. The clocks can be printed with "trace-cmd dump
> --options" command.
> These clocks were saved right before the tracing data in the file, but
> this patch set changed that logic. Now only the selected clock is saved
> in the file before the tracing data.
> Having all supported trace clocks in the file is useful for debug
> purposes. Adding clocks in the existing TRACECLOCK option is save and
> will not break the older versions of trace-cmd.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 2fc6723a..f4c27ef1 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4138,6 +4138,7 @@ enum {
>  static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
>  {
>  	int type = 0;
> +	char *clocks;
>  
>  	if (ctx->date2ts) {
>  		if (ctx->data_flags & DATA_FL_DATE)
> @@ -4149,12 +4150,15 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
>  	if (type)
>  		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
>  
> -	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> +	clocks = tracefs_instance_file_read(NULL, "trace_clock", NULL);
> +	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK,
> +			    clocks ? strlen(clocks)+1 : 0, clocks);

Strange. Even after applying this patch, I still get:

# ./tracecmd/trace-cmd dump

 Tracing meta data in file trace.dat:
        [Initial format]
                6       [Version]
                0       [Little endian]
                8       [Bytes in a long]
                4096    [Page size, bytes]
        [Header page, 205 bytes]
        [Header event, 205 bytes]
        [Ftrace format, 15 events]
        [Events format, 104 systems]
        [Kallsyms, 6978379 bytes]
        [Trace printk, 4997 bytes]
        [Saved command lines, 1987 bytes]
        8 [CPUs with tracing data]
        [13 options]
        [Flyrecord tracing data]
        [Tracing clock]
                 No tracing clock saved in the file


Seems to be that it skips over the options unless you explicitly ask for it.

-- Steve

>  	add_option_hooks(handle);
>  	add_uname(handle);
>  	add_version(handle);
>  	if (!no_top_instance())
>  		add_trace_id(handle, &top_instance);
> +	free(clocks);
>  }
>  
>  static void write_guest_file(struct buffer_instance *instance)

