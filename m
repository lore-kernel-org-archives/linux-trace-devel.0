Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA91AC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 19:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01D520652
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 19:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfCETGL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfCETGL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 14:06:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A57205F4;
        Tue,  5 Mar 2019 19:06:10 +0000 (UTC)
Date:   Tue, 5 Mar 2019 14:06:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] fix "trace-cmd reset" command to restore the
 default value of tracing_max_latency
Message-ID: <20190305140609.3000ed5a@gandalf.local.home>
In-Reply-To: <20181213142125.12149-6-tstoyanov@vmware.com>
References: <20181213142125.12149-1-tstoyanov@vmware.com>
        <20181213142125.12149-6-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 13 Dec 2018 14:21:44 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> The "trace-cmd reset" command should restore ftrace to its default state.
> This patch sets "tracing/tracing_max_latency" to 0,
> when the "trace-cmd reset" command is executed.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tracecmd/trace-record.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index f77e49a..a9bcd8d 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3769,6 +3769,14 @@ static void reset_event_pid(void)
>  		write_instance_file(instance, "set_event_pid", "", "event_pid");
>  }
>  
> +static void reset_max_latency_instance(void)
> +{
> +	struct buffer_instance *instance;
> +
> +	for_all_instances(instance)
> +		write_instance_file(instance,
> +				    "tracing_max_latency", "0", "max_latency");
> +}

We should fix reset_max_latency() use write_instance_file, and then
make a reset_max_latency_instance() to call it on all instance.

-- Steve

>  
>  static void clear_triggers(void)
>  {
> @@ -4474,6 +4482,7 @@ void trace_reset(int argc, char **argv)
>  	/* set clock to "local" */
>  	reset_clock();
>  	reset_event_pid();
> +	reset_max_latency_instance();
>  	tracecmd_remove_instances();
>  	clear_func_filters();
>  	/* restore tracing_on to 1 */

