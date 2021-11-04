Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621B3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 02:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F11611C1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 02:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhKDCmm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhKDCmm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 22:42:42 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C406113B;
        Thu,  4 Nov 2021 02:40:04 +0000 (UTC)
Date:   Wed, 3 Nov 2021 22:40:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 03/11] libtracefs: New APIs for kprobe allocation
Message-ID: <20211103224003.2fab4a57@rorschach.local.home>
In-Reply-To: <20211103154417.246999-4-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
        <20211103154417.246999-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Nov 2021 17:44:09 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to be consistent with the other APIs, new APIs for kprobe
> allocation are introduced:
>  tracefs_kprobe_alloc();
>  tracefs_kretprobe_alloc();
> These APIs allocate new kpobe dynamic event, that can be used with
> tracefs_dynevent_... set of APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs.h     |   5 ++
>  src/tracefs-kprobes.c | 105 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 110 insertions(+)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 470234d..b8f7c09 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -267,6 +267,11 @@ enum tracefs_kprobe_type {
>  	TRACEFS_KRETPROBE,
>  };
>  
> +struct tracefs_dynevent *
> +tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
> +struct tracefs_dynevent *
> +tracefs_kretprobe_alloc(const char *system, const char *event,
> +			const char *addr, const char *format, int max);
>  int tracefs_kprobe_raw(const char *system, const char *event,
>  		       const char *addr, const char *format);
>  int tracefs_kretprobe_raw(const char *system, const char *event,
> diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
> index 6fdd8f9..d1279ff 100644
> --- a/src/tracefs-kprobes.c
> +++ b/src/tracefs-kprobes.c
> @@ -20,6 +20,111 @@
>  #define KPROBE_EVENTS "kprobe_events"
>  #define KPROBE_DEFAULT_GROUP "kprobes"
>  
> +static struct tracefs_dynevent *
> +kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *event,
> +	     const char *addr, const char *format)
> +{
> +	struct tracefs_dynevent *kp;
> +	const char *sys = system;
> +	const char *ename = event;
> +	char *tmp;
> +
> +	if (!addr) {
> +		errno = EBADMSG;
> +		return NULL;
> +	}
> +	if (!sys)
> +		sys = KPROBE_DEFAULT_GROUP;
> +
> +	if (!event) {
> +		ename = strdup(addr);
> +		if (!ename)
> +			return NULL;
> +		tmp = strchr(ename, ':');
> +		if (tmp)
> +			*tmp = '\0';
> +	}
> +
> +	kp = dynevent_alloc(type, sys, ename, addr, format);
> +	if (!event)
> +		free((char *)ename);
> +
> +	return kp;
> +}
> +
> +/**
> + * tracefs_kprobe_alloc - Allocate new kprobe
> + * @system: The system name (NULL for the default kprobes)
> + * @event: The event to create (NULL to use @addr for the event)
> + * @addr: The function and offset (or address) to insert the probe
> + * @format: The format string to define the probe.
> + *
> + * Allocate a kprobe context that will be in the @system group (or kprobes if
> + * @system is NULL). Have the name of @event (or @addr if @event is
> + * NULL). Will be inserted to @addr (function name, with or without
> + * offset, or a address). And the @format will define the format
> + * of the kprobe. See the Linux documentation file under:
> + * Documentation/trace/kprobetrace.rst
> + * The kprobe is not created in the system.

Small nit, but what do you have your margins set to? When I set mine to
79 (where 80 is good enough), I get the following for the above text:

 * Allocate a kprobe context that will be in the @system group (or kprobes if
 * @system is NULL). Have the name of @event (or @addr if @event is NULL). Will
 * be inserted to @addr (function name, with or without offset, or a address).
 * And the @format will define the format of the kprobe.
 *
 * See the Linux documentation file under:
 *    Documentation/trace/kprobetrace.rst
 *
 * The kprobe is not created in the system.
 *


I also added some spaces for clarity.


> + *
> + * Return a pointer to a kprobe context on success, or NULL on error.
> + * The returned pointer must be freed with tracefs_dynevent_free()
> + *
> + * errno will be set to EBADMSG if addr is NULL.
> + */
> +struct tracefs_dynevent *
> +tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format)
> +
> +{
> +	return kprobe_alloc(TRACEFS_DYNEVENT_KPROBE, system, event, addr, format);
> +}
> +
> +/**
> + * tracefs_kretprobe_alloc - Allocate new kretprobe
> + * @system: The system name (NULL for the default kprobes)
> + * @event: The event to create (NULL to use @addr for the event)
> + * @addr: The function and offset (or address) to insert the retprobe
> + * @format: The format string to define the retprobe.
> + * @max: Maximum number of instances of the specified function that
> + *	 can be probed simultaneously, or 0 for the default value.
> + *
> + * Allocate a kretprobe that will be in the @system group (or kprobes if
> + * @system is NULL). Have the name of @event (or @addr if @event is
> + * NULL). Will be inserted to @addr (function name, with or without
> + * offset, or a address). And the @format will define the raw format
> + * of the kprobe. See the Linux documentation file under:
> + * Documentation/trace/kprobetrace.rst
> + * The kretprobe is not created in the system.
> + *
> + * Return a pointer to a kprobe context on success, or NULL on error.
> + * The returned pointer must be freed with tracefs_dynevent_free()
> + *
> + * errno will be set to EBADMSG if addr is NULL.
> + */
> +struct tracefs_dynevent *
> +tracefs_kretprobe_alloc(const char *system, const char *event,
> +			const char *addr, const char *format, int max)
> +{
> +	struct tracefs_dynevent *kp;
> +	int ret;
> +
> +	kp = kprobe_alloc(TRACEFS_DYNEVENT_KRETPROBE, system, event, addr, format);
> +	if (!kp)
> +		return NULL;
> +	if (max) {

Could add:

	if (!max)
		return kp;

And then remove the rest of the indentation.

-- Steve


> +		free(kp->prefix);
> +		kp->prefix = NULL;
> +		ret = asprintf(&kp->prefix, "r%d:", max);
> +		if (ret < 0)
> +			goto error;
> +	}
> +
> +	return kp;
> +error:
> +	tracefs_dynevent_free(kp);
> +	return NULL;
> +}
> +
>  static int insert_kprobe(const char *type, const char *system,
>  			 const char *event, const char *addr,
>  			 const char *format)

