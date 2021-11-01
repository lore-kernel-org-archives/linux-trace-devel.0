Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8763EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 17:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E3061212
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 17:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhKARJf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhKARJe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 13:09:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3D8C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 10:07:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so66300522edj.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=39gCkS2/7FNt3PfryFrrNDE0LRrRlMiA3yuB9HE2sro=;
        b=XH/9I+lYhjGXe8W6Bgi/fe4308gNtQ62f/v7yKtZF3sWnqPwZbUqRi02gU1NPhx5D9
         o1/yn9xBbbqH4o6ENGZDh9Gydek1KqDUxrz+SvP9SZSpZWWfK4TwswESK+TjOuFdJmli
         dr8WjzNh1b3cs9MmtvHKoIP5hTbTtIfgaFTCmkGoGdmwnna3M7MVrPKycGJBGDzNuWfv
         ZwH1y3xi+1jenSy/yd7MwQf2h0xIaxdiRbqEsJJGCJdF46ZDvrFx10qbuK7IXx3DPFYo
         sfH5iSXoLaeAt24AgMnZto2jbXFjgbcAuVnaZ0Qv6sht8d3jJvX+Ih2kIi4Gby12kd3W
         G2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=39gCkS2/7FNt3PfryFrrNDE0LRrRlMiA3yuB9HE2sro=;
        b=J84ch9e7ZC8loBsC5Wcw6Gqlp+yWgFWbp1LqjJq5hAmWuFvvavIIZz7EL5iUJXMP7F
         b7h1zQKETkyppobx/gJBsQoDsCLLSmWw3bIcjDda72eJc74qHSjMoemKmM5hBtCwnOgr
         J2txyvgWS4XrBwAn9awT3QKnOibcBk5KwwAhWxPuX7ipgT6n3PStrHTJE1Owav4Wo81B
         riCPYSxyix/HClTP2CDhJ9btBrpGIzfhd37zgutJaejQdB9lLM+eiT2XnkCplIr1A/qp
         AI0CvwZF9kKjpQQUry57a4i2mq+7fXPTl03m1hbsI71b/9cXcb/MIMbMMxglS2ZMFFJf
         i/Ng==
X-Gm-Message-State: AOAM533xtU056EHn//qTcq7LI5jmG1DnAJHI78gQgucaZ8RtW+YMYsac
        FyWivRBEBnO6qaIDztd81GGmrC6qUu2nfg==
X-Google-Smtp-Source: ABdhPJx6paONQTj8YmmWPEJh7V4jD+wFnfe1AANVDxhl98Ui9gHxjFR2rSIVX/LitfHq3RFcJwncXg==
X-Received: by 2002:a17:906:dc8a:: with SMTP id cs10mr38006174ejc.254.1635786419117;
        Mon, 01 Nov 2021 10:06:59 -0700 (PDT)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id r16sm7118903ejj.89.2021.11.01.10.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 10:06:58 -0700 (PDT)
Subject: Re: [PATCH v2 01/12] libtracefs: Add new internal APIs for dynamic
 events
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
 <20211101090904.81454-2-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <6eb04d9b-54f5-77a6-1be8-adea54e710cf@gmail.com>
Date:   Mon, 1 Nov 2021 19:06:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211101090904.81454-2-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 1.11.21 г. 11:08, Tzvetomir Stoyanov (VMware) wrote:
> Ftrace supports dynamic events, created by the user - kprobes, uprobes,
> eprobes and synthetic events. There are two interfaces for managing
> these events - new common "dynamic_events" file and event specific
> "kprobe_events", "uprobe_events", "synthetic_events" files. The
> configuration syntax for all dynamic events is almost the same.
> To simplify support of dynamic events in thw tracefs library, a new

thw -> the

> internal helper layer is implemented. It handles both configuration
> interfaces - the common "dynamic_events" file is preferred, if
> available. On the old kernels, where this file is missing, the event
> specific files are used. The new helper layer can be used to create,
> delete and get ftrace dynamic events form any type. Most of the APIs

form -> from

> are internal, not exposed to the library users. Only one API is exposed
> publicly:
>   tracefs_dynevent_list_free()
> This new logic is designed to be used internally within the library,
> from the APIs that implement kprobes, uprobes, eprobes and synthetic
> events support.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   include/tracefs-local.h |  35 +++
>   include/tracefs.h       |   3 +
>   src/Makefile            |   1 +
>   src/tracefs-dynevents.c | 492 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 531 insertions(+)
>   create mode 100644 src/tracefs-dynevents.c
> 
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 684eccf..60440c6 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -15,6 +15,10 @@
>   #define BUILD_BUG_ON(cond)			\
>   	do { if (!(1/!(cond))) { } } while (0)
>   
> +#define SET_BIT(M, B)	do { (M) |= (1ULL << (B)); } while (0)
> +#define TEST_BIT(M, B)	((M) & (1ULL<<(B)))
> +#define CLEAR_BIT(M, B)	do { (M) &= ~(1ULL << (B)); } while (0)
> +
>   struct tracefs_options_mask {
>   	unsigned long long	mask;
>   };
> @@ -94,4 +98,35 @@ int synth_add_start_field(struct tracefs_synth *synth,
>   			  const char *start_field,
>   			  const char *name,
>   			  enum tracefs_hist_key_type type);
> +
> +/* Internal interface for ftrace dynamic events */
> +enum trace_dynevent_type {
> +	TRACE_DYNEVENT_KPROBE = 0,
> +	TRACE_DYNEVENT_KRETPROBE,
> +	TRACE_DYNEVENT_UPROBE,
> +	TRACE_DYNEVENT_URETPROBE,
> +	TRACE_DYNEVENT_EPROBE,
> +	TRACE_DYNEVENT_SYNTH,
> +	TRACE_DYNEVENT_MAX,
> +};
> +
> +struct tracefs_dynevent {
> +	char *trace_file;
> +	char *prefix;
> +	char *system;
> +	char *event;
> +	char *address;
> +	char *format;
> +	enum trace_dynevent_type type;
> +};
> +
> +struct tracefs_dynevent *
> +dynevent_alloc(enum trace_dynevent_type type, const char *system,
> +	       const char *event, const char *address, const char *format);
> +void dynevent_free(struct tracefs_dynevent *devent);
> +int dynevent_create(struct tracefs_dynevent *devent);
> +int dynevent_destroy(struct tracefs_dynevent *devent);
> +struct tracefs_dynevent **dynevent_get_all(unsigned long type_mask, const char *system);
> +int dynevent_get_count(unsigned long type_mask, const char *system);
> +
>   #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index a2cda30..ee167be 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -238,6 +238,9 @@ ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int
>   ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
>   void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
>   
> +struct tracefs_dynevent;
> +void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
> +
>   enum tracefs_kprobe_type {
>   	TRACEFS_ALL_KPROBES,
>   	TRACEFS_KPROBE,
> diff --git a/src/Makefile b/src/Makefile
> index 4e38d98..99cd7da 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -11,6 +11,7 @@ OBJS += tracefs-marker.o
>   OBJS += tracefs-kprobes.o
>   OBJS += tracefs-hist.o
>   OBJS += tracefs-filter.o
> +OBJS += tracefs-dynevents.o
>   
>   # Order matters for the the three below
>   OBJS += sqlhist-lex.o
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> new file mode 100644
> index 0000000..0de4c49
> --- /dev/null
> +++ b/src/tracefs-dynevents.c
> @@ -0,0 +1,492 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
> + *
> + * Updates:
> + * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <dirent.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +
> +#include "tracefs.h"
> +#include "tracefs-local.h"
> +
> +#define DYNEVENTS_EVENTS "dynamic_events"
> +#define KPROBE_EVENTS "kprobe_events"

A definition of KPROBE_EVENTS already exists in /utest/tracefs-utest.c and src/tracefs-kprobes.c

Isn't better to move the whole group of definitions of filenames to include/tracefs-local.h?

Thanks!
Yordan

> +#define UPROBE_EVENTS "uprobe_events"
> +#define SYNTH_EVENTS "synthetic_events"
> +#define DYNEVENTS_DEFAULT_GROUP "dynamic"
> +
> +struct dyn_events_desc;
> +static int dyn_generic_parse(struct dyn_events_desc *,
> +			     const char *, char *, struct tracefs_dynevent **);
> +static int dyn_synth_parse(struct dyn_events_desc *,
> +			   const char *, char *, struct tracefs_dynevent **);
> +static int dyn_generic_del(struct dyn_events_desc *, struct tracefs_dynevent *);
> +static int dyn_synth_del(struct dyn_events_desc *, struct tracefs_dynevent *);
> +
> +struct dyn_events_desc {
> +	enum trace_dynevent_type type;
> +	const char *file;
> +	const char *prefix;
> +	int (*dyn_events_del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
> +	int (*dyn_events_parse)(struct dyn_events_desc *desc, const char *group,
> +				char *line, struct tracefs_dynevent **ret_dyn);
> +} dynevents[] = {
> +	{TRACE_DYNEVENT_KPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_KRETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_UPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_URETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_EPROBE, NULL, "e", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_SYNTH, NULL, "s", dyn_synth_del, dyn_synth_parse},
> +};
> +
> +int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
> +{
> +	char *str;
> +	int ret;
> +
> +	if (dyn->system)
> +		ret = asprintf(&str, "-:%s/%s", dyn->system, dyn->event);
> +	else
> +		ret = asprintf(&str, "-:%s", dyn->event);
> +
> +	if (ret < 0)
> +		return -1;
> +
> +	ret = tracefs_instance_file_append(NULL, desc->file, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +__hidden void dynevent_free(struct tracefs_dynevent *devent)
> +{
> +	if (!devent)
> +		return;
> +	free(devent->system);
> +	free(devent->event);
> +	free(devent->address);
> +	free(devent->format);
> +	free(devent->prefix);
> +	free(devent->trace_file);
> +	free(devent);
> +}
> +
> +static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
> +			     char *line, struct tracefs_dynevent **ret_dyn)
> +{
> +	struct tracefs_dynevent *dyn;
> +	char *format = NULL;
> +	char *address;
> +	char *system;
> +	char *prefix;
> +	char *event;
> +	char *sav;
> +
> +	if (strncmp(line, desc->prefix, strlen(desc->prefix)))
> +		return -1;
> +
> +	prefix = strtok_r(line, ":", &sav);
> +	if (!prefix)
> +		return -1;
> +	system = strtok_r(NULL, "/", &sav);
> +	if (!system)
> +		return -1;
> +	event = strtok_r(NULL, " ", &sav);
> +	if (!event)
> +		return -1;
> +	address = strtok_r(NULL, " ", &sav);
> +	if (!address)
> +		address = event + strlen(event) + 1;
> +	else
> +		format = address + strlen(address) + 1;
> +
> +	/* KPROBEs and UPROBEs share the same prefix, check the format */
> +	if (desc->type == TRACE_DYNEVENT_UPROBE || desc->type == TRACE_DYNEVENT_URETPROBE) {
> +		if (!strchr(address, '/'))
> +			return -1;
> +	}
> +	if (group && strcmp(group, system) != 0)
> +		return -1;
> +
> +	if (!ret_dyn)
> +		return 0;
> +
> +	dyn = calloc(1, sizeof(*dyn));
> +	if (!dyn)
> +		return -1;
> +
> +	dyn->type = desc->type;
> +	dyn->trace_file = strdup(desc->file);
> +	if (!dyn->trace_file)
> +		goto error;
> +	dyn->system = strdup(system);
> +	if (!dyn->system)
> +		goto error;
> +	/* Prefix of KRETPROBE can contain MAXACTIVE integer */
> +	dyn->prefix = strdup(prefix);
> +	if (!dyn->prefix)
> +		goto error;
> +	dyn->event = strdup(event);
> +	if (!dyn->event)
> +		goto error;
> +	if (desc->type == TRACE_DYNEVENT_SYNTH) {
> +		/* Synthetic events have no address */
> +		dyn->format = strdup(address);
> +		if (!dyn->format)
> +			goto error;
> +	} else {
> +		dyn->address = strdup(address);
> +		if (!dyn->address)
> +			goto error;
> +		if (*format != '\0') {
> +			dyn->format = strdup(format);
> +			if (!dyn->format)
> +				goto error;
> +		}
> +	}
> +	*ret_dyn = dyn;
> +	return 0;
> +error:
> +	dynevent_free(dyn);
> +	return -1;
> +}
> +
> +int dyn_synth_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
> +{
> +	char *str;
> +	int ret;
> +
> +	if (strcmp(desc->file, DYNEVENTS_EVENTS))
> +		return dyn_generic_del(desc, dyn);
> +
> +	ret = asprintf(&str, "!%s", dyn->event);
> +	if (ret < 0)
> +		return -1;
> +
> +	ret = tracefs_instance_file_append(NULL, desc->file, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static int dyn_synth_parse(struct dyn_events_desc *desc, const char *group,
> +			   char *line, struct tracefs_dynevent **ret_dyn)
> +{
> +	struct tracefs_dynevent *dyn;
> +	char *format;
> +	char *event;
> +	char *sav;
> +
> +	if (strcmp(desc->file, DYNEVENTS_EVENTS))
> +		return dyn_generic_parse(desc, group, line, ret_dyn);
> +
> +	/* synthetic_events file has slightly different syntax */
> +	event = strtok_r(line, " ", &sav);
> +	if (!event)
> +		return -1;
> +
> +	format = event + strlen(event) + 1;
> +	if (*format == '\0')
> +		return -1;
> +	if (!ret_dyn)
> +		return 0;
> +
> +	dyn = calloc(1, sizeof(*dyn));
> +	if (!dyn)
> +		return -1;
> +	dyn->type = desc->type;
> +	dyn->trace_file = strdup(desc->file);
> +	if (!dyn->trace_file)
> +		goto error;
> +
> +	dyn->event = strdup(event);
> +	if (!dyn->event)
> +		goto error;
> +	dyn->format = strdup(format+1);
> +	if (!dyn->format)
> +		goto error;
> +
> +	*ret_dyn = dyn;
> +	return 0;
> +error:
> +	dynevent_free(dyn);
> +	return -1;
> +}
> +
> +static void init_devent_desc(void)
> +{
> +	int i;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != TRACE_DYNEVENT_MAX);
> +
> +	/* Use  ftrace dynamic_events, if available */
> +	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
> +		for (i = 0; i < TRACE_DYNEVENT_MAX; i++)
> +			dynevents[i].file = DYNEVENTS_EVENTS;
> +		return;
> +	}
> +
> +	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
> +		dynevents[TRACE_DYNEVENT_KPROBE].file = KPROBE_EVENTS;
> +		dynevents[TRACE_DYNEVENT_KRETPROBE].file = KPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
> +		dynevents[TRACE_DYNEVENT_UPROBE].file = UPROBE_EVENTS;
> +		dynevents[TRACE_DYNEVENT_URETPROBE].file = UPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
> +		dynevents[TRACE_DYNEVENT_SYNTH].file = SYNTH_EVENTS;
> +		dynevents[TRACE_DYNEVENT_SYNTH].prefix = "";
> +	}
> +
> +}
> +
> +static struct dyn_events_desc *get_devent_desc(enum trace_dynevent_type type)
> +{
> +	static bool init;
> +
> +	if (!init) {
> +		init_devent_desc();
> +		init = true;
> +	}
> +
> +	return &dynevents[type];
> +}
> +
> +__hidden struct tracefs_dynevent *
> +dynevent_alloc(enum trace_dynevent_type type, const char *system,
> +	       const char *event, const char *address, const char *format)
> +{
> +	struct tracefs_dynevent *devent;
> +	struct dyn_events_desc *desc;
> +
> +	if (!event) {
> +		errno = EINVAL;
> +		return NULL;
> +	}
> +
> +	desc = get_devent_desc(type);
> +	if (!desc || !desc->file) {
> +		errno = ENOTSUP;
> +		return NULL;
> +	}
> +
> +	devent = calloc(1, sizeof(*devent));
> +	if (!devent)
> +		return NULL;
> +
> +	devent->type = type;
> +	devent->trace_file = strdup(desc->file);
> +	if (!devent->trace_file)
> +		goto err;
> +
> +	if (!system)
> +		system = DYNEVENTS_DEFAULT_GROUP;
> +	devent->system = strdup(system);
> +	if (!devent->system)
> +		goto err;
> +
> +	devent->event = strdup(event);
> +	if (!devent->event)
> +		goto err;
> +
> +	devent->prefix = strdup(desc->prefix);
> +	if (!devent->prefix)
> +		goto err;
> +
> +	if (address) {
> +		devent->address = strdup(address);
> +		if (!devent->address)
> +			goto err;
> +	}
> +	if (format) {
> +		devent->format = strdup(format);
> +		if (!devent->format)
> +			goto err;
> +	}
> +
> +	return devent;
> +err:
> +	dynevent_free(devent);
> +	return NULL;
> +}
> +
> +__hidden int dynevent_create(struct tracefs_dynevent *devent)
> +{
> +	char *str;
> +	int ret;
> +
> +	if (!devent)
> +		return -1;
> +
> +	if (devent->system && devent->system[0])
> +		ret = asprintf(&str, "%s%s%s/%s %s %s\n",
> +				devent->prefix, strlen(devent->prefix) > 0 ? ":" : "",
> +				devent->system, devent->event,
> +				devent->address ? devent->address : "",
> +				devent->format ? devent->format : "");
> +	else
> +		ret = asprintf(&str, "%s%s%s %s %s\n",
> +				devent->prefix, strlen(devent->prefix) > 0 ? ":" : "",
> +				devent->event,
> +				devent->address ? devent->address : "",
> +				devent->format ? devent->format : "");
> +	if (ret < 0)
> +		return -1;
> +
> +	ret = tracefs_instance_file_append(NULL, devent->trace_file, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +__hidden int dynevent_destroy(struct tracefs_dynevent *devent)
> +{
> +	struct dyn_events_desc *desc;
> +
> +	if (!devent)
> +		return -1;
> +
> +	desc = get_devent_desc(devent->type);
> +	if (!desc)
> +		return -1;
> +
> +	return desc->dyn_events_del(desc, devent);
> +}
> +
> +static int get_all_type(enum trace_dynevent_type type, const char *system,
> +			struct tracefs_dynevent ***ret_all)
> +{
> +	struct dyn_events_desc *desc;
> +	struct tracefs_dynevent *devent, **tmp, **all = NULL;
> +	char *content;
> +	int count = 0;
> +	char *line;
> +	char *next;
> +	int ret;
> +
> +	desc = get_devent_desc(type);
> +	if (!desc)
> +		return -1;
> +
> +	content = tracefs_instance_file_read(NULL, desc->file, NULL);
> +	if (!content)
> +		return -1;
> +
> +	line = content;
> +	do {
> +		next = strchr(line, '\n');
> +		if (next)
> +			*next = '\0';
> +		ret = desc->dyn_events_parse(desc, system, line, ret_all ? &devent : NULL);
> +		if (!ret) {
> +			if (ret_all) {
> +				tmp = realloc(all, (count+1)*sizeof(struct tracefs_dynevent *));
> +				if (!tmp)
> +					goto error;
> +				all = tmp;
> +				all[count] = devent;
> +			}
> +			count++;
> +		}
> +		line = next + 1;
> +	} while (next);
> +
> +	free(content);
> +	if (ret_all)
> +		*ret_all = all;
> +	return count;
> +
> +error:
> +	free(content);
> +	free(all);
> +	return -1;
> +}
> +
> +/**
> + * tracefs_dynevent_list_free - Deletes an array of pointers to dynamic event contexts
> + * @events: An array of pointers to dynamic event contexts. The last element of the array
> + *	    must be a NULL pointer.
> + */
> +void tracefs_dynevent_list_free(struct tracefs_dynevent **events)
> +{
> +	int i = 0;
> +
> +	if (!events)
> +		return;
> +
> +	while (events[i])
> +		dynevent_free(events[i++]);
> +
> +	free(events);
> +}
> +
> +__hidden struct tracefs_dynevent **dynevent_get_all(unsigned long type_mask, const char *system)
> +{
> +	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
> +	int count, all = 0;
> +	int i;
> +
> +	for (i = 0; i < TRACE_DYNEVENT_MAX; i++) {
> +		if (!TEST_BIT(type_mask, i))
> +			continue;
> +
> +		count = get_all_type(i, system, &events);
> +		if (count > 0) {
> +			tmp = realloc(all_events,
> +				     (all + count)*sizeof(struct tracefs_dynevent *));
> +			if (!tmp)
> +				goto error;
> +			all_events = tmp;
> +			memcpy(all_events + all, events,
> +			       count*sizeof(struct tracefs_dynevent *));
> +			all += count;
> +		}
> +
> +	}
> +
> +	/* Add a NULL pointer at the end */
> +	if (all > 0) {
> +		tmp = realloc(all_events,
> +			     (all + 1)*sizeof(struct tracefs_dynevent *));
> +		if (!tmp)
> +			goto error;
> +
> +		all_events = tmp;
> +		all_events[all] = NULL;
> +	}
> +
> +	return all_events;
> +
> +error:
> +	if (all_events) {
> +		for (i = 0; i < all; i++)
> +			free(all_events[i]);
> +		free(all_events);
> +	}
> +	return NULL;
> +}
> +
> +__hidden int dynevent_get_count(unsigned long type_mask, const char *system)
> +{
> +	int count, all = 0;
> +	int i;
> +
> +	for (i = 0; i < TRACE_DYNEVENT_MAX; i++) {
> +		if (!TEST_BIT(type_mask, i))
> +			continue;
> +		count = get_all_type(i, system, NULL);
> +		if (count > 0)
> +			all += count;
> +	}
> +
> +	return all;
> +}
> 
