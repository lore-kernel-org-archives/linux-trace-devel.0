Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F325EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 21:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D6D613C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 21:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhEMVhR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 17:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhEMVhR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 17:37:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCBFD613E6;
        Thu, 13 May 2021 21:36:06 +0000 (UTC)
Date:   Thu, 13 May 2021 17:36:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] trace-cmd: Add new function to set log level
Message-ID: <20210513173605.030af4cd@gandalf.local.home>
In-Reply-To: <20210507095333.1080910-9-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
        <20210507095333.1080910-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  7 May 2021 12:53:33 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Introduce a new trace-cmd internal function to set the application log
> level.
>  trace_set_verbose()
> The log level can be set using string with log id or log name.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/include/trace-local.h |  2 ++
>  tracecmd/trace-cmd.c           | 41 ++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index b3997d00..8da07c83 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -39,6 +39,8 @@ void usage(char **argv);
>  extern int silence_warnings;
>  extern int show_status;
>  
> +int trace_set_verbose(char *level);
> +
>  struct pid_record_data {
>  	int			pid;
>  	int			brass[2];
> diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> index 60cd3ea1..4e4a73af 100644
> --- a/tracecmd/trace-cmd.c
> +++ b/tracecmd/trace-cmd.c
> @@ -45,6 +45,47 @@ void *malloc_or_die(unsigned int size)
>  	return data;
>  }
>  
> +static struct trace_log_severity {
> +	int		id;
> +	const char	*name;
> +} log_severtity[] = {

Is there a reason for the extra 't' in severity?

> +	{ .id = TEP_LOG_NONE, .name = "none" },
> +	{ .id = TEP_LOG_CRITICAL, .name = "crit" },
> +	{ .id = TEP_LOG_ERROR, .name = "err" },
> +	{ .id = TEP_LOG_WARNING, .name = "warn" },
> +	{ .id = TEP_LOG_INFO, .name = "info" },
> +	{ .id = TEP_LOG_DEBUG, .name = "debug" },
> +	{ .id = TEP_LOG_ALL, .name = "all" },
> +};
> +
> +int trace_set_verbose(char *level)
> +{
> +	int id;
> +
> +	if (!level)
> +		return -1;
> +
> +	if (isdigit(level[0])) {
> +		id = atoi(level);
> +		if (id >= TEP_LOG_NONE && id <= TEP_LOG_ALL) {
> +			tracecmd_set_loglevel(id);
> +			return 0;
> +		}
> +	} else {
> +		int size = sizeof(log_severtity) / sizeof(log_severtity[0]);

This can be shortened to:

		int size = ARRAY_SIZE(log_severity);

Or at least we need to copy that macro to something that trace-cmd core has
access to (see lib/trace-cmd/include/private/trace-cmd-private.h)


> +		int i;
> +
> +		for (i = 0; i < size; i++) {
> +			if (strlen(level) >= strlen(log_severtity[i].name) &&

Why the strlen test? It's OK to pass in "debugignorme"? What's the use case
for this?

Anyway, I applied the first two patches of this series.

-- Steve


> +			    !strncmp(level, log_severtity[i].name, strlen(log_severtity[i].name))) {
> +				tracecmd_set_loglevel(log_severtity[i].id);
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	return -1;
> +}
>  
>  /**
>   * struct command

