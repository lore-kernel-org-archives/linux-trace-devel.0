Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1751C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E84164DFF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBWWTC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 17:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhBWWTB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 17:19:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C7564DFF;
        Tue, 23 Feb 2021 22:18:20 +0000 (UTC)
Date:   Tue, 23 Feb 2021 17:18:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] trace-cmd: Add validation for reading and
 writing trace.dat files
Message-ID: <20210223171819.3b42b9e8@gandalf.local.home>
In-Reply-To: <20210219053156.2235035-2-tz.stoyanov@gmail.com>
References: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
        <20210219053156.2235035-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Feb 2021 07:31:55 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> trace.dat files have multiple sections, which must be in strict order. A
> new logic is implemented, which checks the order of all mandatory
> sections when reading and writing trace files. This validation is
> useful when the file is constructed in different machines -
> host / guest or listener tracing. In those use cases, part of the file
> is generated in the client machine and is transferred to the server as
> a sequence of bytes. The server should validate the format of the received
> portion of the file and the order of the sections in it.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---

>  /* --- Opening and Reading the trace.dat file --- */
>  
> +enum  {
> +	TRACECMD_FILE_INIT,
> +	TRACECMD_FILE_HEADERS,
> +	TRACECMD_FILE_FTRACE_EVENTS,
> +	TRACECMD_FILE_ALL_EVENTS,
> +	TRACECMD_FILE_KALLSYMS,
> +	TRACECMD_FILE_PRINTK,
> +	TRACECMD_FILE_CMD_LINES,
> +	TRACECMD_FILE_CPU_COUNT,
> +	TRACECMD_FILE_OPTIONS,
> +	TRACECMD_FILE_CPU_LATENCY,
> +	TRACECMD_FILE_CPU_FLYRECORD,

I still really don't think we want to make LATENCY and FLYRECORD states.
Because they are not a state of the trace.dat file, but a type.

Unless we document here that they are the last states of the file, and once
reached, the state can not change.

But is that the case? We may want states about reading 

> +};
> +
>  enum {
>  	TRACECMD_OPTION_DONE,
>  	TRACECMD_OPTION_DATE,
> @@ -115,9 +129,7 @@ enum {
>  enum {
>  	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
>  	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
> -	TRACECMD_FL_LATENCY		= (1 << 2),
> -	TRACECMD_FL_IN_USECS		= (1 << 3),
> -	TRACECMD_FL_FLYRECORD		= (1 << 4),
> +	TRACECMD_FL_IN_USECS		= (1 << 2),
>  };
>  

> @@ -2665,9 +2678,9 @@ static int read_options_type(struct tracecmd_input *handle)
>  	 * Check if this is a latency report or flyrecord.
>  	 */
>  	if (strncmp(buf, "latency", 7) == 0)
> -		handle->flags |= TRACECMD_FL_LATENCY;
> +		handle->file_state = TRACECMD_FILE_CPU_LATENCY;
>  	else if (strncmp(buf, "flyrecord", 9) == 0)
> -		handle->flags |= TRACECMD_FL_FLYRECORD;
> +		handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;

What happens when we change states after this? Or is this going to always
be the last state of the file?

What if we want to change the state after we read the CPUs, or for the
latency, we may want to change the state after reading the trace file.

The more I think about this, the more having them be states does not make
sense. They are the type of file, and should stay as flags.

What benefit do you see for keeping them a state?

-- Steve
