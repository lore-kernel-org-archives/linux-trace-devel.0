Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F340C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 19:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243335AbhKXTTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351345AbhKXTSP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 14:18:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 724F2601FA;
        Wed, 24 Nov 2021 19:15:05 +0000 (UTC)
Date:   Wed, 24 Nov 2021 14:15:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 04/25] trace-cmd library: Add internal helper
 function for writing headers before file sections
Message-ID: <20211124141503.6fae3366@gandalf.local.home>
In-Reply-To: <20211111150900.86585-1-tz.stoyanov@gmail.com>
References: <20211111150900.86585-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:09:00 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Introduce headers before each file section, in trace file version 7. The
> section header has the following format:
>  <2 bytes>, header ID
>  <string>, null terminated ASCII string, description of the header
>  <2 bytes>, section flags:
>      1: the section is compressed
>  <4 bytes>, size of the section
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h                 |  5 ++
>  .../include/private/trace-cmd-private.h       |  1 +
>  lib/trace-cmd/include/trace-cmd-local.h       |  5 ++
>  lib/trace-cmd/trace-output.c                  | 68 +++++++++++++++++++
>  4 files changed, 79 insertions(+)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 7fea4e01..5d71e8ba 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -15,6 +15,11 @@ enum tracecmd_open_flags {
>  	TRACECMD_FL_LOAD_NO_PLUGINS		= 1 << 0, /* Do not load plugins */
>  	TRACECMD_FL_LOAD_NO_SYSTEM_PLUGINS	= 1 << 1, /* Do not load system plugins */
>  };
> +
> +enum tracecmd_section_flags {
> +	TRACECMD_SEC_FL_COMPRESS	= 1 << 0, /* the section is compressed */
> +};
> +
>  struct tracecmd_input *tracecmd_open_head(const char *file, int flags);
>  struct tracecmd_input *tracecmd_open(const char *file, int flags);
>  struct tracecmd_input *tracecmd_open_fd(int fd, int flags);
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index eaa902a3..5b253511 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -138,6 +138,7 @@ enum {
>  	TRACECMD_OPTION_TIME_SHIFT,
>  	TRACECMD_OPTION_GUEST,
>  	TRACECMD_OPTION_TSC2NSEC,
> +	TRACECMD_OPTION_MAX,
>  };
>  
>  enum {
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index d65ff599..d3760483 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -37,6 +37,11 @@ struct data_file_write {
>  bool check_file_state(unsigned long file_version, int current_state, int new_state);
>  bool check_out_state(struct tracecmd_output *handle, int new_state);
>  
> +unsigned long long
> +out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
> +			 char *description, enum tracecmd_section_flags flags, bool option);

Unless you expect only a single flag to ever be passed in, flags cannot be
of type enum. Because two enums or'd together is not a valid enum.

-- Steve


> +int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
> +
>  struct cpu_data_source {
>  	int fd;
>  	int size;
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index e8c788ad..a8c1305d 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -332,6 +332,74 @@ int tracecmd_ftrace_enable(int set)
>  	return ret;
>  }
>  
> +__hidden unsigned long long
> +out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
> +			 char *description, enum tracecmd_section_flags flags, bool option)
> +{
