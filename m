Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B966FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9436161268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhKKS1c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 13:27:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232930AbhKKS1b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 13:27:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636655081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/Sdnjifv9+yBcE70YIvCUcROjqMP8PHQEnk/+4Dq6o=;
        b=FmMtPpq93UmO0sVPGNx4Kbe6ElamJtt2Eep982JjcLw5CHx6YW+aOeaIet3vP7Mg8+VUKD
        94y3EOTGyqOKTqjMV7+7T/xPjYktSOMGSAej9qkN9KTEHxbXhWHKAZ9gj0A4C8tHOM0fdS
        Z73q6hoXnnVe3VFmWXWwlv0tCwbr63g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-2wiIz7xONNGKtIMLktXIMA-1; Thu, 11 Nov 2021 13:24:40 -0500
X-MC-Unique: 2wiIz7xONNGKtIMLktXIMA-1
Received: by mail-ed1-f71.google.com with SMTP id w26-20020a056402071a00b003e28a389d04so6117469edx.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 10:24:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o/Sdnjifv9+yBcE70YIvCUcROjqMP8PHQEnk/+4Dq6o=;
        b=yH8dSZ2Hncv0XO359Ov+KmavcC5plMjyrUQP2Cf3IwasoSMLM+BKuaAJw4QxcyIrEW
         Zo0zmVuvAp3QWUKdm2+kK/+JTNKVkARCZbMHTrmByj9JqDrVTWo8M6YymHK3+9ypmA2D
         aa94X7ikINKIGskePnG/kFWE8mhar0t6UUtSxlWkkr3DQSOgoKrntmo1aMfXdU3N4jNf
         9bAHEf3G/DJx5tsYhBTxKQtpxYYT6HBM+MxQWXCaNvOgO/C/ZoiGSMhEa2z2RyCij0za
         gWgqKrARXQQ5Am0CdRMWD/Wi2wYbMNoN/BGKigBQt3w6du3zxDriw0sEvfDwNxvRPkQ2
         rmGg==
X-Gm-Message-State: AOAM533phIoxhpugrXbQkaqWvGCRNuQdGNonRcKcK5n5A5NtOaIgDz3K
        D/Q9rURcuKqL14XfX0BX3CcJZT46MXReYhrnH92VT2dCW4LQuzALU3fV832iaCAeAxwudCdQ53O
        ixFGceucicn6cheUXh2/71b9e1on+7VI=
X-Received: by 2002:a17:906:52d8:: with SMTP id w24mr12198552ejn.296.1636655079250;
        Thu, 11 Nov 2021 10:24:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdtIZ4fq54sTE3246Krzh5AVwDMDlJCaYPT96Ca1nLvSG+TkSl7vWVx5GKNuh6kizoLP714w==
X-Received: by 2002:a17:906:52d8:: with SMTP id w24mr12198523ejn.296.1636655079026;
        Thu, 11 Nov 2021 10:24:39 -0800 (PST)
Received: from [10.43.17.220] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f18sm2141601edd.10.2021.11.11.10.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 10:24:38 -0800 (PST)
Message-ID: <7f195c45-3e1c-6041-eb59-78a78c191128@redhat.com>
Date:   Thu, 11 Nov 2021 19:24:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] libtracecmd: don't ignore LDFLAGS when linking the shared
 libs
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211111180318.499099-1-jmarchan@redhat.com>
 <20211111131131.585caf0a@gandalf.local.home>
From:   Jerome Marchand <jmarchan@redhat.com>
In-Reply-To: <20211111131131.585caf0a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 11/11/2021 19:11, Steven Rostedt wrote:
> On Thu, 11 Nov 2021 19:03:18 +0100
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> do_compile_shared_library should't ignore LDFLAGS. That makes it
>> difficult for packager to follow their distribution packaging
>> guidelines.
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> 
> Thanks Jerome, I'll queue this up.
> 
> Looks like libtracefs may suffer from the same issue (and libtraceevent
> looks fine).
> 
>    https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>    https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> 
> Did you want to submit a patch for libtracefs too?

No, it wasn't my intention since I haven't noticed that, but it looks 
like pretty much the same patch would apply.

Jerome

> 
> -- Steve
> 
>> ---
>>   scripts/utils.mk | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/utils.mk b/scripts/utils.mk
>> index 6865a746..53b2b074 100644
>> --- a/scripts/utils.mk
>> +++ b/scripts/utils.mk
>> @@ -72,7 +72,7 @@ do_build_static_lib =				\
>>   
>>   do_compile_shared_library =			\
>>   	($(print_shared_lib_compile)		\
>> -	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LIBS))
>> +	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
>>   
>>   do_compile_plugin_obj =				\
>>   	($(print_plugin_obj_compile)		\
> 

