Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83611C433C1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 15:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA57619A9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 15:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhCVPr0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhCVPrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 11:47:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E850F61606;
        Mon, 22 Mar 2021 15:47:22 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:47:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Prefer using const pointer arguments
Message-ID: <20210322114721.118c83ae@gandalf.local.home>
In-Reply-To: <20210322142912.26521-1-y.karadz@gmail.com>
References: <20210322142912.26521-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 16:29:12 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> All functions should receive const pointer arguments, except in the
> cases when the argument object itself needs to be modified.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  include/tracefs.h      | 15 ++++++++-------
>  src/tracefs-instance.c | 17 +++++++++--------
>  2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index f3eec62..e54f791 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -25,12 +25,13 @@ struct tracefs_instance *tracefs_instance_create(const char *name);
>  struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
>  						const char *name);
>  int tracefs_instance_destroy(struct tracefs_instance *instance);
> -bool tracefs_instance_is_new(struct tracefs_instance *instance);
> -const char *tracefs_instance_get_name(struct tracefs_instance *instance);
> -const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);
> +bool tracefs_instance_is_new(const struct tracefs_instance *instance);
> +const char *tracefs_instance_get_name(const struct tracefs_instance *instance);
> +const char *tracefs_instance_get_trace_dir(const struct tracefs_instance *instance);
>  char *
> -tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
> -char *tracefs_instance_get_dir(struct tracefs_instance *instance);
> +tracefs_instance_get_file(const struct tracefs_instance *instance,
> +			  const char *file);
> +char *tracefs_instance_get_dir(const struct tracefs_instance *instance);
>  int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				const char *file, const char *str);
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
> @@ -42,8 +43,8 @@ int tracefs_instance_file_open(struct tracefs_instance *instance,
>  int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
>  
>  bool tracefs_instance_exists(const char *name);
> -bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
> -bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
> +bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
> +bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name);
>  
>  int tracefs_trace_is_on(struct tracefs_instance *instance);
>  int tracefs_trace_on(struct tracefs_instance *instance);
> 

My fear about doing the above is that when dealing with complex structures
like tracefs_instance, which is opaque (private) to the caller that it now
prevents us from ever modifying the instance in one of those APIs. It may
not modify it now, but that does not mean it wont be modified in the
future. We could add ref counters, or something else.

What's the reason to make them constant? The caller does not have access to
the internals of what those are pointing to. It's just an abstract object.
Why would they care if its const or not?

-- Steve
