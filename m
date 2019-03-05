Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AC5C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 19:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3397120652
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 19:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfCETEB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfCETEB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 14:04:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3479205F4;
        Tue,  5 Mar 2019 19:04:00 +0000 (UTC)
Date:   Tue, 5 Mar 2019 14:03:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 4/5] fix "trace-cmd reset" command to restore the
 default value of set_event_pid
Message-ID: <20190305140358.01b1e0e6@gandalf.local.home>
In-Reply-To: <20181213142125.12149-5-tstoyanov@vmware.com>
References: <20181213142125.12149-1-tstoyanov@vmware.com>
        <20181213142125.12149-5-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I took the first 3 patches, but fixed the subject to say:

	trace-cmd: Fix ....

As all commits should have a "system:" format and the description part
start with a capital letter (note, this is the requirement for the
Linux kernel as well).

On Thu, 13 Dec 2018 14:21:43 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> The "trace-cmd reset" command should restore ftrace to its default state.
> This patch sets "tracing/set_event_pid" to an empty string,
> when the "trace-cmd reset" command is executed.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tracecmd/trace-record.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 38d9871..f77e49a 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3761,6 +3761,15 @@ static void reset_clock(void)
>  		write_instance_file(instance, "trace_clock", "local", "clock");
>  }
>  
> +static void reset_event_pid(void)
> +{
> +	struct buffer_instance *instance;
> +
> +	for_all_instances(instance)
> +		write_instance_file(instance, "set_event_pid", "", "event_pid");
> +}

Hmm, we should utilize "add_event_pid()" here instead, and simply pass
in an empty line.

Before doing that, make a clean up patch that makes add_event_pid()
utilize write_instance_file() instead of open coding it.

Thanks Tzvetomir!

-- Steve

> +
> +
>  static void clear_triggers(void)
>  {
>  	struct buffer_instance *instance;
> @@ -4464,6 +4473,7 @@ void trace_reset(int argc, char **argv)
>  	clear_triggers();
>  	/* set clock to "local" */
>  	reset_clock();
> +	reset_event_pid();
>  	tracecmd_remove_instances();
>  	clear_func_filters();
>  	/* restore tracing_on to 1 */

