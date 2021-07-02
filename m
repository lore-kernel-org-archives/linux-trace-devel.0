Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50190C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF8A61413
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhGBLmX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhGBLmX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:42:23 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6140AC061762
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jul 2021 04:39:51 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l1so6452464wme.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Jul 2021 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PN+Wzly7s5+NG1+ff+S5R1bOWK/3nKSPm0LsYuUasbg=;
        b=b4ggACICoSAVN+VUXn/hrDE7Cs1hsg4+qctByEppGpTI4A3sSAP5biMTW/Uh9Sr1LJ
         e3fK0u38ErLj7XJYYcN5I575KZUxlJcKWkxI/Wq2pXfeUdfyo7rxLxZx8yEFKk9zNDug
         QSTHtTsm7WxfoU1ZD7g+qX6YiVKQTei4ovlh4QhWlMVOt37QueG/CrIm146r3b/v1k0Z
         QLJt0Kr6DUhbTYeIacCqxgJPL2hpBs1TSOrQRLHlYNRR043lU34VQsZJI3BRfoYkAQ9A
         2GUo4aosGh+5PS6uKmQf+NTlDfPbxjZPBoBKn87q7b7n+vmpFfywgcMSUe8mkTk3hYMM
         LsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PN+Wzly7s5+NG1+ff+S5R1bOWK/3nKSPm0LsYuUasbg=;
        b=RqLhoSwMxIenqkgGZi3jTCyw8vohmC3zccSLbTFCIRlIXDm3eMbEzmHCglElftgi6x
         K9EATCL/8Q+g++YYZQRINSRxz+Gs1c5g8FAPpChUC+1zQtZJwSwkzD1++iLpUZ120ISa
         BxDW1p063kzmgH3Jmz9nWgP8ZJvS0sh2lwoI0nrfR+ocpA/zt3FnXjumyRqbnOeXDxxk
         QJMRjGKEqvjYG2qi0QtRJXcyqHvYboAtIBpKfA8y0Ipw89E3y938EQZy9CkYLWKfdEOZ
         ckE4Vc2z9P5r+JuSL5FG4ajKZRwzHMb8M9swQ65Lb/egdIJzADuQ9EC4WLc4RmCm8Kp3
         77WQ==
X-Gm-Message-State: AOAM531ut7NM17R7VU5z1q5ZDkEYa9hionfsYodsPW5KzLLL607Af1ST
        08WCXt9oH47LOxBx21+ckHqItcngLB8=
X-Google-Smtp-Source: ABdhPJyNy13ARXa5E7lbuKvSKKaaeVrGKQCPO7IAxEnF4tblTKOL2Q6lSzrZUEyyPiSGIx7M78mMqg==
X-Received: by 2002:a7b:c15a:: with SMTP id z26mr13470865wmi.109.1625225989344;
        Fri, 02 Jul 2021 04:39:49 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id t9sm3155926wmq.14.2021.07.02.04.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 04:39:48 -0700 (PDT)
Subject: Re: [PATCH v4 1/7] libtracefs: Implement tracefs_instances()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210702035443.154729-1-rostedt@goodmis.org>
 <20210702035443.154729-2-rostedt@goodmis.org>
 <4335f4d8-73eb-a2e4-f439-95cbe69acff2@gmail.com>
 <20210702073332.357ca775@rorschach.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <97c4e671-5ee9-3c1a-b957-1d0b6fbc0eb3@gmail.com>
Date:   Fri, 2 Jul 2021 14:39:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702073332.357ca775@rorschach.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.07.21 г. 14:33, Steven Rostedt wrote:
> On Fri, 2 Jul 2021 14:10:46 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>> +static int build_list(const char *name, void *data)
>>> +{
>>> +	struct instance_list *list = data;
>>> +	char **instances;
>>> +	int ret = -1;
>>> +
>>> +	if (!match(name, list->re))
>>> +		return 0;
>>> +
>>> +	instances = realloc(list->list, list->size + 2);
>>> +	if (!instances)
>>> +		goto out;
>>> +
>>> +	list->list = instances;
>> Hi Steven,
>>
>> I am not sure what was your original intention here, but this doesn't
>> seem to work properly. Maybe we need something like this:
>>
>> 	int size =  sizeof(*instances) * (list->size + 2);
>> 	instances = realloc(list->list, size);
> 
> Bah, that's what I get for trying to "multitask" while coding :-p
> That was suppose to be:
> 
> 	instances = realloc(list->list, sizeof(*instances) * (list->size + 2);
> 
> as you stated, but I'll keep it one line.
> 
>> 	if (!instances)
>> 		goto out;
>>
>> 	instances[list->size + 1] = NULL;

but you still need to make sure it is NULL terminated.
Y.

>>
>>
>>
>>
>>> +	list->list[list->size] = strdup(name);
>>> +	if (!list->list[list->size])
>>> +		goto out;
>>> +
>>> +	list->size++;
>>> +	ret = 0;
>>> +
>>> + out:
>>> +	list->failed = ret;
>>> +	return ret;
>>> +}
>>> +
>>> +/**
>>> + * tracefs_instances - return a list of instance names
>>> + * @regex: A regex of instances to filter on (NULL to match all)
>>> + *
>>> + * Returns a list of names of existing instances, that must be
>>> + * freed with tracefs_list_free(). Note, if there are no matches
>>> + * then an empty list will be returned (not NULL).
>>> + * NULL on error.
>>> + */
>>> +char **tracefs_instances(const char *regex)
>>> +{
>>> +	struct instance_list list = { .re = NULL, .list = NULL };
>>> +	regex_t re;
>>> +	int ret;
>>> +
>>> +	if (regex) {
>>> +		ret = regcomp(&re, regex, REG_ICASE|REG_NOSUB);
>>> +		if (ret < 0)
>>> +			return NULL;
>>> +		list.re = &re;
>>> +	}
>>> +
>>> +	ret = tracefs_instances_walk(build_list, &list);
>>> +	if (ret < 0 || list.failed) {
>>> +		tracefs_list_free(list.list);
>>> +		list.list = NULL;
>>> +	} else {
>>> +		if (!list.list) {
>>> +			/* No matches should produce an empty list */
>>> +			list.list = malloc(sizeof(*list.list));
>>> +			if (list.list)
>>> +				list.list[0] = NULL;
>>> +		}
>>
>> Or you can just do:
>> 				return calloc(1, sizeof(*list.list));
> 
> Which I do in tracefs_get_probes(), must have missed this one.
> 
> Will update, thanks for the review.
> 
> 
> -- Steve
> 
> 
>>
>> Thanks!
>> Yordan
>>
>>> +	}
>>> +	return list.list;
>>> +}
