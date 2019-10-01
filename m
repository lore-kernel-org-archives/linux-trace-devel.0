Return-Path: <SRS0=sUNk=X2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC61ECE587
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 15:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5011021855
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 15:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfJAPce (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 11:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfJAPce (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 11:32:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A264820842;
        Tue,  1 Oct 2019 15:32:33 +0000 (UTC)
Date:   Tue, 1 Oct 2019 11:32:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Reset CPU mask to its default value
 with "trace-cmd reset".
Message-ID: <20191001113232.644fa2f0@gandalf.local.home>
In-Reply-To: <20191001145740.8866-3-tz.stoyanov@gmail.com>
References: <20191001145740.8866-1-tz.stoyanov@gmail.com>
        <20191001145740.8866-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  1 Oct 2019 17:57:40 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> "trace-cmd reset" command should put all ftrace config to its default
> state, but trace cpumask was not reseted. The patch sets cpumask to
> its default value - all CPUs are enabled for tracing.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 69de82a..6f3520c 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4096,6 +4096,40 @@ static void reset_clock(void)
>  		write_instance_file(instance, "trace_clock", "local", "clock");
>  }
>  
> +static void reset_cpu_mask(void)
> +{
> +	struct buffer_instance *instance;
> +	int cpus = count_cpus();
> +	int fullwords;
> +	char *buf;
> +	int bits;
> +	int len;
> +
> +	fullwords = cpus / 32;
> +	bits = cpus % 32;
> +	len = (fullwords + 1) * 9;
> +
> +	buf = malloc(len + 1);
> +	if (!buf) {
> +		warning("Unable to allocate %d bytes for cpu mask", len + 1);
> +		return;
> +	}
> +	buf[0] = '\0';
> +	if (bits) {
> +		sprintf(buf, "%x", (1 << bits) - 1);
> +	} else if (fullwords) {
> +		strcat(buf, "ffffffff");
> +		fullwords--;
> +	}
> +	while (fullwords-- > 0)
> +		strcat(buf, ",ffffffff");

I like my way because it's a little more condensed ;-)

But this works too and it's far from a fast path. As it's probably
more readable, I'll all this one.

-- Steve


> +
> +	for_all_instances(instance)
> +		write_instance_file(instance, "tracing_cpumask", buf, "cpumask");
> +
> +	free(buf);
> +}
> +
>  static void reset_event_pid(void)
>  {
>  	add_event_pid("");
> @@ -4808,6 +4842,7 @@ void trace_reset(int argc, char **argv)
>  	reset_clock();
>  	reset_event_pid();
>  	reset_max_latency_instance();
> +	reset_cpu_mask();
>  	tracecmd_remove_instances();
>  	clear_func_filters();
>  	/* restore tracing_on to 1 */

