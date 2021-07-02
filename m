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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D770C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043F961422
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhGBLNY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbhGBLNX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:13:23 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5112C061762
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jul 2021 04:10:50 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j39-20020a05600c1c27b029020028e48b8fso452494wms.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Jul 2021 04:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jz7LcsVd9TAAEtkyFW0BTciYkgBjKqx/JhrTethzbgk=;
        b=cmHFRuJOIo/o5/+70wMCuinR63uOWir/t8Z0T2EKQVPIKxd8DwetnUpteyebifQBCk
         UDiYWaRmmp+dy86WEHKShd6aoA7RTEWXwI5fafVwoQzquMTRbCxRP3/n0TXhD75MkOwy
         rYyZROSVCVcUPTsTchlPZNJQyR48LsNPgjRfkPhZIhOznKtkLfOOtw4l6PYWfQL41lpM
         gnWXlCIJjBdxzTFnAj50zwOH/KH7PohHITV2Oit3FuVs03ND5+bTWzfm/YXaiRH8o1fG
         icKhou6yTZtGLnNhAkOVYhYpWzcx23x0uDyVsnTZ/abpLdFjc1ndVG1kXVp3J36csybb
         gIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jz7LcsVd9TAAEtkyFW0BTciYkgBjKqx/JhrTethzbgk=;
        b=OvqgC2t2/9Af+t7nedbrzn2rNY0RhMOOHSpCtxW54W6y8oqW5GOENkt1vIfJ5bSyuD
         dz8uWMIs9rh72L0LtOSUB35c8Zy+qxr6h7vD95txREfbaBt6ilV3cx9RAkHenJSbgKnY
         RomIxYgfzrRIpS8QJUz3sUwRGQousFuROAOxyibtl3D3mO8hKZM/Ci7gS5HNvEsZdaoG
         sd4ghuy21YIvqr1xSltmyX0DLB/p82YQyVVsgIhgQp2psggzPHseitN5OZ+WgTHz2kfr
         Nt66wr2le62REBd530cE17hZbn2HWAAR7O1iSi9J8qFGMCgtW6Hv4V7W7LXTGedqaYG4
         tDRg==
X-Gm-Message-State: AOAM533c8NsvIkwg1vUaJ6SltOEh8UdetMHglNA2OwvSGQfmoB3gNFbI
        scf5zu1glJO3KYWC1dTramDjjAtbuM4=
X-Google-Smtp-Source: ABdhPJzokSzzFY8vb0MYlXqI7Rp0cSGqAH0KCgzjrctkI99ORhxnuBIZ5Szv/TndZS1B9bhtz7a3FA==
X-Received: by 2002:a05:600c:4304:: with SMTP id p4mr6987956wme.43.1625224248533;
        Fri, 02 Jul 2021 04:10:48 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id b187sm13552022wmh.32.2021.07.02.04.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 04:10:47 -0700 (PDT)
Subject: Re: [PATCH v4 1/7] libtracefs: Implement tracefs_instances()
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20210702035443.154729-1-rostedt@goodmis.org>
 <20210702035443.154729-2-rostedt@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <4335f4d8-73eb-a2e4-f439-95cbe69acff2@gmail.com>
Date:   Fri, 2 Jul 2021 14:10:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702035443.154729-2-rostedt@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.07.21 г. 6:54, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Implement tracefs_instances() that will take a regex (or NULL for all) and
> return a list of instances in the system.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   include/tracefs.h      |  1 +
>   src/tracefs-instance.c | 78 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 79 insertions(+)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index da8ad4189d4d..a21d2d2f22a6 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -44,6 +44,7 @@ int tracefs_instance_file_read_number(struct tracefs_instance *instance,
>   int tracefs_instance_file_open(struct tracefs_instance *instance,
>   			       const char *file, int mode);
>   int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
> +char **tracefs_instances(const char *regex);
>   
>   bool tracefs_instance_exists(const char *name);
>   bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index 2aeb529903bd..d833fae0fb0c 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -14,6 +14,7 @@
>   #include <sys/stat.h>
>   #include <fcntl.h>
>   #include <dirent.h>
> +#include <regex.h>
>   #include <limits.h>
>   #include <pthread.h>
>   #include "tracefs.h"
> @@ -630,6 +631,83 @@ out:
>   	return fret;
>   }
>   
> +static inline bool match(const char *str, regex_t *re)
> +{
> +	if (!re)
> +		return true;
> +	return regexec(re, str, 0, NULL, 0) == 0;
> +}
> +
> +struct instance_list {
> +	regex_t		*re;
> +	char		**list;
> +	int		size;
> +	int		failed;
> +};
> +
> +static int build_list(const char *name, void *data)
> +{
> +	struct instance_list *list = data;
> +	char **instances;
> +	int ret = -1;
> +
> +	if (!match(name, list->re))
> +		return 0;
> +
> +	instances = realloc(list->list, list->size + 2);
> +	if (!instances)
> +		goto out;
> +
> +	list->list = instances;
Hi Steven,

I am not sure what was your original intention here, but this doesn't 
seem to work properly. Maybe we need something like this:

	int size =  sizeof(*instances) * (list->size + 2);
	instances = realloc(list->list, size);
	if (!instances)
		goto out;

	instances[list->size + 1] = NULL;




> +	list->list[list->size] = strdup(name);
> +	if (!list->list[list->size])
> +		goto out;
> +
> +	list->size++;
> +	ret = 0;
> +
> + out:
> +	list->failed = ret;
> +	return ret;
> +}
> +
> +/**
> + * tracefs_instances - return a list of instance names
> + * @regex: A regex of instances to filter on (NULL to match all)
> + *
> + * Returns a list of names of existing instances, that must be
> + * freed with tracefs_list_free(). Note, if there are no matches
> + * then an empty list will be returned (not NULL).
> + * NULL on error.
> + */
> +char **tracefs_instances(const char *regex)
> +{
> +	struct instance_list list = { .re = NULL, .list = NULL };
> +	regex_t re;
> +	int ret;
> +
> +	if (regex) {
> +		ret = regcomp(&re, regex, REG_ICASE|REG_NOSUB);
> +		if (ret < 0)
> +			return NULL;
> +		list.re = &re;
> +	}
> +
> +	ret = tracefs_instances_walk(build_list, &list);
> +	if (ret < 0 || list.failed) {
> +		tracefs_list_free(list.list);
> +		list.list = NULL;
> +	} else {
> +		if (!list.list) {
> +			/* No matches should produce an empty list */
> +			list.list = malloc(sizeof(*list.list));
> +			if (list.list)
> +				list.list[0] = NULL;
> +		}

Or you can just do:
				return calloc(1, sizeof(*list.list));

Thanks!
Yordan

> +	}
> +	return list.list;
> +}
> +
>   /**
>    * tracefs_get_clock - Get the current trace clock
>    * @instance: ftrace instance, can be NULL for the top instance
> 
