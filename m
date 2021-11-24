Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3C9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 19:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243525AbhKXTjy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243175AbhKXTjw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 14:39:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8084E60F42;
        Wed, 24 Nov 2021 19:36:42 +0000 (UTC)
Date:   Wed, 24 Nov 2021 14:36:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 14/25] trace-cmd library: Introduce sections in trace
 file reading logic
Message-ID: <20211124143641.059939a4@gandalf.local.home>
In-Reply-To: <20211111151112.86751-5-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
        <20211111151112.86751-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:11:07 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace file version 7 is based on sections. Added an internal sections
> database and new helper functions to add, read, open and close file
> sections.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 69 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 0375afba..cc292236 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -115,6 +115,14 @@ struct tsc2nsec {
>  	unsigned long long offset;
>  };
>  
> +struct file_section {
> +	int				id;

There's a 4 byte hole between id and section_offset. Might as well move
that down to flags.

> +	unsigned long long		section_offset;
> +	unsigned long long		data_offset;
> +	enum tracecmd_section_flags	flags;

Again, unless "flags" holds a single enum, it cannot be of type enum.

Just because flags are an enum, does not mean the use of them have to be an
enum. In many cases, enums to define flags have no name. They should be
anonymous enums.

-- Steve

> +	struct file_section		*next;
> +};
> +
>  struct tracecmd_input {
>  	struct tep_handle	*pevent;
>  	unsigned long		file_state;
> @@ -154,6 +162,7 @@ struct tracecmd_input {
>  	struct hook_list	*hooks;
>  	struct pid_addr_maps	*pid_maps;
>  	/* file information */
> +	struct file_section	*sections;
>  	size_t			header_files_start;
>  	size_t			ftrace_files_start;
>  	size_t			event_files_start;
