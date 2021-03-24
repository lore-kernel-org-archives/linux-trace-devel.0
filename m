Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F5AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 17:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1BAC61A1D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 17:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhCXRuL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhCXRuA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 13:50:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B05361A15;
        Wed, 24 Mar 2021 17:49:59 +0000 (UTC)
Date:   Wed, 24 Mar 2021 13:49:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 05/23] trace-cmd: Add new local function to check if
 a trace clock is supported
Message-ID: <20210324134958.68c77b49@gandalf.local.home>
In-Reply-To: <20210324130418.436206-6-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 15:04:00 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 635897e1..5f7f5b3d 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5683,6 +5683,33 @@ check_instance_die(struct buffer_instance *instance, char *param)
>  		    tracefs_instance_get_name(instance->tracefs), param);
>  }
>  
> +static bool clock_is_supported(struct tracefs_instance *instance, char *clock)
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

Testing this, I found we also need:

		case '\n':

-- Steve

> +		case ']':
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
> -- 
