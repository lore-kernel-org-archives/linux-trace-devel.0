Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719A8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhLHNfB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhLHNfB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:35:01 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370FDC061746
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Dec 2021 05:31:29 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z5so8462921edd.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 08 Dec 2021 05:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CJnUdPrqHD7CPFmocJmtrpyCP7OKgMzgBBNSNRvolq0=;
        b=WohD74pV3KGCjOJ83/2vNYCnY5DMZdg6P+WHGrL1EAszqGdHqgI0/noiVs4OSpwE2P
         wO7os9Tz09qhrwJ1sR22jYK+N70xpriM+ruRm3tqhdFp7MBPxscfZPY30os/LrWtHOzy
         BVpAgWk+uyuCDzblcIUN9qV8DjIB9AJj1GbKAe5esXTKZAsdXUJOgOAXtpjTliQFKRtn
         Ge7R3J3gZiX3LYXog4YqRBXOtrX1oNyie3gJdWLAIq5cTaG/ZFPRQ8vTeJYEYmzdyg7d
         RMpD739CzMtKxsdjnTgjZG9puf2ct5i3yaI9XBiFx/XqM15prCONmWCMltCYTDH46LiK
         FDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CJnUdPrqHD7CPFmocJmtrpyCP7OKgMzgBBNSNRvolq0=;
        b=rdlq+6Nmny/FLky/m2MXpXGStc7xuG5TPHi1/AJVk6TihMXYoDMVOYgLrlHTWknXEy
         jhIWl51KJRyNyQMjBMC9OMXr0UeZB+doiMg+D8/31wosTYQzlaLfoK+QFo2oNEWnc33M
         z2tLuhWXMTAta5qRdZwR4lGxoHlu9+5ac5Jr+slBm+CUN6nfxk6ZBUIr967hWt5PSUFL
         mCpglNzckukg6LACSfol4lETx0wi0/YQ+XrVZGl7nIFjQeTAgCPXCodqXWRfykeT7Fkw
         vjcpTj1i261Fw2NYjTjqw5TM70YLufur0WfWtfmpV2DlljRYMiawXXgQQKlBUX9Gq/S+
         1MzQ==
X-Gm-Message-State: AOAM531UG2YTLSpZolv0gB66aPgJwxCQ/cgka8pGjmIJsLpAfyLZyE79
        0NN45AHdhnkP4VhYFLtaswP8OCNUwmI=
X-Google-Smtp-Source: ABdhPJy7U4EsRLp2Oi3jQZ1pI7JYXjk+2Ej/t7N71BtoCxIOeBQuNkI24AUAEmMAeE2/RsjtOqvdvA==
X-Received: by 2002:a05:6402:26c5:: with SMTP id x5mr20211696edd.198.1638970287648;
        Wed, 08 Dec 2021 05:31:27 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id h7sm2415497ede.40.2021.12.08.05.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 05:31:27 -0800 (PST)
Message-ID: <85fef0bf-879d-06a9-f2fd-de2d0171fb1d@gmail.com>
Date:   Wed, 8 Dec 2021 15:31:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [RFC PATCH] libtracefs: New APIs for getting the raw format of
 synth event
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211206151352.361507-1-y.karadz@gmail.com>
 <20211207171351.2928503d@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211207171351.2928503d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 8.12.21 г. 0:13 ч., Steven Rostedt wrote:
>>   int tracefs_synth_create(struct tracefs_synth *synth)
>>   {
>> -	char *start_hist = NULL;
>> -	char *end_hist = NULL;
>>   	int ret;
>>   
>>   	if (!synth) {
>> @@ -1996,40 +2067,35 @@ int tracefs_synth_create(struct tracefs_synth *synth)
>>   	if (tracefs_dynevent_create(synth->dyn_event))
>>   		return -1;
>>   
>> -	start_hist = create_hist(synth->start_keys, synth->start_vars);
>> -	start_hist = append_filter(start_hist, synth->start_filter,
>> -				   synth->start_parens);
>> -	if (!start_hist)
>> +	synth->start_hist = create_hist(synth->start_keys, synth->start_vars);
>> +	synth->start_hist = append_filter(synth->start_hist, synth->start_filter,
>> +					  synth->start_parens);
>> +	if (!synth->start_hist)
>>   		goto remove_synthetic;
>>   
>> -	end_hist = create_end_hist(synth);
>> -	end_hist = append_filter(end_hist, synth->end_filter,
>> -				   synth->end_parens);
>> -	if (!end_hist)
>> +	synth->end_hist = create_end_hist(synth);
>> +	synth->end_hist = append_filter(synth->end_hist, synth->end_filter,
>> +					synth->end_parens);
>> +	if (!synth->end_hist)
>>   		goto remove_synthetic;
>>   
>>   	ret = tracefs_event_file_append(synth->instance, synth->start_event->system,
>>   					synth->start_event->name,
>> -					"trigger", start_hist);
>> +					"trigger", synth->start_hist);
>>   	if (ret < 0)
>>   		goto remove_synthetic;
>>   
>>   	ret = tracefs_event_file_append(synth->instance, synth->end_event->system,
>>   					synth->end_event->name,
>> -					"trigger", end_hist);
>> +					"trigger", synth->end_hist);
>>   	if (ret < 0)
>>   		goto remove_start_hist;
>>   
>> -	free(start_hist);
>> -	free(end_hist);
>> -
>>   	return 0;
>>   
>>    remove_start_hist:
>> -	remove_hist(synth->instance, synth->start_event, start_hist);
>> +	remove_hist(synth->instance, synth->start_event, synth->start_hist);
>>    remove_synthetic:
>> -	free(end_hist);
>> -	free(start_hist);
>>   	tracefs_dynevent_destroy(synth->dyn_event, false);
> I just realized that on error, we do not free the synthetic event
> descriptor. So there is a memory leak.
> 

Do we need to free the synthetic event here?

The event gets allocated with 'tracefs_synth_alloc()' and the user is responsible for calling 'tracefs_synth_free()' in 
order to free the memory.
The fact that 'tracefs_synth_create()' may fail doesn't change this.

Thanks!
Yordan



> Also, I'm thinking that the specific functions for destroying the synthetic
> events and such, should live here, and trace-dynevents.c should call them.
> 
> Because all the management for synthetic events should live in this file
> (or go to its own file).
> 
> -- Steve
> 
> 
