Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE769C433E1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 17:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87DD961A21
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 17:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbhCXR5p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236683AbhCXR5a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 13:57:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 176F761A1A;
        Wed, 24 Mar 2021 17:57:30 +0000 (UTC)
Date:   Wed, 24 Mar 2021 13:57:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 02/23] trace-cmd: Extend trace-cmd dump subcommand to
 display the clock
Message-ID: <20210324135728.3559392c@gandalf.local.home>
In-Reply-To: <20210324130418.436206-3-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:03:57 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace clock, used to record the tracing data is saved in the trace.dat
> file. As "trace-cmd dump" command shows the metadata content of the
> file, it should display the trace clock also.
> Added a new parameter
>   "trace-cmd dump --clock"
> which shows the clock saved in the file. The clock can be displayed
> also with
>  "trace-cmd dump --all"
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/trace-cmd/trace-cmd-dump.1.txt |  2 ++
>  tracecmd/trace-dump.c                        | 34 +++++++++++++++++++-
>  tracecmd/trace-usage.c                       |  1 +
>  3 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/trace-cmd/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
> index 71b8e655..0f8626fa 100644
> --- a/Documentation/trace-cmd/trace-cmd-dump.1.txt
> +++ b/Documentation/trace-cmd/trace-cmd-dump.1.txt
> @@ -46,6 +46,8 @@ OPTIONS
>      Print all options, stored in the file.
>  *--flyrecord*::
>      Print the offset and the size of tracing data per each CPU.
> +*--clock*::
> +    Print the trace clock, used for timestamp of the tracing events, stored in the file.
>  *--all*::
>      Print all meta data from the file.
>  *--help*::
> diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
> index 6172231e..4bdfd53f 100644
> --- a/tracecmd/trace-dump.c
> +++ b/tracecmd/trace-dump.c
> @@ -24,6 +24,7 @@
>  
>  static struct tep_handle *tep;
>  static unsigned int trace_cpus;
> +static int has_clock;
>  
>  enum dump_items {
>  	SUMMARY		= (1 << 0),
> @@ -37,6 +38,7 @@ enum dump_items {
>  	CMDLINES	= (1 << 8),
>  	OPTIONS		= (1 << 9),
>  	FLYRECORD	= (1 << 10),
> +	CLOCK		= (1 << 11),
>  };
>  
>  enum dump_items verbosity;
> @@ -496,7 +498,7 @@ static void dump_options(int fd)
>  			die("cannot read the option size");
>  
>  		count++;
> -		if (!DUMP_CHECK(OPTIONS)) {
> +		if (!DUMP_CHECK(OPTIONS) && !DUMP_CHECK(CLOCK)) {
>  			lseek64(fd, size, SEEK_CUR);
>  			continue;
>  		}
> @@ -512,6 +514,7 @@ static void dump_options(int fd)
>  			break;
>  		case TRACECMD_OPTION_TRACECLOCK:
>  			dump_option_string(fd, size, "TRACECLOCK");
> +			has_clock = 1;

Shouldn't "trace-cmd dump" also show the clock that's stored in the file,
or will it only show the option?

I'd like to see the file as well, but all I get is:

        [Tracing clock]
                 No tracing clock saved in the file

Which isn't true. It's just not an option.

-- Steve


>  			break;
>  		case TRACECMD_OPTION_UNAME:
>  			dump_option_string(fd, size, "UNAME");
> @@ -556,6 +559,29 @@ static void dump_latency(int fd)
>  	do_print(SUMMARY, "\t[Latency tracing data]\n");
>  }
>  
> +static void dump_clock(int fd)
> +{
> +	long long size;
> +	char *clock;
> +
> +	do_print((SUMMARY | CLOCK), "\t[Tracing clock]\n");
> +	if (!has_clock) {
> +		do_print((SUMMARY | CLOCK), "\t\t No tracing clock saved in the file\n");
> +		return;
> +	}
> +	if (read_file_number(fd, &size, 8))
> +		die("cannot read clock size");
> +	clock = calloc(1, size);
> +	if (!clock)
> +		die("cannot allocate clock %d bytes", size);
> +
> +	if (read_file_bytes(fd, clock, size))
> +		die("cannot read clock %d bytes", size);
> +	clock[size] = 0;
> +	do_print((SUMMARY | CLOCK), "\t\t%s\n", clock);
> +	free(clock);
> +}
> +
>  static void dump_flyrecord(int fd)
>  {
>  	long long cpu_offset;
> @@ -572,6 +598,7 @@ static void dump_flyrecord(int fd)
>  		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
>  			 cpu_offset, cpu_size, i);
>  	}
> +	dump_clock(fd);
>  }
>  
>  static void dump_therest(int fd)
> @@ -626,6 +653,7 @@ static void dump_file(const char *file)
>  }
>  
>  enum {
> +	OPT_clock	= 243,
>  	OPT_all		= 244,
>  	OPT_summary	= 245,
>  	OPT_flyrecord	= 246,
> @@ -666,6 +694,7 @@ void trace_dump(int argc, char **argv)
>  			{"cmd-lines", no_argument, NULL, OPT_cmd_lines},
>  			{"options", no_argument, NULL, OPT_options},
>  			{"flyrecord", no_argument, NULL, OPT_flyrecord},
> +			{"clock", no_argument, NULL, OPT_clock},
>  			{"validate", no_argument, NULL, 'v'},
>  			{"help", no_argument, NULL, '?'},
>  			{NULL, 0, NULL, 0}
> @@ -721,6 +750,9 @@ void trace_dump(int argc, char **argv)
>  		case OPT_head_page:
>  			verbosity |= HEAD_PAGE;
>  			break;
> +		case OPT_clock:
> +			verbosity |= CLOCK;
> +			break;
>  		default:
>  			usage(argv);
>  		}
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 1a7abd58..22537d20 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -377,6 +377,7 @@ static struct usage_help usage_help[] = {
>  		"          --cmd-lines print information mapping a PID to a process name\n"
>  		"          --options print options\n"
>  		"          --flyrecord information of offset and count of recorded events per CPU\n"
> +		"          --clock trace clock, saved in the file\n"
>  		"          -h, --help show usage information\n"
>  	},
>  	{

