Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435AEC04FCF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 13:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E892D61359
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 13:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhEJNaw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 09:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhEJMR5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 08:17:57 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD115C061345
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 05:15:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r9so24174307ejj.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 05:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pc2S4uwL6Mt4Kggne9XsxU49jJQ8xrgT+pYpHBv9UDY=;
        b=BD5IbhRSJ5RTSBs3+8Nsy0zjupOHOqdS5bIHEM4lCyNMz17TMv1/UTJSBIMu5NcdOg
         gTQmqC+M5LcEvgKLv9qpqCfXHscu93CJZFPeAX6rxeAlO/G28ePWOmEk8XHAJjBO3/Kd
         7WFtMg6TPRdnWUXIXT4sDuidYDASawHIWNmkC+4zXnAR3rPcwxnHVUuDocTPr2LcuO5b
         PFTCgjJbewC3ELH21U7kIcfqm5/2WhPOmdGbAoFSeq0ZfPgtZeyS8hdhndiWBocKOyNc
         kkyyfBr157iYiTVTQ7saIC1LP5TO+asSLf9sh4hilD/yVQO6Xra58qFlRKPmb6TyeF0i
         X7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pc2S4uwL6Mt4Kggne9XsxU49jJQ8xrgT+pYpHBv9UDY=;
        b=gGyNunDStU9y59ue1KLl/nVMyN16rDK3GI+d6i2Bs3ikPytjPpjcUjfHv+Kdrty0ll
         3y4gDz2wTQW4KS+nIn33cngUMypYKCWFMMYHjgC1n0FqWRkHZ+JkYN+dpUjb/zVjT7z0
         +V5Dscv6TJUKRJ/b+kZmQJOI2k4nyAUGHhX6td93tHw0EqGg7NbGHBKgGHtpTyoh0gBg
         9CtBcITEPef+JkC4lTdGtu/7TmnRKKkxVvYjRhvEI0aRaXsoM/LR3NaJ2vuDKmDTfLZl
         O6LmqduNAUO4aa30UcF2TefOUeT0fyk5EDArhu55QRL98cg9brB3ygoiqNHluUlN7UYi
         299A==
X-Gm-Message-State: AOAM530RfJdrM+MM3YeE6/qoV7QCTiVSY/qRyTr7D4w+1AkS7q+VR0RA
        Dj2r9dXI7T476QQJpREqbkZ+PlaOoZo=
X-Google-Smtp-Source: ABdhPJwo3yn1eHA2LEOmqqs0QOFyk5TyRlp2holYjysPOzDk8wxKSkePsnoU196LWSvV4Ai+fe2wcQ==
X-Received: by 2002:a17:906:4f91:: with SMTP id o17mr25406840eju.503.1620648958466;
        Mon, 10 May 2021 05:15:58 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id p14sm11081113eds.28.2021.05.10.05.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 05:15:58 -0700 (PDT)
Subject: Re: [PATCH v2 7/9] kernel-shark: Remove kvm_combo from the list of
 default plugins
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210428134730.187533-1-y.karadz@gmail.com>
 <20210428134730.187533-8-y.karadz@gmail.com>
 <20210506142520.2f4eabe2@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <89a310d6-8332-67d1-13a6-790b4f4a592b@gmail.com>
Date:   Mon, 10 May 2021 15:15:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210506142520.2f4eabe2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 6.05.21 г. 21:25, Steven Rostedt wrote:
> On Wed, 28 Apr 2021 16:47:28 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The "kvm_combo" plugin is still under tests and is yet to be added to
>> KernelShark. For the moment we remove it from the list of default
>> plugins for "tep" data, so that no warning message is being printed.
> 
> I'm looking forward to where we can put this back to the default.
> 
> Which reminds me. I see the other two plugins you posted patches for,
> have you posted the KVM combo one yet?

Hi Steven,
KVM combo is almost ready for posting. It is coming soon.
Y.

> 
> -- Steve
> 
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/libkshark-tepdata.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
>> index bc5babb..f7cd083 100644
>> --- a/src/libkshark-tepdata.c
>> +++ b/src/libkshark-tepdata.c
>> @@ -1210,7 +1210,6 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
>>   const char *tep_plugin_names[] = {
>>   	"sched_events",
>>   	"missed_events",
>> -	"kvm_combo",
>>   };
>>   
>>   /**
> 
