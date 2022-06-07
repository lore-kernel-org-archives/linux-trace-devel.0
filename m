Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEBFC43334
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 16:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbiFGQ3N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiFGQ3M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 12:29:12 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5348F7522D
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=v7HbeFTrx+qiZ34Itc8asWwvU9Z5Xv9s9rTTA/8+3OE=;
  b=FBgH38hpCjuHHa7DOVlNNFZl6kD1LPFoj20jkW3QmlFfoMzJerS8T0M8
   83htWTx5Og0ZQgaP4BpDtqIo464PHnYbhUCVV8IKkd4CgGITLzfmDjhzS
   l3n8SqZNuufPe/nB+s5S0pIUbsG9acsBds3i0kxxHD//kpwW5S+Loun1G
   w=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,284,1647298800"; 
   d="scan'208";a="39880297"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:29:08 +0200
Date:   Tue, 7 Jun 2022 18:29:07 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: julia@hadrien
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd report: Add --first-event and --last-event
 options
In-Reply-To: <20220607122242.51bf5aa2@gandalf.local.home>
Message-ID: <alpine.DEB.2.22.394.2206071828590.11966@hadrien>
References: <20220607122242.51bf5aa2@gandalf.local.home>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Tue, 7 Jun 2022, Steven Rostedt wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Add the options to trace-cmd report to show the timestamp of the first and
> last events.
>
> This also fixes a memory leak when --cpus is used, but was not a major
> issue as the code exited immediately afterward.

Thanks!

>
> Suggested-by: Julia Lawall <julia.lawall@inria.fr>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216068
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  .../trace-cmd/trace-cmd-report.1.txt          |  6 ++
>  tracecmd/trace-read.c                         | 56 +++++++++++++++++--
>  tracecmd/trace-usage.c                        |  2 +
>  3 files changed, 58 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
> index ccf635fb664b..d517a4a6c766 100644
> --- a/Documentation/trace-cmd/trace-cmd-report.1.txt
> +++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
> @@ -285,6 +285,12 @@ OPTIONS
>  *--cpus*::
>      List the CPUs that have data in the trace file then exit.
>
> +*--first-event*::
> +    Show the timestamp of the first event of all CPUs that have data.
> +
> +*--last-event*::
> +    Show the timestamp of the last event of all CPUs that have data.
> +
>  *--stat*::
>      If the trace.dat file recorded the final stats (outputed at the end of record)
>      the *--stat* option can be used to retrieve them.
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index df559d2af47e..691450b05a39 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -157,7 +157,8 @@ static void print_event_name(struct trace_seq *s, struct tep_event *event)
>
>  enum time_fmt {
>  	TIME_FMT_LAT		= 1,
> -	TIME_FMT_NORMAL		= 2,
> +	TIME_FMT_NORMAL,
> +	TIME_FMT_TS,
>  };
>
>  static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
> @@ -172,11 +173,11 @@ static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
>  	default:
>  		if (tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS) {
>  			if (tep_test_flag(tep, TEP_NSEC_OUTPUT))
> -				return " %9.1d:";
> +				return tf == TIME_FMT_NORMAL ? " %9.1d:" : "%9.1d";
>  			else
> -				return " %6.1000d:";
> +				return tf == TIME_FMT_NORMAL ? " %6.1000d:" : "%6.1000d";
>  		} else
> -			return "%12d:";
> +			return tf == TIME_FMT_NORMAL ? "%12d:" : "%12d";
>  	}
>  }
>
> @@ -1507,6 +1508,19 @@ static void set_event_flags(struct tep_handle *pevent, struct event_str *list,
>  	}
>  }
>
> +static void show_event_ts(struct tracecmd_input *handle,
> +			  struct tep_record *record)
> +{
> +	const char *tfmt = time_format(handle, TIME_FMT_TS);
> +	struct tep_handle *tep = tracecmd_get_tep(handle);
> +	struct trace_seq s;
> +
> +	trace_seq_init(&s);
> +	tep_print_event(tep, &s, record, tfmt, TEP_PRINT_TIME);
> +	printf("%s", s.buffer);
> +	trace_seq_destroy(&s);
> +}
> +
>  static void add_hook(const char *arg)
>  {
>  	struct hook_list *hook;
> @@ -1543,6 +1557,8 @@ enum {
>  	OPT_events	= 254,
>  	OPT_cpu		= 255,
>  	OPT_cpus	= 256,
> +	OPT_first	= 257,
> +	OPT_last	= 258,
>  };
>
>  void trace_report (int argc, char **argv)
> @@ -1571,6 +1587,8 @@ void trace_report (int argc, char **argv)
>  	int show_version = 0;
>  	int show_events = 0;
>  	int show_cpus = 0;
> +	int show_first = 0;
> +	int show_last = 0;
>  	int print_events = 0;
>  	int nanosec = 0;
>  	int no_date = 0;
> @@ -1601,6 +1619,7 @@ void trace_report (int argc, char **argv)
>  			{"events", no_argument, NULL, OPT_events},
>  			{"event", required_argument, NULL, OPT_event},
>  			{"filter-test", no_argument, NULL, 'T'},
> +			{"first-event", no_argument, NULL, OPT_first},
>  			{"kallsyms", required_argument, NULL, OPT_kallsyms},
>  			{"pid", required_argument, NULL, OPT_pid},
>  			{"comm", required_argument, NULL, OPT_comm},
> @@ -1610,6 +1629,7 @@ void trace_report (int argc, char **argv)
>  			{"stat", no_argument, NULL, OPT_stat},
>  			{"boundary", no_argument, NULL, OPT_boundary},
>  			{"debug", no_argument, NULL, OPT_debug},
> +			{"last-event", no_argument, NULL, OPT_last},
>  			{"profile", no_argument, NULL, OPT_profile},
>  			{"uname", no_argument, NULL, OPT_uname},
>  			{"version", no_argument, NULL, OPT_version},
> @@ -1754,6 +1774,14 @@ void trace_report (int argc, char **argv)
>  		case OPT_stat:
>  			show_stat = 1;
>  			break;
> +		case OPT_first:
> +			show_first = 1;
> +			show_cpus = 1;
> +			break;
> +		case OPT_last:
> +			show_last = 1;
> +			show_cpus = 1;
> +			break;
>  		case OPT_boundary:
>  			/* Debug to look at buffer breaks */
>  			buffer_breaks = 1;
> @@ -1923,6 +1951,7 @@ void trace_report (int argc, char **argv)
>  		}
>
>  		if (show_cpus) {
> +			struct tep_record *record;
>  			int cpus;
>  			int ret;
>  			int i;
> @@ -1935,8 +1964,23 @@ void trace_report (int argc, char **argv)
>  			cpus = tracecmd_cpus(handle);
>  			printf("List of CPUs in %s with data:\n", inputs->file);
>  			for (i = 0; i < cpus; i++) {
> -				if (tracecmd_read_cpu_first(handle, i))
> -					printf("  %d\n", i);
> +				if ((record = tracecmd_read_cpu_first(handle, i))) {
> +					printf("  %d", i);
> +					if (show_first) {
> +						printf("\tFirst event:");
> +						show_event_ts(handle, record);
> +					}
> +					if (show_last) {
> +						tracecmd_free_record(record);
> +						record = tracecmd_read_cpu_last(handle, i);
> +						if (record) {
> +							printf("\tLast event:");
> +							show_event_ts(handle, record);
> +						}
> +					}
> +					tracecmd_free_record(record);
> +					printf("\n");
> +				}
>  			}
>  			continue;
>  		}
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 2cfa64f5aa0c..abf6c3ac5990 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -230,6 +230,8 @@ static struct usage_help usage_help[] = {
>  		"          --cpu <cpu1,cpu2,...> - filter events according to the given cpu list.\n"
>  		"                                  A range of CPUs can be specified using 'cpuX-cpuY' notation.\n"
>  		"          --cpus - List the CPUs that have content in it then exit.\n"
> +		"          --first-event - Show the timestamp of the first event for all CPUs.\n"
> +		"          --last-event - Show the timestamp of the last event for all CPUs.\n"
>  		"          --check-events return whether all event formats can be parsed\n"
>  		"          --stat - show the buffer stats that were reported at the end of the record.\n"
>  		"          --uname - show uname of the record, if it was saved\n"
> --
> 2.35.1
>
>
