Return-Path: <SRS0=Uklz=4M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208D5C38BE2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Feb 2020 20:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1F5F21927
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Feb 2020 20:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXUoN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727249AbgBXUoN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 15:44:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3A221927;
        Mon, 24 Feb 2020 20:44:12 +0000 (UTC)
Date:   Mon, 24 Feb 2020 15:44:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Clear error log on reset subcommand
Message-ID: <20200224154411.3b8e63c9@gandalf.local.home>
In-Reply-To: <20200219131410.447103-1-tz.stoyanov@gmail.com>
References: <20200219131410.447103-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Feb 2020 15:14:10 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The "trace-cmd reset" command is supposed to set the ftrace state to default.
> However, the ftrace error logs are not reseted.
> A logic is added to delete the content of "error_log" file when "trace-cmd reset" is executed.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index b6a412e..3e0d066 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4638,6 +4638,25 @@ static void clear_triggers(void)
>  		clear_instance_triggers(instance);
>  }
>  
> +static void clear_instance_error_log(struct buffer_instance *instance)
> +{
> +	char *file;
> +
> +	file = tracefs_instance_get_file(instance->tracefs, "error_log");
> +	if (!file)
> +		return;
> +	write_file(file, " ");
> +	tracefs_put_tracing_file(file);
> +}

The error_log file is not guaranteed to exist. Please add a check for
existence via stat() (hmm, perhaps we should make a file_exists() helper
function). Otherwise I get this:

# trace-cmd reset
trace-cmd: No such file or directory
  opening to '/debug/tracing/error_log'


> +
> +static void clear_error_log(void)
> +{
> +	struct buffer_instance *instance;
> +
> +	for_all_instances(instance)
> +		clear_instance_error_log(instance);
> +}
> +
>  static void clear_all_synth_events(void)
>  {
>  	char sevent[BUFSIZ];
> @@ -5382,6 +5401,7 @@ void trace_reset(int argc, char **argv)
>  	clear_filters();
>  	clear_triggers();
>  	clear_all_synth_events();
> +	clear_error_log();
>  	/* set clock to "local" */
>  	reset_clock();
>  	reset_event_pid();

