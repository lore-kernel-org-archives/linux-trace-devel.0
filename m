Return-Path: <SRS0=qqQq=XZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26C5C32792
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Sep 2019 21:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E062205C9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Sep 2019 21:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbfI3VKy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbfI3VKy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 17:10:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE849224EC;
        Mon, 30 Sep 2019 18:44:45 +0000 (UTC)
Date:   Mon, 30 Sep 2019 14:44:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Reset CPU mask to its default value with
 "trace-cmd reset".
Message-ID: <20190930144444.4956dff8@gandalf.local.home>
In-Reply-To: <20190925110823.1242-3-tz.stoyanov@gmail.com>
References: <20190925110823.1242-1-tz.stoyanov@gmail.com>
        <20190925110823.1242-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 25 Sep 2019 14:08:23 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> "trace-cmd reset" command should put all ftrace config to its default
> state, but trace cpumask was not reseted. The patch sets cpumask to
> its default value - all CPUs are enabled for tracing.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 69de82a..c41f55f 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4096,6 +4096,24 @@ static void reset_clock(void)
>  		write_instance_file(instance, "trace_clock", "local", "clock");
>  }
>  
> +static void reset_cpu_mask(void)
> +{
> +	char str[24];
> +	int cpumask = 0;
> +	int cpus = count_cpus();
> +	struct buffer_instance *instance;
> +
> +	while (cpus--) {
> +		cpumask <<= 1;
> +		cpumask |= 1;
> +	}

First, you can accomplish the same with:

	(1 << cpus) - 1;

But then this only works if we have less than 32 CPUs.

What we would want is:

	int fullwords;
	char *buf;
	int bits;
	int cpus;
	int len;

	fullwords = cpus / 32;
	bits = cpus % 32;
	len = (fullwords + 1) * 8;

	buf = malloc(len + 1);
	buf[0] = '\0';

	if (bits)
		sprintf(buf, "%x", (1 << bits) - 1);
	while (fullwords-- > 0)
		strcat(buf, "ffffffff");


Because we may run this on machines with 1000s of CPUs!

(BTW, I tested the above under valgrind with the following values:
  1 31 32 33 126 127 128 129 with no memory leaks and the results
  looked good)

-- Steve


> +	if (snprintf(str, 24, "%x", cpumask) <= 0)
> +		return;
> +
> +	for_all_instances(instance)
> +		write_instance_file(instance, "tracing_cpumask", str, "cpumask");
> +}
> +
>  static void reset_event_pid(void)
>  {
>  	add_event_pid("");
> @@ -4808,6 +4826,7 @@ void trace_reset(int argc, char **argv)
>  	reset_clock();
>  	reset_event_pid();
>  	reset_max_latency_instance();
> +	reset_cpu_mask();
>  	tracecmd_remove_instances();
>  	clear_func_filters();
>  	/* restore tracing_on to 1 */

