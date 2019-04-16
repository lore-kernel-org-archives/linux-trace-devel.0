Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C751C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 22:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 399582173C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 22:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfDPWsh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 18:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbfDPWsh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 18:48:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28BF52173C;
        Tue, 16 Apr 2019 22:48:36 +0000 (UTC)
Date:   Tue, 16 Apr 2019 18:48:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from
 libtraceevent
Message-ID: <20190416184832.2bb69162@gandalf.local.home>
In-Reply-To: <20190415125823.4011-1-tstoyanov@vmware.com>
References: <20190415125823.4011-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Tzvetomir,

A couple of nits.

In the subject line, we follow Linux standards (well, Linus's
preferences), which is to capitalize the first letter in the subject
description:

  trace-cmd: Remove parsing_failures APIs from libtraceevent


On Mon, 15 Apr 2019 15:58:22 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> The application, which uses libtraceevent, should track itself the number of
> failures while parsing the event files. The libtraceevent APIs return error
> in case of such failure. The application can check for it and track the
> parcing failures, if needed.

 "parsing"

> The patch changes:

Also, the kernel community doesn't care for mentioning the patch in the
change log. As they feel its redundant. They prefer something like:

parsing failures, if needed.
  The following is performed:

Some more nits below.

>  - traceecent library: remove the parsing failures APIs and logic.
>  - trace-cmd library:
> 	added new parameter "int *parsing_failures" to tracecmd_fill_local_events().
> 	implemented new API tracecmd_read_headers_failures(), which returns
> 		the number of failures while parsing the event files.
>  - trace-cmd application:
> 	use the new trace-cmd library APIs to track the number of parsing failures.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h      |  5 +-
>  include/traceevent/event-parse.h   |  2 -
>  lib/trace-cmd/trace-input.c        | 76 +++++++++++++++++++++---------
>  lib/trace-cmd/trace-util.c         | 16 ++++---
>  lib/traceevent/event-parse-api.c   | 27 -----------
>  lib/traceevent/event-parse-local.h |  2 -
>  tracecmd/trace-check-events.c      |  6 +--
>  tracecmd/trace-read.c              |  7 +--
>  8 files changed, 73 insertions(+), 68 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index ca4452b..c0eb7e1 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -32,7 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
>  char **tracecmd_event_systems(const char *tracing_dir);
>  char **tracecmd_system_events(const char *tracing_dir, const char *system);
>  struct tep_handle *tracecmd_local_events(const char *tracing_dir);
> -int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent);
> +int tracecmd_fill_local_events(const char *tracing_dir,
> +			       struct tep_handle *pevent, int *parsing_failures);
>  char **tracecmd_local_plugins(const char *tracing_dir);
>  
>  char **tracecmd_add_list(char **list, const char *name, int len);
> @@ -107,6 +108,8 @@ struct tracecmd_input *tracecmd_open_fd(int fd);
>  void tracecmd_ref(struct tracecmd_input *handle);
>  void tracecmd_close(struct tracecmd_input *handle);
>  int tracecmd_read_headers(struct tracecmd_input *handle);
> +int tracecmd_read_headers_failures(struct tracecmd_input *handle,
> +				   int *parsing_failures);
>  int tracecmd_long_size(struct tracecmd_input *handle);
>  int tracecmd_page_size(struct tracecmd_input *handle);
>  int tracecmd_cpus(struct tracecmd_input *handle);
> diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
> index bded403..5e0fd19 100644
> --- a/include/traceevent/event-parse.h
> +++ b/include/traceevent/event-parse.h
> @@ -557,8 +557,6 @@ void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian);
>  bool tep_is_latency_format(struct tep_handle *tep);
>  void tep_set_latency_format(struct tep_handle *tep, int lat);
>  int tep_get_header_page_size(struct tep_handle *tep);
> -void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
> -int tep_get_parsing_failures(struct tep_handle *tep);
>  int tep_get_header_timestamp_size(struct tep_handle *tep);
>  bool tep_is_old_format(struct tep_handle *tep);
>  void tep_set_print_raw(struct tep_handle *tep, int print_raw);
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index d5ee371..565675f 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -395,7 +395,8 @@ static int regex_event_buf(const char *file, int size, regex_t *epreg)
>  
>  static int read_ftrace_file(struct tracecmd_input *handle,
>  			    unsigned long long size,
> -			    int print, regex_t *epreg)
> +			    int print, regex_t *epreg,
> +			    int *parsing_failures)
>  {
>  	struct tep_handle *pevent = handle->pevent;
>  	char *buf;
> @@ -412,8 +413,9 @@ static int read_ftrace_file(struct tracecmd_input *handle,
>  		if (print || regex_event_buf(buf, size, epreg))
>  			printf("%.*s\n", (int)size, buf);
>  	} else {
> -		if (tep_parse_event(pevent, buf, size, "ftrace"))
> -			tep_set_parsing_failures(pevent, 1);
> +		if (tep_parse_event(pevent, buf, size, "ftrace") &&
> +		    parsing_failures)

This is one of those cases where breaking the line for the 80 character
rule makes the code harder to read, and shouldn't be done.

> +			(*parsing_failures)++;
>  	}
>  	free(buf);
>  
> @@ -423,7 +425,7 @@ static int read_ftrace_file(struct tracecmd_input *handle,
>  static int read_event_file(struct tracecmd_input *handle,
>  			   char *system, unsigned long long size,
>  			   int print, int *sys_printed,
> -			   regex_t *epreg)
> +			   regex_t *epreg, int *parsing_failures)
>  {
>  	struct tep_handle *pevent = handle->pevent;
>  	char *buf;
> @@ -446,8 +448,9 @@ static int read_event_file(struct tracecmd_input *handle,
>  			printf("%.*s\n", (int)size, buf);
>  		}
>  	} else {
> -		if (tep_parse_event(pevent, buf, size, system))
> -			tep_set_parsing_failures(pevent, 1);
> +		if (tep_parse_event(pevent, buf, size, system) &&
> +		    parsing_failures)

Same here.

I've gotten the OK from Linus to ignore that rule for cases like
these :-)

In fact, he told me to try to convince others that we should up it to
100 characters! I haven't tried yet, because I already got push back
from some developers. But perhaps I still might.

> +			(*parsing_failures)++;
>  	}
>  	free(buf);
>  
> @@ -497,7 +500,8 @@ static int make_preg_files(const char *regex, regex_t *system,
>  	return ret;
>  }
>  

[..]

> +/**
> + * tracecmd_read_headers - read the header information from trace.dat
> + * @handle: input handle for the trace.dat file
> + *
> + * This reads the trace.dat file for various information. Like the
> + * format of the ring buffer, event formats, ftrace formats, kallsyms
> + * and printk.
> + */
> +int tracecmd_read_headers(struct tracecmd_input *handle)
> +{
> +	return _tracecmd_read_headers(handle, NULL);
> +}
> +
> +/**
> + * tracecmd_read_headers_failures - read the header information from trace.dat
> + * @handle: input handle for the trace.dat file
> + * @parsing_failures: return number of failures while parsing the event files
> + *
> + * This reads the trace.dat file for various information. Like the
> + * format of the ring buffer, event formats, ftrace formats, kallsyms
> + * and printk.
> + */
> +int tracecmd_read_headers_failures(struct tracecmd_input *handle,
> +				   int *parsing_failures)

Let's not add this. Instead add a "parsing_failures" to the
tracecmd_input handle, and add:

int tracecmd_get_parsing_failures(struct tracecmd_input *handle)
{
	return handle->parsing_failures;
}

> +{
> +	return _tracecmd_read_headers(handle, parsing_failures);
> +}
> +

[..]

> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index 52fa1bd..fe116cc 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -1417,6 +1417,7 @@ void trace_report (int argc, char **argv)
>  	unsigned long long tsoffset = 0;
>  	unsigned long long ts2secs = 0;
>  	unsigned long long ts2sc;
> +	int parsing_failures;
>  	int show_stat = 0;
>  	int show_funcs = 0;
>  	int show_endian = 0;
> @@ -1714,10 +1715,10 @@ void trace_report (int argc, char **argv)
>  			tracecmd_print_events(handle, print_event);
>  			return;
>  		}
> -
> -		ret = tracecmd_read_headers(handle);
> +		parsing_failures = 0;
> +		ret = tracecmd_read_headers_failures(handle, &parsing_failures);

Here we should do:

		ret = tracecmd_read_headers(handle);

>  		if (check_event_parsing) {
> -			if (ret || tep_get_parsing_failures(pevent))

			if (ret || tracecmd_get_parsing_failures(handle))

-- Steve

> +			if (ret || parsing_failures)
>  				exit(EINVAL);
>  			else
>  				exit(0);

