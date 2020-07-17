Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02749C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 13:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D34322064B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 13:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgGQNZK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 09:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgGQNZK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 09:25:10 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2042064B;
        Fri, 17 Jul 2020 13:25:09 +0000 (UTC)
Date:   Fri, 17 Jul 2020 09:25:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Add new tracefs API
 tracefs_instances_walk()
Message-ID: <20200717092507.3a81a812@oasis.local.home>
In-Reply-To: <20200717080326.82151-2-tz.stoyanov@gmail.com>
References: <20200717080326.82151-1-tz.stoyanov@gmail.com>
        <20200717080326.82151-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 17 Jul 2020 11:03:25 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The logic for finding all configured ftrace instances is encapuslated in
> the new tracefs_instances_walk() API. A user specified callback is
> called for each ftrace instance in the system, excpet for the top level
> one.
> The implementation of "trace-cmd stat" is modified to use the new API.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs/tracefs.h           |  1 +
>  lib/tracefs/include/tracefs-local.h |  1 +
>  lib/tracefs/tracefs-events.c        | 14 ++++----
>  lib/tracefs/tracefs-instance.c      | 52 +++++++++++++++++++++++++++++
>  tracecmd/trace-stat.c               | 52 ++++++++---------------------
>  5 files changed, 74 insertions(+), 46 deletions(-)
> 
> diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> index 8ee7ba6e..0dd8046f 100644
> --- a/include/tracefs/tracefs.h
> +++ b/include/tracefs/tracefs.h
> @@ -32,6 +32,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				const char *file, const char *str);
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
>  				 char *file, int *psize);
> +int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);

Perhaps a better name would be: tracefs_instance_iterate()?

I usually consider a "walk" as going through a tree, not a list. If
this was a directory tree, then "walk" would be more appropriate.

An "iterator" is something that walks through a list and triggers a
callback, like this does.

But other than that, the patch looks good.

-- Steve


>  
>  bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
>  bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
> diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
> index fe327a0f..08b67fa9 100644
> --- a/lib/tracefs/include/tracefs-local.h
> 
