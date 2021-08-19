Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343ECC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D6460F39
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhHST1c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhHST1b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:27:31 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E511860F39;
        Thu, 19 Aug 2021 19:26:54 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:26:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 83/87] trace-cmd report: Add new parameters for
 version 7 trace files
Message-ID: <20210819152648.2331a544@oasis.local.home>
In-Reply-To: <20210729050959.12263-84-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-84-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:55 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> By default, "trace-cmd report" writes in trace file version 7 and no
> trace file compression. A new parameters are added, which can be used to
> set desired verrsion and compression of the output trace file.
>  "trace-cmd report --file-version <version> --compression <compression>"
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 28 ++++++++++++++++++++++++++++
>  tracecmd/trace-usage.c  |  7 ++++++-
>  2 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index ddab7798..7013aee3 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5810,6 +5810,8 @@ void init_top_instance(void)
>  }
>  
>  enum {
> +	OPT_file_ver		= 237,
> +	OPT_comporession	= 238,

Fix spelling for all uses.

-- Steve

>  	OPT_verbose		= 239,
>  	OPT_tsc2nsec		= 240,
>  	OPT_fork		= 241,
> @@ -6249,6 +6251,8 @@ static void parse_record_options(int argc,
>  			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
>  			{"poll", no_argument, NULL, OPT_poll},
>  			{"verbose", optional_argument, NULL, OPT_verbose},
> +			{"compression", required_argument, NULL, OPT_comporession},
> +			{"file-version", required_argument, NULL, OPT_file_ver},
>  			{NULL, 0, NULL, 0}
>  		};
>  
> @@ -6674,6 +6678,30 @@ static void parse_record_options(int argc,
>  			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
>  			recorder_flags |= TRACECMD_RECORD_POLL;
>  			break;
> +		case OPT_comporession:
> +			cmd_check_die(ctx, CMD_start, *(argv+1), "--compression");
> +			cmd_check_die(ctx, CMD_set, *(argv+1), "--compression");
> +			cmd_check_die(ctx, CMD_extract, *(argv+1), "--compression");
> +			cmd_check_die(ctx, CMD_stream, *(argv+1), "--compression");
> +			cmd_check_die(ctx, CMD_profile, *(argv+1), "--compression");
> +			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&
> +			    !tracecmd_compress_is_supported(optarg, NULL))
> +				die("Compression algorithm  %s is not supported", optarg);
> +			ctx->compression = strdup(optarg);
> +			break;
> +		case OPT_file_ver:
> +			cmd_check_die(ctx, CMD_start, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_set, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_extract, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_stream, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_profile, *(argv+1), "--file_version");
> +			ctx->file_version = atoi(optarg);
> +			if (ctx->file_version < FILE_VERSION_MIN ||
> +			    ctx->file_version > FILE_VERSION_MAX)
> +				die("Unsupported file version %d, "
> +				    "supported versions are from %d to %d",
> +				    ctx->file_version, FILE_VERSION_MIN, FILE_VERSION_MAX);
> +			break;
>  		case OPT_quiet:
>  		case 'q':
>  			quiet = true;
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 9eb13ecb..ec0af46f 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -69,7 +69,12 @@ static struct usage_help usage_help[] = {
>  		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
>  		"                                                         at the beginnig and at the end of the trace\n"
>  		"          --poll don't block while reading from the trace buffer\n"
> -		"          --verbose 'level' Set the desired log level\n"
> +		"          --file-version set the desired trace file version\n"
> +		"          --compression compress the trace output file, one of these strings can be passed:\n"
> +		"                            any  - auto select the best available compression algorithm\n"
> +		"                            none - do not compress the trace file\n"
> +		"                            name - the name of the desired compression algorithms\n"
> +		"                        available algorithms can be listed with trace-cmd list -c\n"
>  	},
>  	{
>  		"set",

