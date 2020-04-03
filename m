Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14C3C43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 15:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1BB2077D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 15:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t619HVV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404011AbgDCPJz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:09:55 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39201 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403795AbgDCPJz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 11:09:55 -0400
Received: by mail-lf1-f68.google.com with SMTP id h6so6090677lfp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Apr 2020 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hYuLoB4sDiQKAJCGM09+MFWPNK0o1Oo0enrUbbTIV9c=;
        b=t619HVV4n5XMA8+BOXMI1pVRRff1/pfHw9OICzSh5vzuYriQJS5KrUcCeF5QvS1ry4
         4H1jEGIq1ygrHzOVs7m0AEWtrZU0mr2nYUMaOvpqxhfDDfdveXQRo66xVDF6yP1PITxq
         SzIAPd6RDOn1gOe0bVolw5OsaBHdxgGXW5SSafwVxUoNf3hNbIPYP3aWCZNEEd04JmW6
         /OKmSYZH5X6zQNMFKC9pUouemS5UH/2xZs04BCo8M1EC1Xc90suBa+g2X37zaCBPh5am
         keOutdCwYLO+/3VTuZhJ+l4JgB2hd1K2At3XLCklwDisicybU3qFMPoU+vhYzU+hy8ct
         pEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hYuLoB4sDiQKAJCGM09+MFWPNK0o1Oo0enrUbbTIV9c=;
        b=FmIt3eb0/wOGJVlc0N118GBt+/NsGPrE1aJptX69OyBmxwQ/9RGHAZ6Skd2RaGVgHJ
         /VuZAF+EXap9a0Kx2yoVGkmPTaJ8LW3ROf9bUXf4WDlsX+DT9gG+Gi6mKVxh8wedr2Sc
         5k2DDz+bR0dSQzPRL9nUcf1CtfUPVn+acMHAWEGJeszXFbjqx8QSQjhvCoEeeb454FDq
         4iJguNZzk5RGKb6rj+Vqr5cmKSI09eMq92eBTnA1TsN8lB0I2Ms28osl7oy3poo8C6sa
         2mkJ2L4nwbe6zkfy5k/5Caorn2P3z2JtVOzdQQAEgAJkMv04+mtS+MeCTpwkpZZW8YUj
         y37w==
X-Gm-Message-State: AGi0PuYZ2Wq8ZjrEXbldh0rLU0ryaxdAeiWDemLmTHkJiglyG50e0kwd
        Cyt/Lq1eMBmbMnWLWWEJLaSHbQNp
X-Google-Smtp-Source: APiQypJ5z6QSfoy1SljAoOKpBFKKdT+4pEkmUoUtzPS/cr8Arh/vCMHu0DCPF7piJT/YD0t6twvkdQ==
X-Received: by 2002:ac2:46d3:: with SMTP id p19mr5757585lfo.125.1585926591939;
        Fri, 03 Apr 2020 08:09:51 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id d19sm4997751lji.95.2020.04.03.08.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 08:09:51 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open guest
 tracing file
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20200401164509.191494-1-tz.stoyanov@gmail.com>
 <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com>
 <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5b55ebc5-d682-f934-a643-c0fe65fba003@gmail.com>
Date:   Fri, 3 Apr 2020 18:09:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3.04.20 г. 15:26 ч., Tzvetomir Stoyanov wrote:
> On Fri, Apr 3, 2020 at 2:39 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
>>
>>
>>
>> On 1.04.20 г. 19:45 ч., Tzvetomir Stoyanov (VMware) wrote:
>>> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
>>>
>>> The new tracecmd API tracecmd_open_merge() is used to open guest
>>> tracing file and synchronize it to the host file.
>>> This change is for testing purposes only, to test the new per CPU
>>> timestamps synchronization logic.
>>> It assumes that the stream with id 0 is the host one, and all others are
>>> guest streams.
>>> This change depends on commit:
>>>    "trace-cmd: Add new API to merge two trace files"
>>> where the new tracecmd API is introduced.
>>>
>>> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
>>> ---
>>>    src/libkshark-tepdata.c | 13 +++++++++++--
>>>    1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
>>> index 8678e12..b80b945 100644
>>> --- a/src/libkshark-tepdata.c
>>> +++ b/src/libkshark-tepdata.c
>>> @@ -1008,8 +1008,17 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
>>>        tep_handle = calloc(1, sizeof(*tep_handle));
>>>        if (!tep_handle)
>>>                return -EFAULT;
>>> -
>>> -     tep_handle->input = tracecmd_open(file);
>>
>> Hi Ceco,
>>
>> Is it possible to avoid the hard-coded ID number of the primary stream
>> (zero in this case)?
> 
> Yes, the first version of the patch is more a POC, to test the new
> tracecmd_open_merge() API.
> 
>>
>> Maybe we can add data field to "struct tepdata_handle" that can be used
>> to indicate if the stream is "primary" or not. Note that "struct
>> tepdata_handle" is defined only for "libkshark-tepdata.c".
> 
> I think a new "unsigned int flags" member should be added to
> struct kshark_data_stream;
> and flags should indicate if the stream is primary or not, depending
> on the way the file is loaded:
>   using "-i" option, or "File -> Open" from the menu - primary
>   using "-a" option, or "File -> Append" from the menu - secondary
>

Maybe it has to be a bit more sophisticated. Does the "primary" stream 
know how to recognize its "secondary" streams?


>>
>> Also do we consider a case when we will need to load more than one
>> "primary" stream?
> 
> In the host - guest tracing, there is no use case with more than one
> primary stream,
> but may be there could be other use cases where more than one primary
> stream will
> be needed ?
> 
> Is it possible to append more than one secondary files, using the
> current KernelShark 2 ?
> I tried appending two files, specifying "-a" option twice, but only
> the first "-a" file was appended.
Yes, this can be done from the menus, but you are right that something 
goes wrong when trying to do this from the command line. I will 
investigate and will try to get it fixed.

Thanks!
Yordan

> 
>>
>> Thanks!
>> Yordan
>>
>>
>>> +     if (stream->stream_id > 0) {
>>> +             struct kshark_data_stream *primary;
>>> +
>>> +             primary = kshark_get_data_stream(kshark_ctx, 0);
>>> +             if (primary && primary->file)
>>> +                     tep_handle->input = tracecmd_open_merge(file,
>>> +                                                             primary->file);
>>> +             else
>>> +                     tep_handle->input = tracecmd_open(file);
>>> +     } else
>>> +             tep_handle->input = tracecmd_open(file);
>>>        if (!tep_handle->input) {
>>>                free(tep_handle);
>>>                stream->interface.handle = NULL;
>>>
> 
> 
> 
