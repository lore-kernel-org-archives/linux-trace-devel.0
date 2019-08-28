Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDE2C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1344F22CF8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfH1UPi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 16:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1UPi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 16:15:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2230217F5;
        Wed, 28 Aug 2019 20:15:36 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:15:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 6/8] trace-cmd: Move plog() function to libtracecmd.
Message-ID: <20190828161535.00e11800@gandalf.local.home>
In-Reply-To: <20190814084712.28188-7-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
        <20190814084712.28188-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Aug 2019 11:47:06 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> plog() function writes logs into a log file. It is used in
> libtracecmd and its implementation should be there.
> The function is moved from trace-cmd into the library, and 2
> additional APIs are implemented:
> 	int trace_set_log_file(char *logfile); - use it to set
> the log file.
> 	void plog_error(const char *fmt, ...); - use it to log
> an error message into the file.
> 
> The plog() function is used also from pdie() in trace-cmd.
> pdie() depends on trace-cmd context and cannot be moved to
> the library. It is reimplemented as macros, in order to utilize
> the new plog() library function.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h |  4 ++
>  include/trace-cmd/trace-msg.h |  3 --
>  lib/trace-cmd/trace-util.c    | 71 +++++++++++++++++++++++++++++++++++
>  tracecmd/trace-listen.c       | 69 ++++------------------------------
>  4 files changed, 83 insertions(+), 64 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index b96de04..8db0686 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -398,6 +398,10 @@ struct hook_list {
>  struct hook_list *tracecmd_create_event_hook(const char *arg);
>  void tracecmd_free_hooks(struct hook_list *hooks);
>  
> +void plog(const char *fmt, ...);
> +void plog_error(const char *fmt, ...);

If these are going to become visible in the library, then they need to
have a prefix "tracecmd_" attached to them.

> +int trace_set_log_file(char *logfile);
> +
>  /* --- Hack! --- */
>  int tracecmd_blk_hack(struct tracecmd_input *handle);
>  
> diff --git a/include/trace-cmd/trace-msg.h b/include/trace-cmd/trace-msg.h
> index b7fe10b..aab8a69 100644
> --- a/include/trace-cmd/trace-msg.h
> +++ b/include/trace-cmd/trace-msg.h
> @@ -12,7 +12,4 @@
>  
>  extern unsigned int page_size;
>  
> -void plog(const char *fmt, ...);
> -void pdie(const char *fmt, ...);
> -
>  #endif /* _TRACE_MSG_H_ */
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index b5ce84f..8c1a0a0 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -31,6 +31,8 @@ int tracecmd_disable_plugins;
>  static int tracecmd_quiet;
>  static bool tracecmd_debug;
>  
> +static FILE *trace_logfp;

As this is a static variable, we only need to call it logfp.

> +
>  static struct registered_plugin_options {
>  	struct registered_plugin_options	*next;
>  	struct tep_plugin_option			*options;
> @@ -1716,3 +1718,72 @@ void __weak *malloc_or_die(unsigned int size)
>  		die("malloc");
>  	return data;
>  }
> +
> +#define LOG_BUF_SIZE 1024
> +static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
> +{
> +	static int newline = 1;
> +	char buf[LOG_BUF_SIZE];
> +	int r;
> +
> +	r = vsnprintf(buf, LOG_BUF_SIZE, fmt, ap);
> +
> +	if (r > LOG_BUF_SIZE)
> +		r = LOG_BUF_SIZE;
> +
> +	if (trace_logfp) {
> +		if (newline)
> +			fprintf(trace_logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
> +		else
> +			fprintf(trace_logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
> +		newline = buf[r - 1] == '\n';
> +		fflush(trace_logfp);
> +		return;
> +	}
> +
> +	fprintf(fp, "%.*s", r, buf);
> +}
> +
> +void plog(const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	__plog("", fmt, ap, stdout);
> +	va_end(ap);
> +	/* Make sure it gets to the screen, in case we crash afterward */
> +	fflush(stdout);
> +}
> +
> +void plog_error(const char *fmt, ...)
> +{
> +	va_list ap;
> +	char *str = "";
> +
> +	va_start(ap, fmt);
> +	__plog("Error: ", fmt, ap, stderr);
> +	va_end(ap);
> +	if (errno)
> +		str = strerror(errno);
> +	if (trace_logfp)
> +		fprintf(trace_logfp, "\n%s\n", str);
> +	else
> +		fprintf(stderr, "\n%s\n", str);
> +}
> +
> +/**
> + * trace_set_log_file - Set file for logging
> + * @logfile: Name of the log file
> + *
> + * Returns 0 on successful completion or -1 in case of error
> + */
> +int trace_set_log_file(char *logfile)

Should it be called tracecmd_set_logfile()?

-- Steve

> +{
> +	if (trace_logfp)
> +		fclose(trace_logfp);
> +	trace_logfp = fopen(logfile, "w");
> +	if (!trace_logfp)
> +		return -1;
> +	return 0;
> +}
> +
