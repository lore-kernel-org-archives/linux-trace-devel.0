Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F00C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhKXRXM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229509AbhKXRXL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:23:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 852DF60F5B;
        Wed, 24 Nov 2021 17:20:01 +0000 (UTC)
Date:   Wed, 24 Nov 2021 12:19:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] trace-cmd: Use the new trace buffers API
Message-ID: <20211124121959.373e0e90@gandalf.local.home>
In-Reply-To: <20211111150805.86419-3-tz.stoyanov@gmail.com>
References: <20211111150805.86419-1-tz.stoyanov@gmail.com>
        <20211111150805.86419-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:08:03 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4169,7 +4169,6 @@ static void touch_file(const char *file)
>  }
>  
>  static void append_buffer(struct tracecmd_output *handle,
> -			  struct tracecmd_option *buffer_option,
>  			  struct buffer_instance *instance,
>  			  char **temp_files)
>  {
> @@ -4197,7 +4196,7 @@ static void append_buffer(struct tracecmd_output *handle,
>  			touch_file(temp_files[i]);
>  	}
>  
> -	tracecmd_append_buffer_cpu_data(handle, buffer_option,
> +	tracecmd_append_buffer_cpu_data(handle, NULL,
>  					cpu_count, temp_files);
>  
>  	for (i = 0; i < instance->cpu_count; i++) {

Where we have:

int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
				    struct tracecmd_option *option,
				    int cpus, char * const *cpu_data_files)
{
	tsize_t offset;
	stsize_t ret;

	offset = lseek64(handle->fd, 0, SEEK_CUR);

	/* Go to the option data, where will write the offest */
	ret = lseek64(handle->fd, option->offset, SEEK_SET);


Now we dereference a NULL pointer because option is NULL here.

I know that this gets fixed in later patches, but we should not have a
known null pointer dereference in git history.

-- Steve
