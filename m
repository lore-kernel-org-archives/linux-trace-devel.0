Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD8BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 16:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEB526023C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 16:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243299AbhDLQsh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245270AbhDLQiC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 12:38:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B83660FE8;
        Mon, 12 Apr 2021 16:34:11 +0000 (UTC)
Date:   Mon, 12 Apr 2021 12:34:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] libtracefs: Add more methods for writing to files
Message-ID: <20210412123409.581697ba@gandalf.local.home>
In-Reply-To: <20210412152006.58332-1-y.karadz@gmail.com>
References: <20210412152006.58332-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Apr 2021 18:20:06 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> @@ -364,19 +384,34 @@ static int write_file(const char *file, const char *str)
>  int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				 const char *file, const char *str)
>  {
> -	struct stat st;
> -	char *path;
> -	int ret;
> +	return instance_file_write(instance, file, str, O_WRONLY | O_TRUNC);
> +}
>  
> -	path = tracefs_instance_get_file(instance, file);
> -	if (!path)
> -		return -1;
> -	ret = stat(path, &st);
> -	if (ret == 0)
> -		ret = write_file(path, str);
> -	tracefs_put_tracing_file(path);
> +/**
> + * tracefs_instance_file_write - Append to a trace file of specific instance.

I think you meant "tracefs_instance_file_append - "

> + * @instance: ftrace instance, can be NULL for the top instance
> + * @file: name of the file
> + * @str: nul terminated string, that will be appended to the file.
> + *
> + * Returns the number of appended bytes, or -1 in case of an error.
> + */
> +int tracefs_instance_file_append(struct tracefs_instance *instance,
> +				 const char *file, const char *str)
> +{
> +	return instance_file_write(instance, file, str, O_WRONLY);
> +}
>  
> -	return ret;
> +/**
> + * tracefs_instance_file_write - Clear a trace file of specific instance.

And "tracefs_instance_file_clear - "

> + * @instance: ftrace instance, can be NULL for the top instance
> + * @file: name of the file

 "of the file to clear"

More comments should be in the body.

"Used to clear the file. Note, it only opens with O_TRUNC and closes the
file. If the file has content that does not get cleared in this way, this
will not have any effect. For example, set_ftrace_filter can have probes
that are not cleared by O_TRUNC:

  echo "schedule:stacktrace" > set_ftrace_filter

This function will not clear the above "set_ftrace_filter" after that
command."


> + *
> + * Returns 0 on success, or -1 in case of an error.
> + */
> +int tracefs_instance_file_clear(struct tracefs_instance *instance,
> +				const char *file)
> +{
> +	return instance_file_write(instance, file, NULL, O_WRONLY | O_TRUNC);
>  }
>  
>  /**

Other than that, it looks good.

-- Steve
