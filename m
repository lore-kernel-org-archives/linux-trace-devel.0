Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5CCC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BB586143A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhD2Nnp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhD2Nnp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 09:43:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B95346143B;
        Thu, 29 Apr 2021 13:42:58 +0000 (UTC)
Date:   Thu, 29 Apr 2021 09:42:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] trace-cmd library: Select the file version when
 writing trace file
Message-ID: <20210429094257.4cf3e7f2@gandalf.local.home>
In-Reply-To: <20210429040119.843617-6-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
        <20210429040119.843617-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Apr 2021 07:01:17 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> index 9231c319..f36718f1 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -57,6 +57,7 @@ struct tracecmd_output {
>  	int			nr_options;
>  	bool			quiet;
>  	unsigned long		file_state;
> +	unsigned long		file_version;
>  	struct list_head	options;
>  	struct tracecmd_msg_handle *msg_handle;
>  	char			*trace_clock;
> @@ -907,6 +908,17 @@ out_free:
>  	return ret;
>  }
>  
> +static int select_file_version(struct tracecmd_output *handle,
> +				struct tracecmd_input *ihandle)
> +{
> +	if (ihandle)
> +		handle->file_version = tracecmd_get_file_version(ihandle);
> +	else
> +		handle->file_version = FILE_VERSION;
> +
> +	return 0;
> +}
> +

This is where we should have the logic for what we write.

We save a string where the version is going to be located. We default it to
the lowest level (6), and then if a feature is recorded that is of a higher
version, we up it, and change the number of disk as well.

If there's a case where we get to two digit strings, we should have it be:

  "6 \0"

which should still work. Then if we use a feature that requires version 10,
it would be updated to:

  "10\0"

We can do this at the end of recording.

-- Steve
