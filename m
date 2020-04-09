Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CDAC2BA19
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 18:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C549520757
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 18:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgDISWR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 14:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDISWR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 14:22:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7594F20753;
        Thu,  9 Apr 2020 18:22:17 +0000 (UTC)
Date:   Thu, 9 Apr 2020 14:22:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] trace-cmd: Add new tracefs APIs for checking if
 a ftrace file / directory exists
Message-ID: <20200409142215.29607d07@gandalf.local.home>
In-Reply-To: <20200225180733.89344-2-tz.stoyanov@gmail.com>
References: <20200225180733.89344-1-tz.stoyanov@gmail.com>
        <20200225180733.89344-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 25 Feb 2020 20:07:30 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some ftrace files and directories are optional, depending on specific kernel configuration or version.
> It is a good practice to check if the file / directory exist, before trying to access it. There are a lot of places in trace-cmd implementation with such checks.
> The new libtracefs APIs can be used for this, they are ftarce instance aware:
>  bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
>  bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs/tracefs.h      |  3 +++
>  lib/tracefs/tracefs-instance.c | 49 +++++++++++++++++++++++++++++++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> index 85690b66..bc8bebcb 100644
> --- a/include/tracefs/tracefs.h
> +++ b/include/tracefs/tracefs.h
> @@ -33,6 +33,9 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
>  				 char *file, int *psize);
>  
> +bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
> +bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);
> +
>  /* events */
>  void tracefs_list_free(char **list);
>  char **tracefs_event_systems(const char *tracing_dir);
> diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
> index b96ab61c..67123e7c 100644
> --- a/lib/tracefs/tracefs-instance.c
> +++ b/lib/tracefs/tracefs-instance.c
> @@ -13,7 +13,7 @@
>  #include <errno.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> -
> +#include <linux/limits.h>
>  #include "tracefs.h"
>  #include "tracefs-local.h"
>  
> @@ -247,3 +247,50 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
>  
>  	return buf;
>  }
> +
> +static bool check_file_exist(struct tracefs_instance *instance,
> +			     char *name, bool dir)
> +{
> +	char file[PATH_MAX];
> +	struct stat st;
> +	char *path;
> +	int ret;
> +
> +	path = tracefs_instance_get_dir(instance);
> +	snprintf(file, PATH_MAX, "%s/%s", path, name);
> +	tracefs_put_tracing_file(path);
> +	ret = stat(file, &st);
> +	if (ret < 0)
> +		return false;
> +
> +	if (dir && !S_ISDIR(st.st_mode))
> +		return false;
> +	if (!dir && S_ISDIR(st.st_mode))
> +		return false;
> +
> +	return true;

BTW, the above can be converted to just:

	return !dir == !S_ISDIR(st.st_mode);


> +}
> +
> +/**
> + * tracefs_file_exist - Check if a file with given name exists in given instance
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @name: name of the file
> + *
> + * Returns true if the file exists, false otherwise

Probably should comment that this will return false if the "file" exists
but is a directory.

Is there any reason we would not want to return true here if it was a
directory? A directory is just another kind of "file" (in the Unix world).

-- Steve

> + */
> +bool tracefs_file_exist(struct tracefs_instance *instance, char *name)
> +{
> +	return check_file_exist(instance, name, false);
> +}
> +
> +/**
> + * tracefs_dir_exist - Check if a directory with given name exists in given instance
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @name: name of the directory
> + *
> + * Returns true if the directory exists, false otherwise
> + */
> +bool tracefs_dir_exist(struct tracefs_instance *instance, char *name)
> +{
> +	return check_file_exist(instance, name, true);
> +}

