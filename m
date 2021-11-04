Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80284C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 12:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 698BA611C1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 12:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhKDMuP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 08:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhKDMuP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 08:50:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29458C061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 05:47:37 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso7128019wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 05:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X52HsassXaakznCaRbAfL525t1nvgCxUf0+zOKT1b0s=;
        b=atqTKIIIOS0pGqxui4xmY+Era5ojHkCIpeSE/8VkKiWnBT7zDKHPx624csj5xKhzU1
         RltrTiyPOWcQsvcouyClepk+Hy/tRpZX1WnlFwKkjBCaBw2C0LB1/8wsFdYKQtHz29fN
         yHBvLheRYwapQaPpgLMGGDnye0qRk30ccKTP99FOhkmnOxOz6/qLCPEFnZ+dlsGxGSYS
         XTMw4t/nhQgzPYIXMOJpjsDTjScoDQkjTnoca6FRQvqhUryGtu1OJzdH5yUt7sdrEpZS
         nuoBjb/p3lRdKuO4C6TZypTSMHEA3dx5aRxO9jTxOqmxX02CInVvNsRaI0hs5hWpx9to
         kUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X52HsassXaakznCaRbAfL525t1nvgCxUf0+zOKT1b0s=;
        b=3CD2HzefajxFuyhPUaElVi5ONVtSUJB6IwS8ZmXsrKqg33mj915CrJ7pdODLLjq6ks
         7vcz+lV6XzzXs5E8pzw42Lxr0DmwtW0YVbUopAOqKm+/LQNGIgN3bWlJx9bjESJVq9sB
         qO/rCmXs+TvUCWa0uPYDY4nJW6RUpv84gqv/KKohfqnhTGJZjiQSqQPffTSK5YjMqY0/
         wZiewkpGL0vf+FoNcintkpS6+ElDiAKnroPVlnFpali6VD9u0CL8/+tMMHTrJkGx4HXZ
         HQnLuaT5CzH2zOuvf4eR+Zww4jq7yTxdiVTpWHoTMfOm3BXSAPYjdfbn1eQVU4xMOZiZ
         KnBA==
X-Gm-Message-State: AOAM533tNhhZFM0BqenuzWTP9hjG+JZQHC5Sgg2falkV723b85ycAIAu
        xWrDXyyFCsMLzy/QzksUfLqWe0iSafMnTg==
X-Google-Smtp-Source: ABdhPJxsnSgeaL2gTenJx0Qm/yt22x+AZgk7UZ3uGLIPlMunY/jopFlkMGG6/p/hV/yF+QPUkZ/fvA==
X-Received: by 2002:a05:600c:4154:: with SMTP id h20mr21784921wmm.189.1636030055476;
        Thu, 04 Nov 2021 05:47:35 -0700 (PDT)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id g18sm5390533wmq.4.2021.11.04.05.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 05:47:35 -0700 (PDT)
Subject: Re: [PATCH v4 08/10] libtracefs: Use the internal dynamic events API
 when creating synthetic events
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
 <20211104111047.302660-9-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <256b3fba-49a1-3082-608a-53c9d35f8757@gmail.com>
Date:   Thu, 4 Nov 2021 14:47:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104111047.302660-9-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 4.11.21 г. 13:10, Tzvetomir Stoyanov (VMware) wrote:
> Synthetic events are type of ftrace dynamic events. The tracefs library
> has dedicated APIs to manage dynamic events of all types. In order the
> code to be consistent, the creation of synthetic events inside the
> library is reimplemented with these new dynamic events APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   src/tracefs-hist.c | 103 +++++++++++++++++++++------------------------
>   1 file changed, 47 insertions(+), 56 deletions(-)
> 
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 9009dba..08bb2da 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -661,6 +661,7 @@ struct tracefs_synth {
>   	struct tep_event	*end_event;
>   	struct action		*actions;
>   	struct action		**next_action;
> +	struct tracefs_dynevent	*dyn_event;
>   	char			*name;
>   	char			**synthetic_fields;
>   	char			**synthetic_args;
> @@ -719,6 +720,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
>   		synth->actions = action->next;
>   		action_free(action);
>   	}
> +	tracefs_dynevent_free(synth->dyn_event);
>   
>   	free(synth);
>   }
> @@ -889,6 +891,28 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
>   	return synth;
>   }
>   
> +static int alloc_synthetic_event(struct tracefs_synth *synth)
> +{
> +	char *synthetic_format;
> +	const char *field;
> +	int i;
> +
> +	synthetic_format = strdup("");
> +	if (!synthetic_format)
> +		return -1;
> +
> +	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
> +		field = synth->synthetic_fields[i];
> +		synthetic_format = append_string(synthetic_format, " ", field);
> +	}
> +
> +	synth->dyn_event = dynevent_alloc(TRACEFS_DYNEVENT_SYNTH, NULL,
> +					  synth->name, NULL, synthetic_format);
> +	free(synthetic_format);
> +
> +	return synth->dyn_event ? 0 : -1;
> +}
> +
>   /**
>    * tracefs_synth_alloc - create a new tracefs_synth instance
>    * @tep: The tep handle that holds the events to work on
> @@ -1609,38 +1633,6 @@ int tracefs_synth_save(struct tracefs_synth *synth,
>   	return 0;
>   }
>   
> -static char *create_synthetic_event(struct tracefs_synth *synth)
> -{
> -	char *synthetic_event;
> -	const char *field;
> -	int i;
> -
> -	synthetic_event = strdup(synth->name);
> -	if (!synthetic_event)
> -		return NULL;
> -
> -	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
> -		field = synth->synthetic_fields[i];
> -		synthetic_event = append_string(synthetic_event, " ", field);
> -	}
> -
> -	return synthetic_event;
> -}
> -
> -static int remove_synthetic(const char *synthetic)
> -{
> -	char *str;
> -	int ret;
> -
> -	ret = asprintf(&str, "!%s", synthetic);
> -	if (ret < 0)
> -		return -1;
> -
> -	ret = tracefs_instance_file_append(NULL, "synthetic_events", str);
> -	free(str);
> -	return ret < 0 ? -1 : 0;
> -}
> -
>   static int remove_hist(struct tracefs_instance *instance,
>   		       struct tep_event *event, const char *hist)
>   {
> @@ -1919,7 +1911,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
>   int tracefs_synth_create(struct tracefs_instance *instance,

I wonder is it really necessary this function to take 'tracefs_instance' as argument?

I remember from conversations with Steven that setting the histograms/triggers in the top instance will have the same 
effect. Or maybe I am wrong? The same question applies for the 'destroy' API.

Thanks!
Yordan


>   			 struct tracefs_synth *synth)
>   {
> -	char *synthetic_event;
>   	char *start_hist = NULL;
>   	char *end_hist = NULL;
>   	int ret;
> @@ -1937,14 +1928,10 @@ int tracefs_synth_create(struct tracefs_instance *instance,
>   	if (verify_state(synth) < 0)
>   		return -1;
>   
> -	synthetic_event = create_synthetic_event(synth);
> -	if (!synthetic_event)
> +	if (!synth->dyn_event && alloc_synthetic_event(synth))
> +		return -1;
> +	if (!tracefs_dynevent_create(synth->dyn_event))
>   		return -1;
> -
> -	ret = tracefs_instance_file_append(NULL, "synthetic_events",
> -					   synthetic_event);
> -	if (ret < 0)
> -		goto free_synthetic;
>   
>   	start_hist = create_hist(synth->start_keys, synth->start_vars);
>   	start_hist = append_filter(start_hist, synth->start_filter,
> @@ -1980,9 +1967,7 @@ int tracefs_synth_create(struct tracefs_instance *instance,
>    remove_synthetic:
>   	free(end_hist);
>   	free(start_hist);
> -	remove_synthetic(synthetic_event);
> - free_synthetic:
> -	free(synthetic_event);
> +	tracefs_dynevent_destroy(synth->dyn_event, false);
>   	return -1;
>   }
>   
> @@ -2007,7 +1992,6 @@ int tracefs_synth_create(struct tracefs_instance *instance,
>   int tracefs_synth_destroy(struct tracefs_instance *instance,
>   			  struct tracefs_synth *synth)
>   {
> -	char *synthetic_event;
>   	char *hist;
>   	int ret;
>   
> @@ -2041,11 +2025,7 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
>   	ret = remove_hist(instance, synth->start_event, hist);
>   	free(hist);
>   
> -	synthetic_event = create_synthetic_event(synth);
> -	if (!synthetic_event)
> -		return -1;
> -
> -	ret = remove_synthetic(synthetic_event);
> +	ret = tracefs_dynevent_destroy(synth->dyn_event, false);
>   
>   	return ret ? -1 : 0;
>   }
> @@ -2067,7 +2047,7 @@ int tracefs_synth_show(struct trace_seq *seq,
>   		       struct tracefs_instance *instance,
>   		       struct tracefs_synth *synth)
>   {
> -	char *synthetic_event = NULL;
> +	bool new_event = false;
>   	char *hist = NULL;
>   	char *path;
>   	int ret = -1;
> @@ -2082,16 +2062,19 @@ int tracefs_synth_show(struct trace_seq *seq,
>   		return -1;
>   	}
>   
> -	synthetic_event = create_synthetic_event(synth);
> -	if (!synthetic_event)
> -		return -1;
> +	if (!synth->dyn_event) {
> +		if (alloc_synthetic_event(synth))
> +			return -1;
> +		new_event = true;
> +	}
>   
>   	path = trace_find_tracing_dir();
>   	if (!path)
>   		goto out_free;
>   
> -	trace_seq_printf(seq, "echo '%s' > %s/synthetic_events\n",
> -			 synthetic_event, path);
> +	trace_seq_printf(seq, "echo '%s%s %s' > %s/%s\n",
> +			 synth->dyn_event->prefix, synth->dyn_event->event,
> +			 synth->dyn_event->format, path, synth->dyn_event->trace_file);
>   
>   	tracefs_put_tracing_file(path);
>   	path = tracefs_instance_get_dir(instance);
> @@ -2116,10 +2099,18 @@ int tracefs_synth_show(struct trace_seq *seq,
>   			 hist, path, synth->end_event->system,
>   			 synth->end_event->name);
>   
> +	if (new_event) {
> +		tracefs_dynevent_free(synth->dyn_event);
> +		synth->dyn_event = NULL;
> +	}
> +
>   	ret = 0;
>    out_free:
> -	free(synthetic_event);
>   	free(hist);
>   	tracefs_put_tracing_file(path);
> +	if (new_event) {
> +		tracefs_dynevent_free(synth->dyn_event);
> +		synth->dyn_event = NULL;
> +	}
>   	return ret;
>   }
> 
