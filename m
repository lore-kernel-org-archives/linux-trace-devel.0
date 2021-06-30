Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7601CC11F66
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5598161461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhF3Tsx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 15:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3Tsw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 15:48:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507D4C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 12:46:23 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nd37so6235655ejc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 12:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ASzelUkazvZf8YZGGI13lpDbRQ5fWfNG6LMVK05BtU0=;
        b=tc3tCnhUoh8xiH6PEahNeP7ku6rGBEQQNfjLRhmppb9B6cXpomRs6M5a7A1dOY4rr4
         OpNd5zyROl6eOmnWRAedxaeEwJ8Bl/qUnZBqtkkSgM2zGJRV5aWpbkoxRC44jLJlzGDe
         7NMVs4aJtE2MQuTmnZn/zJejU3PRVbLY4uUu8JVTG+YtXmMUjQkN8JeQELiWKjZnKcm0
         caY6ACuPbo+gWNHU26rRE/3ZjIgVD6GBMygC6kUU80GKS23KeqDouSKF7TxPVMhSBSAC
         pr+Qajnj752lAy4ccIhDtYw8CnaWETXimwKQ4Ml57AolC27UYLoKxhHQfmBt9xthDkB+
         SxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ASzelUkazvZf8YZGGI13lpDbRQ5fWfNG6LMVK05BtU0=;
        b=JPhMpXgWIhT0r2os+wqWLFWQCCZGjrIgoEGWIVf4iFIBMtTxTMd7W4QAzHsFQPymQ5
         JE4ZNsK6JPfJnWRm2MMYIY0USHrDDStRfol1ckOUjTGavOLjFUhziqLY86uoZHxUHo9y
         VWVM3FzF5SPAfylMt/bK3Qz6EUv3zqwZkpCLDxcMtayqWgx0OMXjfHIKT1Aa49an7YPV
         TBw8jkjQIwc37wO9z4A3c9tokehZ0/YCu+z4CWtjIHTmC+nSBvd5QQiwrgSCc/Klz/38
         AAlcj4jHWJUn7vPWDelzkJ1ZDH+vC/X0x/cqeVqHsn/09W6eA3R4lsKXy8waNdiKFc/q
         hdPA==
X-Gm-Message-State: AOAM5324Whkppka05ELOlnjVZYEgIZYitYDVb6U+NAqOcyViO4569oJL
        D7QYZ7lqaeEhEwb+cvys+woPGKJI2jc=
X-Google-Smtp-Source: ABdhPJzxXjnlffukKHdBH/C/s5aRhZOwS5+CC6d6I1OskbijJ6f2yFcb4Hi8UAQBxQMn0q6CZOcNhw==
X-Received: by 2002:a17:907:9691:: with SMTP id hd17mr37289159ejc.51.1625082381754;
        Wed, 30 Jun 2021 12:46:21 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id t15sm9931635ejf.119.2021.06.30.12.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 12:46:21 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] libtracefs: Implement tracefs_kprobe_raw()
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20210630154729.129873-1-rostedt@goodmis.org>
 <20210630154729.129873-3-rostedt@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <83cee0b8-b9c6-849b-291e-b750815de69e@gmail.com>
Date:   Wed, 30 Jun 2021 22:46:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630154729.129873-3-rostedt@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.06.21 г. 18:47, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add a function to facilitate creating a kprobe event. It has the "raw" in
> its name because it still requires knowing the format of the kprobe. But
> does handle the kprobe naming better and writing to the kprobe_event file.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   include/tracefs.h     |  4 +++
>   src/Makefile          |  1 +
>   src/tracefs-kprobes.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 75 insertions(+)
>   create mode 100644 src/tracefs-kprobes.c
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index a21d2d2f22a6..bc504bcb0188 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -214,4 +214,8 @@ int tracefs_tracer_clear(struct tracefs_instance *instance);
>   ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
>   ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
>   void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
> +
> +int tracefs_kprobe_raw(const char *system, const char *event,
> +		       const char *addr, const char *format);
> +
>   #endif /* _TRACE_FS_H */
> diff --git a/src/Makefile b/src/Makefile
> index b4cff07efc50..0697a047f4bc 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -8,6 +8,7 @@ OBJS += tracefs-instance.o
>   OBJS += tracefs-events.o
>   OBJS += tracefs-tools.o
>   OBJS += tracefs-marker.o
> +OBJS += tracefs-kprobes.o
>   
>   OBJS := $(OBJS:%.o=$(bdir)/%.o)
>   DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
> diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
> new file mode 100644
> index 000000000000..e4b28cff9f08
> --- /dev/null
> +++ b/src/tracefs-kprobes.c
> @@ -0,0 +1,70 @@
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
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +
> +#include "tracefs.h"
> +#include "tracefs-local.h"
> +
> +#define KPROBE_EVENTS "kprobe_events"
> +
> +/**
> + * tracefs_kprobe_raw - Create a kprobe using raw format
> + * @system: The system name (NULL for the default kprobes)
> + * @event: The event to create (NULL to use @addr for the event)
> + * @addr: The function and offset (or address) to insert the probe
> + * @format: The raw format string to define the probe.
> + *
> + * Create a kprobe that will be in the @system group (or kprobes if
> + * @system is NULL). Have the name of @event (or @addr if @event is
> + * NULL). Will be inserted to @addr (function name, with or without
> + * offset, or a address). And the @format will define the raw format
> + * of the kprobe. See the Linux documentation file under:
> + * Documentation/trace/kprobetrace.rst
> + *
> + * Return 0 on success, or -1 on error.
> + *   If the syntex of @format was incorrect, running
> + *   tracefs_error_last(NULL) may show what went wrong.
> + *
> + * errno will be set to EBADMSG if addr or format is NULL.
> + */
> +int tracefs_kprobe_raw(const char *system, const char *event,
> +		       const char *addr, const char *format)
> +{
> +	char *str;
> +	int ret;
> +
> +	errno = EBADMSG;
> +	if (!addr || !format)
> +		return -1;
> +
> +	if (!event)
> +		event = addr;
> +
> +	if (system)
> +		ret = asprintf(&str, "p:%s/%s %s %s\n",
> +			       system, event, addr, format);
> +	else
> +		ret = asprintf(&str, "p:%s %s %s\n",
> +			       event, addr, format);

I wonder what will be the way to register a "return value" ("r:") 
kprobe. Do you consider having a separate API for them?

Thanks!
Yordan

> +
> +	if (ret < 0)
> +		return -1;
> +
> +	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> 
