Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340D1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 17:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171616058D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 17:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhKARZD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhKARZD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 13:25:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61B0C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 10:22:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r4so66073632edi.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NY+rCm8nxwAbOBk2TXMoZM1/So8nQY2yVypPLn75LiE=;
        b=Xnu3ZG9BO5RiSPS2ulaiALW7iHD9nrk0PJgIhEPeoxpYw5Djkp35d7+pYLPX+Rehh8
         WNfYChvTuUaSXHRx42HIrU1CuRgyFdnl+Cbj6sXdaaShhdLBDitakvENV4reAgmmwRlZ
         knJl7SKOgLW5FOV4w+N/B9cXzDn8gLrgvbOWTkMyw6uIfma6kpFgyH85VJSb87Dz6chA
         MYAyJa3eCiJfxb2mcwT3i2M9fUuf8P5OULyFq/jy8Avqyb9mkEw57bw/SsV3xWY2N6jL
         9Gho7HMq1ivISEzP79NitlegPEhA5lL4+J8J62wTAakpoEBPiEhmtZCNFgZ6opO9r2/Q
         gz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NY+rCm8nxwAbOBk2TXMoZM1/So8nQY2yVypPLn75LiE=;
        b=xaKFyCEwJXTrVM4+iLxI2Kp0+zrKBnaMTtpK4wyRB1IGc37n9OqUpet+fAAonbP4Ll
         cBbTWFv1sx4MAKpBNbjjd9ddz968q6OfaVBJvMKmo05eFXX/xqjZ2nEn+Rks5x2a+pLJ
         ndVbx4E4J5EAlcEBxY93z4n4AkjBdOAGEmvGnsk8MpUVno1uwbJ7Hlg7QoFRflabCvPo
         EXt/ZLi3mhqjQftzlzR8xjkki7WL70ZrkoFtVAILjdYNyeF/Pl/1Dp2phMT2YB8iNBMY
         mTqgCyjN5VUzAAiWUNuVLklDlof54kyORvmPnubKnIqLPfZnwGFjSveUYJthuByM8gPB
         v64Q==
X-Gm-Message-State: AOAM533U7dpBMpEMEWIUG4v5qMFRu3uMdGyKDJ78jeeP1ATSWpuuBJ+8
        nIh0vlDsaH2I2IVrR9WXEc079tdD+BHYBg==
X-Google-Smtp-Source: ABdhPJyt/qbfV8uI1zTcvxaruc/Vd4ZUj2wov/8/0lsuylhQbEnDMrqFsgOlZNYZ1qZB41lgON5jEg==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr43637747edt.177.1635787347998;
        Mon, 01 Nov 2021 10:22:27 -0700 (PDT)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id ec38sm6537518edb.40.2021.11.01.10.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 10:22:27 -0700 (PDT)
Subject: Re: [PATCH v2 03/12] libtracefs: New kprobes APIs
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
 <20211101090904.81454-4-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <78703fa1-f811-a50c-6b5d-db68f6dbf21c@gmail.com>
Date:   Mon, 1 Nov 2021 19:22:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211101090904.81454-4-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 1.11.21 г. 11:08, Tzvetomir Stoyanov (VMware) wrote:
> In order to be consistent with the other APIs, a new set of kprobe APIs
> is introduced:
>   tracefs_kprobe_alloc();
>   tracefs_kretprobe_alloc();
>   tracefs_kprobe_create();
>   tracefs_kprobe_destroy();
>   tracefs_kprobe_free();
> These APIs work with kprobe context, represented by the tracefs_dynevent
> structure.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   include/tracefs.h     |   8 ++
>   src/tracefs-kprobes.c | 168 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 176 insertions(+)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 4e721eb..85185ce 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -247,6 +247,14 @@ enum tracefs_kprobe_type {
>   	TRACEFS_KRETPROBE,
>   };
>   
> +struct tracefs_dynevent *
> +tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
> +struct tracefs_dynevent *
> +tracefs_kretprobe_alloc(const char *system, const char *event,
> +			const char *addr, const char *format, int max);
> +int tracefs_kprobe_create(struct tracefs_dynevent *kprobe);
> +int tracefs_kprobe_destroy(struct tracefs_dynevent *kprobe, bool force);
> +void tracefs_kprobe_free(struct tracefs_dynevent *kprobe);
>   int tracefs_kprobe_raw(const char *system, const char *event,
>   		       const char *addr, const char *format);
>   int tracefs_kretprobe_raw(const char *system, const char *event,
> diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
> index d4c5f9e..906f914 100644
> --- a/src/tracefs-kprobes.c
> +++ b/src/tracefs-kprobes.c
> @@ -20,6 +20,134 @@
>   #define KPROBE_EVENTS "kprobe_events"
>   #define KPROBE_DEFAULT_GROUP "kprobes"
>   
> +static struct tracefs_dynevent *
> +kprobe_alloc(enum trace_dynevent_type type, const char *system, const char *event,
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
> +
> +/**
> + * tracefs_kprobe_alloc - Allocate new kprobe context
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
> + *
> + * Return a pointer to a kprobe context on success, or NULL on error.
> + * The returned pointer must be freed with tracefs_kprobe_free()
> + *
> + * errno will be set to EBADMSG if addr is NULL.
> + */
> +struct tracefs_dynevent *
> +tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format)
> +
> +{
> +	return kprobe_alloc(TRACE_DYNEVENT_KPROBE, system, event, addr, format);
> +}
> +
> +/**
> + * tracefs_kretprobe_alloc - Allocate new kretprobe context
> + * @system: The system name (NULL for the default kprobes)
> + * @event: The event to create (NULL to use @addr for the event)
> + * @addr: The function and offset (or address) to insert the retprobe
> + * @format: The format string to define the retprobe.
> + *

@max is not documented.

> + * Allocate a kretprobe that will be in the @system group (or kprobes if
> + * @system is NULL). Have the name of @event (or @addr if @event is
> + * NULL). Will be inserted to @addr (function name, with or without
> + * offset, or a address). And the @format will define the raw format
> + * of the kprobe. See the Linux documentation file under:
> + * Documentation/trace/kprobetrace.rst
> + * The kretprobe is not created in the system.
> + *
> + * Return a pointer to a kprobe context on success, or NULL on error.
> + * The returned pointer must be freed with tracefs_kprobe_free()
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
> +	kp = kprobe_alloc(TRACE_DYNEVENT_KRETPROBE, system, event, addr, format);
> +	if (!kp)
> +		return NULL;
> +	if (max) {
> +		free(kp->prefix);
> +		kp->prefix = NULL;
> +		ret = asprintf(&kp->prefix, "r%d:", max);
> +		if (ret < 0)
> +			goto error;
> +	}
> +
> +	return kp;
> +error:
> +	dynevent_free(kp);
> +	return NULL;
> +}
> +
> +/**
> + * tracefs_kprobe_create - Create a kprobe or kretprobe in the system
> + * @kprobe: Pointer to a kprobe context, describing the probe
> + *
> + * Return 0 on success, or -1 on error.
> + */
> +int tracefs_kprobe_create(struct tracefs_dynevent *kprobe)
> +{
> +	return dynevent_create(kprobe);
> +}
> +

hmm, what will happen if if you have a code like this:


struct tracefs_dynevent *synth = tracefs_synth_alloc(...)

int ret = tracefs_kprobe_create(synth);


Are you just giving several additional fake names to the same function ('dynevent_create()')?


> +/**
> + * tracefs_kprobe_free - Free a kprobe context
> + * @kprobe: Pointer to a kprobe context
> + *
> + * The kprobe/kretprobe, described by this context, is not
> + * removed from the system by this API. It only frees the memory.
> + */
> +void tracefs_kprobe_free(struct tracefs_dynevent *kprobe)
> +{
> +	dynevent_free(kprobe);
> +}
> +

The same argument applys here.

Thanks!
Yordan

> +
>   static int insert_kprobe(const char *type, const char *system,
>   			 const char *event, const char *addr,
>   			 const char *format)
> @@ -474,3 +602,43 @@ int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force
>   
>   	return ret < 0 ? -1 : 0;
>   }
> +
> +/**
> + * tracefs_kprobe_destroy - Remove a kprobe or kretprobe from the system
> + * @kprobe: A kprobe context, describing the kprobe that will be deleted.
> + *	    If NULL, all kprobes and kretprobes in the system will be deleted
> + * @force: Will attempt to disable all kprobe events and clear them
> + *
> + * The kprobe/kretprobe context is not freed by this API.
> + * It only removes the probe from the system.
> + *
> + * Return 0 on success, or -1 on error.
> + */
> +int tracefs_kprobe_destroy(struct tracefs_dynevent *kprobe, bool force)
> +{
> +	char **instance_list;
> +	int ret;
> +
> +	if (!kprobe) {
> +		if (tracefs_instance_file_clear(NULL, KPROBE_EVENTS) == 0)
> +			return 0;
> +		if (!force)
> +			return -1;
> +		/* Attempt to disable all kprobe events */
> +		return kprobe_clear_probes(NULL, force);
> +	}
> +
> +	/*
> +	 * Since we know we are disabling a specific event, try
> +	 * to disable it first before clearing it.
> +	 */
> +	if (force) {
> +		instance_list = tracefs_instances(NULL);
> +		disable_events(kprobe->system, kprobe->event, instance_list);
> +		tracefs_list_free(instance_list);
> +	}
> +
> +	ret = dynevent_destroy(kprobe);
> +
> +	return ret < 0 ? -1 : 0;
> +}
> 
