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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC62C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83C7F613F4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhGBLST (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhGBLST (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:18:19 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04C1C061762
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jul 2021 04:15:46 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a8so337305wrp.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Jul 2021 04:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aIIejwdHeDDVAQutFVPUTVEmKRtuiDh0GaaeD6G2cSc=;
        b=gfjKhgJsVMEYacTbSHix3DLKeYj/33ADaf+jRY2H7Ka/U9GSJKfMvVJJFdpdSLlheW
         RiWygo3cUZ7N+xfniAeUOXYF4/SR0pgNmHhi9m9KpmdpOz6z0l3czvGo7McLgMIljp+5
         zU7zYgi5o+RPAQdG33UiMA0bFtW8NlshJI2DkIXKdRtlr2UmSDqpg04PqWDix7RH0C4N
         3LE7L6VqfX06OVP7LmftFvhgzzrNmb+wwPmhbeLfrAyt6OUzCI8z4idFKZcXE6Q1Uvio
         Qyid9+mJ/bHduPrh2XRq8YYrd/uf3hYwZvKECJpcmz8BgNL4mr8hwq0IHs1vlnRb+OqL
         /sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIIejwdHeDDVAQutFVPUTVEmKRtuiDh0GaaeD6G2cSc=;
        b=hdI10XxhFVw9ZDgPp5BkWSHs8/+EUu/nnp8sDP9eTyouxqZDo0KFkQt7llHtSAfWHO
         3Y22da8fxqyvH9TQI14IUycZ9owt/PRCSOC5SyOWW/NItT72W3JrsBlGEPCVsT2fwMNz
         yj15bRqeN935Rx6gDmezdew81MSQ//ACYMy55UuJpUqc5ERBZHnO8EY03JVxr/jM8aw1
         6f9+JsZSR8Gp1002jcmBV89wy2TUJLrKXYOCdAiEkouv1cSZtI2eeDnlC5KobClXxa5/
         MKUN/Y/pjsyJYpZ6aBBBNMM+mb6YkdC6QNk1wHzcsIrEChql+8Q8VYSSoCYvqaXg+nSz
         ErqA==
X-Gm-Message-State: AOAM533rOuZPfGT0ZJvKkcUL9H28G4yNFio/P/1d9KezoJHPhLi+uAsD
        ahdM3AW5ayk1sN40PZb9MYDcX50QkYs=
X-Google-Smtp-Source: ABdhPJxxVjt18YalzozWIfOL2/iDku5SepByPAveYkR49+IRRaZm9BGh8uy8wN+mQjNpNICOGwTthg==
X-Received: by 2002:a5d:64ab:: with SMTP id m11mr5334312wrp.336.1625224545060;
        Fri, 02 Jul 2021 04:15:45 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id s7sm2864761wrp.97.2021.07.02.04.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 04:15:44 -0700 (PDT)
Subject: Re: [PATCH v4 5/7] libtracefs: Implement tracefs_kprobe_clear_all()
 to remove all kprobes
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20210702035443.154729-1-rostedt@goodmis.org>
 <20210702035443.154729-6-rostedt@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e01fb2ef-a51f-f573-3869-829dd93f777d@gmail.com>
Date:   Fri, 2 Jul 2021 14:15:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702035443.154729-6-rostedt@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.07.21 г. 6:54, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> A call to tracefs_kprobe_clear_all() will attempt to disable all kprobes. If
> any kprobe is set, and the @force parameter is set, it will fail with
> errno set to EBUSY. If @force is set, then it will attempt to disable all
> the defined kprobe events and then clear it.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   include/tracefs.h     |   1 +
>   src/tracefs-kprobes.c | 103 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 104 insertions(+)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 5f59c480d572..3b57c596feab 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -220,4 +220,5 @@ int tracefs_kprobe_raw(const char *system, const char *event,
>   int tracefs_kretprobe_raw(const char *system, const char *event,
>   			  const char *addr, const char *format);
>   char **tracefs_get_kprobes(void);
> +int tracefs_kprobe_clear_all(bool force);
>   #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
> index e875d6e8a65f..fe61a25baa10 100644
> --- a/src/tracefs-kprobes.c
> +++ b/src/tracefs-kprobes.c
> @@ -169,3 +169,106 @@ char **tracefs_get_kprobes(void)
>   	list = NULL;
>   	goto out;
>   }
> +
> +struct instance_list {
> +	struct instance_list	*next;
> +	struct tracefs_instance	*instance;
> +};

This is not used in this source file. I see that it was moved to 
tracefs-instance.c

Thanks!
Y.

> +
> +static void disable_events(const char *system, const char *event,
> +			   char **list)
> +{
> +	struct tracefs_instance *instance;
> +	int i;
> +
> +	/*
> +	 * Note, this will not fail even on error.
> +	 * That is because even if something fails, it may still
> +	 * work enough to clear the kprobes. If that's the case
> +	 * the clearing after the loop will succeed and the function
> +	 * is a success, even though other parts had failed. If
> +	 * one of the kprobe events is enabled in one of the
> +	 * instances that fail, then the clearing will fail too
> +	 * and the function will return an error.
> +	 */
> +
> +	tracefs_event_disable(NULL, system, event);
> +	/* No need to test results */
> +
> +	if (!list)
> +		return;
> +
> +	for (i = 0; list[i]; i++) {
> +		instance = tracefs_instance_alloc(NULL, list[i]);
> +		/* If this fails, try the next one */
> +		if (!instance)
> +			continue;
> +		tracefs_event_disable(instance, system, event);
> +		tracefs_instance_free(instance);
> +	}
> +	return;
> +}
> +
> +/**
> + * tracefs_kprobe_clear_all - clear kprobe events
> + * @force: Will attempt to disable all kprobe events and clear them
> + *
> + * Will remove all defined kprobe events. If any of them are enabled,
> + * and @force is not set, then it will error with -1 and errno to be
> + * EBUSY. If @force is set, then it will attempt to disable all the kprobe
> + * events in all instances, and try again.
> + *
> + * Returns zero on success, -1 otherwise.
> + */
> +int tracefs_kprobe_clear_all(bool force)
> +{
> +	char **instance_list;
> +	char **kprobe_list;
> +	char *saveptr;
> +	char *system;
> +	char *kprobe;
> +	char *event;
> +	int ret;
> +	int i;
> +
> +	ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
> +	if (!ret)
> +		return 0;
> +
> +	if (!force)
> +		return -1;
> +
> +	kprobe_list = tracefs_get_kprobes();
> +	if (!kprobe_list)
> +		return -1;
> +
> +	instance_list = tracefs_instances(NULL);
> +	/*
> +	 * Even if the above failed and instance_list is NULL,
> +	 * keep going, as the enabled event may simply be in the
> +	 * top level.
> +	 */
> +
> +	for (i = 0; kprobe_list[i]; i++) {
> +		kprobe = kprobe_list[i];
> +
> +		system = strtok_r(kprobe, "/", &saveptr);
> +		if (!system)
> +			goto out;
> +
> +		event = strtok_r(NULL," ", &saveptr);
> +		if (!event)
> +			goto out;
> +
> +		disable_events(system, event, instance_list);
> +
> +		ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
> +		/* On success stop the loop */
> +		if (!ret)
> +			goto out;
> +	}
> + out:
> +	tracefs_list_free(instance_list);
> +	tracefs_list_free(kprobe_list);
> +	return ret;
> +}
> 
