Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A376C71156
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 14:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1145B221FA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 14:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgLBOhb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 09:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgLBOhb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 09:37:31 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D7AA217A0;
        Wed,  2 Dec 2020 14:36:49 +0000 (UTC)
Date:   Wed, 2 Dec 2020 09:36:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, beniaminsandu@gmail.com
Subject: Re: [PATCH] libtracefs: make it build against musl C library
Message-ID: <20201202093647.78d861ec@oasis.local.home>
In-Reply-To: <20201202040802.327203-1-tz.stoyanov@gmail.com>
References: <20201202040802.327203-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Dec 2020 06:08:02 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Beniamin Sandu <beniaminsandu@gmail.com>
> 
> * add some missing headers and macros
> * set pthread affinity using pthread_setaffinity_np after creating the thread
> instead of pthread_attr_setaffinity_np (which seems to not be implemented
> in musl)
> 
> Tested using https://musl.cc/x86_64-linux-musl-native.tgz
> 
> Link: https://lore.kernel.org/linux-trace-devel/20201130122755.31000-1-beniaminsandu@gmail.com
> 
> Reviewed-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>
> [ Fixed a whitespace issue ]
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Tzvetomir,

FYI, when sending patches, even for those you are not the author for,
you are still required to add a Signed-off-by.

Please add that here, and I can pull it into the libtracefs repo.

Thanks!

-- Steve


> ---
>  include/tracefs-local.h | 12 ++++++++++++
>  tracefs-events.c        |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 9cc371b..bdbf89e 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -13,4 +13,16 @@ void warning(const char *fmt, ...);
>  int str_read_file(const char *file, char **buffer);
>  char *trace_append_file(const char *dir, const char *name);
>  
> +#ifndef ACCESSPERMS
> +#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
> +#endif
> +
> +#ifndef ALLPERMS
> +#define ALLPERMS (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO) /* 07777 */
> +#endif
> +
> +#ifndef DEFFILEMODE
> +#define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
> +#endif
> +
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/tracefs-events.c b/tracefs-events.c
> index ca1d22b..ee45988 100644
> --- a/tracefs-events.c
> +++ b/tracefs-events.c
> @@ -13,6 +13,7 @@
>  #include <errno.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> +#include <limits.h>
>  
>  #include <traceevent/kbuffer.h>
>  

