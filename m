Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE5EC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 20:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55C52192B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 20:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbfBNUFX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387799AbfBNUFX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 15:05:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2026C218AC;
        Thu, 14 Feb 2019 20:05:22 +0000 (UTC)
Date:   Thu, 14 Feb 2019 15:05:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 04/11] trace-cmd: Add buffer instance flags for
 tracing in guest and agent context
Message-ID: <20190214150520.3c6bb8ac@gandalf.local.home>
In-Reply-To: <20190214141335.28144-5-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
        <20190214141335.28144-5-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Feb 2019 16:13:28 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Add BUFFER_FL_GUEST and BUFFER_FL_AGENT flags to differentiate when
> trace-record.c is being called to trace guest or the VM tracing agent.
> 
> Also disable functions talking to the local tracefs when called in recording
> guest instances context.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  tracecmd/include/trace-local.h |  2 ++
>  tracecmd/trace-record.c        | 55 ++++++++++++++++++++++++++++++++--
>  2 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index a1a06e9..f19c8bb 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -149,6 +149,8 @@ char *strstrip(char *str);
>  enum buffer_instance_flags {
>  	BUFFER_FL_KEEP		= 1 << 0,
>  	BUFFER_FL_PROFILE	= 1 << 1,
> +	BUFFER_FL_GUEST		= 1 << 2,
> +	BUFFER_FL_AGENT		= 1 << 3,
>  };
>  
>  struct func_list {
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 8beefab..107d3d1 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -781,6 +781,9 @@ static void __clear_trace(struct buffer_instance *instance)
>  	FILE *fp;
>  	char *path;
>  
> +	if (instance->flags & BUFFER_FL_GUEST)
> +		return;
> +
>  	/* reset the trace */
>  	path = get_instance_file(instance, "trace");
>  	fp = fopen(path, "w");
> @@ -1264,6 +1267,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
>  	char *path;
>  	char zero = '0';
>  
> +	if (instance->flags & BUFFER_FL_GUEST)
> +		return;
> +
>  	path = get_instance_file(instance, "current_tracer");
>  	fp = fopen(path, "w");
>  	if (!fp) {
> @@ -1360,6 +1366,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
>  	int size;
>  	int ret;
>  
> +	if (instance->flags & BUFFER_FL_GUEST)
> +		return;
> +
>  	path = get_instance_file(instance, "current_tracer");
>  	ret = stat(path, &st);
>  	tracecmd_put_tracing_file(path);


I think we should add a:

#define is_guest(instance) ((instance)->flags & BUFFER_FL_GUEST)

Helper macro here, and all these should be turned into:

	if (is_guest(instance))
		return;

Less error prone, and looks cleaner.

We could add a is_agent() too in later patches.

-- Steve
