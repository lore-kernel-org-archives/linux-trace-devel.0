Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0A0C433C1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363B761A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhCZVWR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 17:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhCZVVr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 17:21:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A1361A28;
        Fri, 26 Mar 2021 21:21:47 +0000 (UTC)
Date:   Fri, 26 Mar 2021 17:21:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 05/23] trace-cmd: Add new local function to check if
 a trace clock is supported
Message-ID: <20210326172145.7a2ae1b3@gandalf.local.home>
In-Reply-To: <20210325064055.539554-6-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
        <20210325064055.539554-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Mar 2021 08:40:37 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new local function is added to check if a given trace clock is
> supported by the ftrace:
>  clock_is_supported()
> This function is used by the other patches from the set.
> The logic should be part of the tracefs library, when a tracefs API is
> implemeneted, this local funciton will be removed.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 635897e1..c7197ba0 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5683,6 +5683,34 @@ check_instance_die(struct buffer_instance *instance, char *param)
>  		    tracefs_instance_get_name(instance->tracefs), param);
>  }
>  
> +static bool clock_is_supported(struct tracefs_instance *instance, const char *clock)
> +{
> +	char *all_clocks = NULL;
> +	char *ret = NULL;
> +
> +	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", NULL);
> +	if (!all_clocks)
> +		return false;
> +
> +	ret = strstr(all_clocks, clock);
> +	if (ret && (ret == all_clocks || ret[-1] == ' ' || ret[-1] == '[')) {
> +		switch (ret[strlen(clock)]) {
> +		case ' ':
> +		case '\0':
> +		case ']':
> +		case '\n':
> +			break;
> +		default:
> +			ret = NULL;
> +		}
> +	} else {
> +		ret = NULL;
> +	}
> +	free(all_clocks);
> +
> +	return ret != NULL;
> +}
> +
>  static void parse_record_options(int argc,
>  				 char **argv,
>  				 enum trace_cmd curr_cmd,

This patch could add the check to the -C as well. I went ahead and did that
with the below patch. It doesn't affect the result of the series, it was
just that this functionality could be a stand alone.

I'll apply this entire series.

Thanks Tzvetomir!

-- Steve


From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Date: Thu, 25 Mar 2021 08:40:37 +0200
Subject: [PATCH] trace-cmd: Add new local function to check if a trace clock
 is supported

A new local function is added to check if a given trace clock is
supported by the ftrace:
 clock_is_supported()
And test that the passed in clock is supported.
The logic should be part of the tracefs library, when a tracefs API is
implemeneted, this local funciton will be removed.

Link: https://lore.kernel.org/linux-trace-devel/20210325064055.539554-6-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
[ Added test to make sure passed in clock is supported ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e9039cd3..c6c14818 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5687,6 +5687,34 @@ check_instance_die(struct buffer_instance *instance, char *param)
 		    tracefs_instance_get_name(instance->tracefs), param);
 }
 
+static bool clock_is_supported(struct tracefs_instance *instance, const char *clock)
+{
+	char *all_clocks = NULL;
+	char *ret = NULL;
+
+	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", NULL);
+	if (!all_clocks)
+		return false;
+
+	ret = strstr(all_clocks, clock);
+	if (ret && (ret == all_clocks || ret[-1] == ' ' || ret[-1] == '[')) {
+		switch (ret[strlen(clock)]) {
+		case ' ':
+		case '\0':
+		case ']':
+		case '\n':
+			break;
+		default:
+			ret = NULL;
+		}
+	} else {
+		ret = NULL;
+	}
+	free(all_clocks);
+
+	return ret != NULL;
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -5882,6 +5910,8 @@ static void parse_record_options(int argc,
 		case 'C':
 			check_instance_die(ctx->instance, "-C");
 			ctx->instance->clock = optarg;
+			if (!clock_is_supported(NULL, ctx->instance->clock))
+				die("Clock %s is not supported", ctx->instance->clock);
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			if (is_top_instance(ctx->instance))
 				guest_sync_set = true;
-- 
2.29.2

