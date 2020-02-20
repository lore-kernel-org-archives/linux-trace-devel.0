Return-Path: <SRS0=b+cV=4I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC27C11D00
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 23:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 581FD20801
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 23:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgBTXf7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 18:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgBTXf7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 18:35:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7C820801;
        Thu, 20 Feb 2020 23:35:57 +0000 (UTC)
Date:   Thu, 20 Feb 2020 18:35:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] trace-cmd: Add new libtracefs API
 tracefs_instance_file_append()
Message-ID: <20200220183556.177dfe7b@gandalf.local.home>
In-Reply-To: <20200217173959.385278-2-tz.stoyanov@gmail.com>
References: <20200217173959.385278-1-tz.stoyanov@gmail.com>
        <20200217173959.385278-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Feb 2020 19:39:56 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The existing tracefs_instance_file_write() API truncates the file before writing to it.
> The are use cases where the file must not be truncated. The new
>   tracefs_instance_file_append()
> API appends to the end of the file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs/tracefs.h      |  2 ++
>  lib/tracefs/tracefs-instance.c | 40 ++++++++++++++++++++++++++++++----
>  2 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> index bd3f732..16fcb66 100644
> --- a/include/tracefs/tracefs.h
> +++ b/include/tracefs/tracefs.h
> @@ -30,6 +30,8 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
>  char *tracefs_instance_get_dir(struct tracefs_instance *instance);
>  int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				const char *file, const char *str);
> +int tracefs_instance_file_append(struct tracefs_instance *instance,
> +				 const char *file, const char *str);
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
>  				 char *file, int *psize);
>  
> diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
> index b96ab61..e6b0a95 100644
> --- a/lib/tracefs/tracefs-instance.c
> +++ b/lib/tracefs/tracefs-instance.c
> @@ -176,12 +176,16 @@ char *tracefs_instance_get_name(struct tracefs_instance *instance)
>  	return NULL;
>  }
>  
> -static int write_file(const char *file, const char *str)
> +static int write_file(const char *file, const char *str, bool appned)

Typo, s/appned/append/

>  {
>  	int ret;
>  	int fd;
>  
> -	fd = open(file, O_WRONLY | O_TRUNC);
> +	if (appned)
> +		fd = open(file, O_WRONLY | O_APPEND);
> +	else
> +		fd = open(file, O_WRONLY | O_TRUNC);
> +
>  	if (fd < 0) {
>  		warning("Failed to open '%s'", file);
>  		return -1;
> @@ -198,7 +202,9 @@ static int write_file(const char *file, const char *str)
>   * @file: name of the file
>   * @str: nul terminated string, that will be written in the file.
>   *
> - * Returns the number of written bytes, or -1 in case of an error
> + * Returns the number of written bytes, or -1 in case of an error.
> + * The content of the file is replaced with the new one.
> + *
>   */
>  int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				 const char *file, const char *str)
> @@ -212,7 +218,33 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
>  		return -1;
>  	ret = stat(path, &st);
>  	if (ret == 0)
> -		ret = write_file(path, str);
> +		ret = write_file(path, str, false);
> +	tracefs_put_tracing_file(path);
> +
> +	return ret;
> +}
> +
> +/**
> + * tracefs_instance_file_append - Append to a trace file of specific instance.
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @file: name of the file
> + * @str: nul terminated string, that will be written in the file.
> + *
> + * Returns the number of written bytes, or -1 in case of an error.
> + */
> +int tracefs_instance_file_append(struct tracefs_instance *instance,
> +				 const char *file, const char *str)
> +{
> +	struct stat st;
> +	char *path;
> +	int ret;
> +
> +	path = tracefs_instance_get_file(instance, file);
> +	if (!path)
> +		return -1;
> +	ret = stat(path, &st);
> +	if (ret == 0)
> +		ret = write_file(path, str, true);
>  	tracefs_put_tracing_file(path);
>  
>  	return ret;

I would actually make one more static helper as the above two functions
are identical except for the write file part.

static int instance_file_write(struct tracefs_instance *instance,
			       const char *file, const char *str,
			       bool append)
{
	struct stat st;
	char *path;
	int ret;

	path = tracefs_instance_get_file(instance, file);
	if (!path)
		return -1;
	ret = stat(path, &st);
	if (ret == 0)
		ret = write_file(path, str, append);
	tracefs_put_tracing_file(path);

	return ret;
}

int tracefs_instance_file_write(struct tracefs_instance *instance,
			        const char *file, const char *str)
{
	return instance_file_write(instance, file, str, false);
}

int tracefs_instance_file_append(struct tracefs_instance *instance,
				 const char *file, const char *str)
{
	return instance_file_write(instance, file, str, true);
}

-- Steve
