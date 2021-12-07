Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE16C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 13:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhLGNzp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 08:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbhLGNzp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 08:55:45 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBA3C061746
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 05:52:15 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso1807570wml.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 05:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+ze8OZGauU9GnRaPV9vDwulGsjigTUSBiIkJE6s5Di4=;
        b=RJzEc+PJzwSK74ZWjeKn61fRIPq+wSwZTLSrv2PQyzbhht5Yqn+3UG8bPREUB0WAOB
         QmMoA4PzLj2MVNinlAwq3gfmMR10fluHkaQXDQFhXw4UuNBJzdy63GQgI6qD5bZvmX5R
         Jci8h0Dhn1EI/QQLkq6MMfvjIfPayt7qnUp3LKZirBq2OVKGcD/6aNkVBx6qoViJHjup
         dwszliJlhU61o1k5f/Wykjtyl4dIEQGg3+D87/YAoV3moGVHbk7rIwjPrHDa9LS9SXqC
         WQCkJREmF3ZD7nhMYUchRQkDFbG2hfvgwNpPvf3mNZbvF0iopPz2hb1LPRTdqVXLpOiV
         IhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+ze8OZGauU9GnRaPV9vDwulGsjigTUSBiIkJE6s5Di4=;
        b=zaLpIEYQ/LVniM85mD63zJqvvecN4Ey50I40VVW2+Z5gPeeaKy3O70YhQrEpSZwGIB
         2mwFklxkQ2EJDfS75fun5Fa9rlZqk9luEefEeXUcclncnJAb00OEikv8dsIML0XyQAWD
         RT1tiKE/fzYIWh4819kigfzQ6Ozy/UT5XmWSnbPVT/52mc7xMPWjWfEbAMizS4MuqEht
         nYLdXXSqpFYygApIhlcqpkA3b8gMfwWxO9KMZlAKCFEsgdCL89BcdU8oiZJR9K4m7yIU
         1E4YFWsxfKLzMrdgVsNtnDTUqyLkYg8XdseMLt6lZTvXjDtGrn7PjSZN5TKGPr42O0yX
         NefA==
X-Gm-Message-State: AOAM530W93eAC5xybZLdTFDWP2zadv3HT6vZrv5vFOi/2ozEbwZ7Zw7Y
        KXypyzDp3OEQ501QB9JwKIMyKVf6LG0=
X-Google-Smtp-Source: ABdhPJy8Rq5o70BkGh1VdnHwft2Ncynm2u6o9fUc5/V1YZq+ftRRiRzrZ9VNVGiVyefgEeB56u/1+w==
X-Received: by 2002:a05:600c:511c:: with SMTP id o28mr7367158wms.96.1638885133661;
        Tue, 07 Dec 2021 05:52:13 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b14sm17564137wrd.24.2021.12.07.05.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 05:52:13 -0800 (PST)
Message-ID: <f3ddd3e1-ca1f-89e7-a587-27c10dd47097@gmail.com>
Date:   Tue, 7 Dec 2021 15:52:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/3] libtracefs: New API for getting the raw format of a
 histogram
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211206150855.361202-1-y.karadz@gmail.com>
 <20211206150855.361202-2-y.karadz@gmail.com>
 <20211206185843.6b721000@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211206185843.6b721000@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 7.12.21 г. 1:58 ч., Steven Rostedt wrote:
> On Mon,  6 Dec 2021 17:08:53 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +/*
>> + * tracefs_hist_echo_fmt - show the raw format of the histogram
>> + * @seq: A trace_seq to store the format string
>> + * @hist: The histogram to read format from
>> + *
>> + * This show the raw format that describes the state of the histogram.
>> + *
>> + * Returns the size of the format string on succes -1 on error.
>> + */
>> +int tracefs_hist_echo_fmt(struct trace_seq *seq,
>> +			  struct tracefs_instance *instance,
>> +			  struct tracefs_hist *hist)
>> +{
>> +	const char *event = hist->event_name;
>> +	const char *system = hist->system;
>> +	int fmt_size;
>> +	char *path;
>> +	char *fmt;
>> +
>> +	path = tracefs_event_get_file(instance, system, event, "trigger");
>> +	if (!path)
>> +		return -1;
>> +
>> +	fmt = tracefs_event_file_read(instance, system, event, path,
>> +				      &fmt_size);
> 
> First, path should just be "trigger" as tracefs_event_file_read() is a
> short cut to get to the files for the event. I'm surprised that this even
> worked.
> 
>> +	if (!fmt)
>> +		return -1;
>> +
>> +	trace_seq_puts(seq, fmt);
> 
> Second, just reading the trigger file is not useful, as the trigger file
> holds triggers, not just histograms. And you can have more than one
> histogram in the trigger file. For instance, I could do:
> 
>   # cd /sys/kernel/debug/tracing/events/sched/sched_switch
>   # echo stacktrace > trigger
>   # echo 'hist:keys=prev_pid' >> trigger
>   # echo 'hist:keys=next_pid' >> trigger
>   # cat trigger
> stacktrace:unlimited
> hist:keys=prev_pid:vals=hitcount:sort=hitcount:size=2048 [active]
> hist:keys=next_pid:vals=hitcount:sort=hitcount:size=2048 [active]
> 
> Is this really what you want?
> 

No, it isn’t :( I have to rethink this.

Thanks a lot!
Y.


> -- Steve
> 
>> +	tracefs_put_tracing_file(path);
>> +
>> +	return fmt_size;
>> +}
>> +
>>   /*
>>    * tracefs_hist_command - Create, start, pause, destroy a histogram for an event
>>    * @instance: The instance the histogram will be in (NULL for toplevel)
> 
