Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21120C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 11:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356454AbiBULe1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 06:34:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347794AbiBULe1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 06:34:27 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3AFDF35
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 03:34:04 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id bq11so7399301edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 03:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=o7GXRCuZlER8Ar+1oOiBrEkui4Ro+9Sg1FK7J8tsb94=;
        b=AzpPh18q3GfFyYm3zWvfQBADp2F8u+rqDZUt/Ru9rWYNUucp3ZaWeJA42HaPIFwG5q
         THvrMmCJG7W3XL10oTuIhBUs50RGD/yEysjJvZsReRVeyM2scVAeeYEifaO8Awz/Usov
         TtGUe89BD1Z8CK409/Twrv8xbnnPnW9AD60T11sw9s4+AdvZ+u54KfSRrHRio57a1ysh
         IXbBRNzr/p7KvW9uzmo7HjD+QIZxxqbywtVFJio7wqcXXywjjG9cjrbNU+PtkSQyVGi/
         BsZI2JVE6q76GV9f2HFQvXK2QlccFZ1Kun7gHPUhhkBGUm0fp/mllrly7KMoe/BHN/i2
         5iCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o7GXRCuZlER8Ar+1oOiBrEkui4Ro+9Sg1FK7J8tsb94=;
        b=ko5DUuoYyt6kA0WY5nSzoU177TbBp1nm94McKesvtXYTEUUkyAjwoZGWY+PCQoQSWd
         r4aHoaYmv4sHOJMBgIKTVvzCJJrTCbL+xj2Z8VESZ8izsw7FH9o9FPLw8uMrCW9K0XHN
         ksMDiSjIdC1ShNpc6uVd+KZw0GVVI2yJ2Irzk656/D0GMtLEsSYoarl1dxDuedaLtTbc
         vDspBMBDDbCyyHMjq1FN6EIlTHOLznnAypJnsft0w4OelEd3GFoSuxqMv1cXSRIT/qe+
         FVB355LEKXpxSSlgkNT562xhuj62iMwo6YOh7/v8+HLX8ixkjVKAGSOw4hgVRYtRvSBh
         bsUA==
X-Gm-Message-State: AOAM530ga4N6REL/h9nCuKjyZ2Y8dO4/XsBNed1AeX4TBLWrGwGxZkyG
        HnAvndcmsr/e3+K75oQa7JukVq/OX7o=
X-Google-Smtp-Source: ABdhPJyngIZFrLA/YFasHKQE8CT2XE6UcSpfpfTauBxNbTLoL5lN++OkS4fi/HrG2ND3EgCxvoX6bQ==
X-Received: by 2002:a05:6402:847:b0:412:f151:6ad1 with SMTP id b7-20020a056402084700b00412f1516ad1mr6815986edz.36.1645443242537;
        Mon, 21 Feb 2022 03:34:02 -0800 (PST)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id el9sm5194505ejc.168.2022.02.21.03.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 03:34:02 -0800 (PST)
Message-ID: <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
Date:   Mon, 21 Feb 2022 13:34:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Content-Language: en-US
To:     Beau Belgrave <beaub@linux.microsoft.com>, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220218225058.12701-2-beaub@linux.microsoft.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220218225058.12701-2-beaub@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.02.22 г. 0:50 ч., Beau Belgrave wrote:
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index bf157e1..e768cba 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -119,4 +119,28 @@ int trace_rescan_events(struct tep_handle *tep,
>   struct tep_event *get_tep_event(struct tep_handle *tep,
>   				const char *system, const char *name);
>   
> +/* Internal interface for ftrace user events */
> +
> +struct tracefs_user_event_group;
> +
> +struct tracefs_user_event
> +{
> +	int write_index;
> +	int status_index;
> +	int iovecs;
> +	int rels;
> +	int len;
> +	struct tracefs_user_event_group *group;
> +	struct tracefs_user_event *next;
> +};
> +
> +struct tracefs_user_event_group
> +{
> +	int fd;
> +	int mmap_len;
> +	char *mmap;
> +	pthread_mutex_t lock;
> +	struct tracefs_user_event *events;
> +};
> +
>   #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 1848ad0..7871dfe 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -571,4 +571,64 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
>   struct tep_event *
>   tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
>   
> +/* User events */
> +enum tracefs_uevent_type {
> +	TRACEFS_UEVENT_END,
> +	TRACEFS_UEVENT_u8,
> +	TRACEFS_UEVENT_s8,
> +	TRACEFS_UEVENT_u16,
> +	TRACEFS_UEVENT_s16,
> +	TRACEFS_UEVENT_u32,
> +	TRACEFS_UEVENT_s32,
> +	TRACEFS_UEVENT_u64,
> +	TRACEFS_UEVENT_s64,
> +	TRACEFS_UEVENT_string,
> +	TRACEFS_UEVENT_struct,
> +	TRACEFS_UEVENT_varray,
> +	TRACEFS_UEVENT_vstring,
> +};
> +
> +enum tracefs_uevent_flags {
> +	/* None */
> +	TRACEFS_UEVENT_FLAG_NONE = 0,
> +
> +	/* When BPF is attached, use iterator/no copy */
> +	TRACEFS_UEVENT_FLAG_bpf_iter = 1 << 0,
> +};
> +
> +struct tracefs_uevent_item {
> +	/* Type of item */
> +	enum tracefs_uevent_type type;
> +
> +	/* Length of data, optional during register */
> +	int len;
> +
> +	union {
> +		/* Used during write */
> +		const void *data;
> +
> +		/* Used during register */
> +		const char *name;
> +	};
> +};
> +
> +struct tracefs_user_event;
> +struct tracefs_user_event_group;
> +

We've been trying to follow certain naming convention for the APIs and to provide similar usage patterns for all types 
of trace events that are supported by the library so far (dynamic, synthetic and histograms). If 'XXX' is the type of 
the event ('user_event' in your case), the pattern looks like this:

tracefs_XXX_alloc() - this constructor just allocates memory and initializes the descriptor object without modifying 
anything on the system. We allow for multiple constructor function, in the case when your objects has to many possible 
configurations and it is hard to do everything in a single API. Looking into your implementation, such constructor can 
do half of the work done in 'tracefs_user_event_group_create()'

int tracefs_XXX_create(struct tracefs_XXX *evt) - This is the API that actually adds your event on the system. Note that 
it takes just one argument that is the object itself. Again, looking into your implementation, this will combine the 
other half of tracefs_user_event_group_create() and tracefs_user_event_register().

int tracefs_XXX_destroy(struct tracefs_XXX *evt) This API removes your event from the system. The first argument is 
again the object. If needed, here you can use a second argument that is 'bool force'.

int tracefs_XXX_free(struct tracefs_XXX *evt) - just to free the memory


> +struct tracefs_user_event_group *tracefs_user_event_group_create(void);
> +
> +void tracefs_user_event_group_close(struct tracefs_user_event_group *group);
> +
> +int tracefs_user_event_delete(const char *name);
> +
> +struct tracefs_user_event *
> +tracefs_user_event_register(struct tracefs_user_event_group *group,
> +			    const char *name, enum tracefs_uevent_flags flags,
> +			    struct tracefs_uevent_item *items);
> +
> +bool tracefs_user_event_test(struct tracefs_user_event *event);

And maybe "test" is redundant. You can do the check in tracefs_XXX_create() and return an error if it fails.

> +
> +int tracefs_user_event_write(struct tracefs_user_event *event,
> +			     struct tracefs_uevent_item *items);

The "write" is OK.

Maybe we can change 'tracefs_user_event' to 'tracefs_usrevent' since we already use 'tracefs_dynevent' for dynamic events.

What do you think?

Thanks!
Yordan

