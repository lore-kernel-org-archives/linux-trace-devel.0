Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC47C41513
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 15:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjHBPJu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbjHBPJk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 11:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C0B3588;
        Wed,  2 Aug 2023 08:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9832E619E9;
        Wed,  2 Aug 2023 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62899C433C9;
        Wed,  2 Aug 2023 15:09:00 +0000 (UTC)
Date:   Wed, 2 Aug 2023 11:08:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ze Gao <zegao2021@gmail.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [RFC PATCH v4 7/7] libtraceevent: prefer to use prev_state_char
 introduced in sched_switch
Message-ID: <20230802110858.723d0fa1@gandalf.local.home>
In-Reply-To: <20230802121116.324604-8-zegao@tencent.com>
References: <20230802121116.324604-1-zegao@tencent.com>
        <20230802121116.324604-8-zegao@tencent.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Aug 2023 08:10:02 -0400
Ze Gao <zegao2021@gmail.com> wrote:

> Since the sched_switch tracepoint introduces a new variable to
> report sched-out task state in symbolic char, we prefer to use
> it to spare from knowing internal implementations in kernel.
> 
> Also we keep the old parsing logic intact but sync the state char
> array with the latest kernel.
> 

This should also go to linux-trace-devel@vger.kernel.org.

> Signed-off-by: Ze Gao <zegao@tencent.com>
> ---
>  plugins/plugin_sched_switch.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
> index e0986ac..4c57322 100644
> --- a/plugins/plugin_sched_switch.c
> +++ b/plugins/plugin_sched_switch.c
> @@ -11,7 +11,7 @@
>  
>  static void write_state(struct trace_seq *s, int val)
>  {
> -	const char states[] = "SDTtXZPI";
> +	const char states[] = "SDTtXZPIp";
>  	int found = 0;
>  	int i;
>  
> @@ -99,7 +99,12 @@ static int sched_switch_handler(struct trace_seq *s,
>  	if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) == 0)
>  		trace_seq_printf(s, "[%d] ", (int) val);
>  
> -	if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
> +	//find if has prev_state_char, otherwise fallback to prev_state

Use standard C comment notation "/* ... */"

> +	if (tep_find_field(event, "prev_state_char")) {
> +		if (tep_get_field_val(s,  event, "prev_state_char", record, &val, 1) == 0)
> +			trace_seq_putc(s, (char) val);
> +	}
> +	else if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)

This should be:

	} else if (..) {

>  		write_state(s, val);

	}

-- Steve

>  
>  	trace_seq_puts(s, " ==> ");

