Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0022DC6FD1D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Mar 2023 22:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjC0WLH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Mar 2023 18:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC0WLG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Mar 2023 18:11:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FC997
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Mar 2023 15:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 717FB6153A
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Mar 2023 22:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C864C4339B;
        Mon, 27 Mar 2023 22:11:04 +0000 (UTC)
Date:   Mon, 27 Mar 2023 18:11:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH trace-cmd] trace-cmd report: Ensure filter is applied to
 single input file
Message-ID: <20230327181103.3da07fa2@gandalf.local.home>
In-Reply-To: <20230317212430.12675-1-krisman@suse.de>
References: <20230317212430.12675-1-krisman@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 17 Mar 2023 18:24:30 -0300
Gabriel Krisman Bertazi <krisman@suse.de> wrote:

> Since 955d05fc7aee ("trace-cmd report: Make filter arguments match their
> files"), the -F filtering is silently ignored when a trace file is
> provided with -i and the filter comes after -i .  The reason is that the
> filter is now associated with input_files and not saved to the global
> list only in this case, but process_filters still only checks the global
> list when handles->input_file is not set.
> 
> Avoid this by checking last_input_file first, which always contains a
> pointer to the correct filter in this case.
> 
> This was only lightly tested, using a single trace file.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217038
> Fixes: 955d05fc7aee ("trace-cmd report: Make filter arguments match their files")
> Signed-off-by: Gabriel krisman Bertazi <krisman@suse.de>
> ---
>  tracecmd/trace-read.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index 52ba818..dbbd124 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -567,11 +567,15 @@ static void process_filters(struct handle_list *handles)
>  	struct tracecmd_filter *trace_filter;
>  	struct filter_str *filter;
>  	int filters = 0;
> +	struct input_files *input_file = handles->input_file;

BTW, please keep the "upside-down x-mas tree" formatting of the above.

ie.

static void process_filters(struct handle_list *handles)
{
        struct input_files *input_file = handles->input_file;
        struct tracecmd_filter *trace_filter;
        struct filter_str *filter;
        int filters = 0;


>  
> -	make_pid_filter(handles->handle, handles->input_file);
> +	if (!input_file)
> +		input_file = last_input_file;
>  
> -	if (handles->input_file)
> -		filter = handles->input_file->filter_str;
> +	make_pid_filter(handles->handle, input_file);
> +
> +	if (input_file)
> +		filter = input_file->filter_str;
>  	else
>  		filter = filter_strings;
>  

So I was playing with this, and I actually needed something else.

If an -F comes before *any* file, I think it should be added to *all* files.

That is:

 -F sched_switch -i trace1.dat -i trace2.dat

Should filter sched_switch for both trace1.dat and trace2.dat.

I actually wanted this just a few minutes ago ;-)

Can you do this, or would you want me to?

-- Steve
