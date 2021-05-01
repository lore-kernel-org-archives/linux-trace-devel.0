Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F4CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 May 2021 06:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0249613F7
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 May 2021 06:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhEAGMk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 1 May 2021 02:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhEAGMj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 May 2021 02:12:39 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A0C06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Apr 2021 23:11:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id d14so476183edc.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Apr 2021 23:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tsO0+QMXfs5w+d76g3pnC29rHPjZcV/8s7PODkcIvyQ=;
        b=Zv/dR2JXA47XiaA0Wxt+Ufvf0RA3RlXsIhU0IoNIAx7DpFBcghG0rKKccU+gvHlSYq
         rHs7CeAdKnW65PyEn3HicCC9ZZ8j+fdkTNPYn4PAPcQNfu03tvHMiv5Ws9M19rbSHdRY
         JwGMJUxL4z4KTXRfsgULyD/njfNOzGO8BX4N3qV4GgmkTpSDwUs5Mer2YilsEo/86Gxx
         zf3xTZCTxfDazjWMLfMCoXzVHHNwUhf0ykBAulN8jslq8YS08t2XBxfNCSaa08rPmgA8
         JDgRM+gsy9iGieiZ7tbKYECLhgTvX8RtYKPaPbLcWVFWKz07IzmQkpqBgZ5Wkb8o++IO
         USSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tsO0+QMXfs5w+d76g3pnC29rHPjZcV/8s7PODkcIvyQ=;
        b=aFiiifzwMjDLV8S2+a+/eHmHt9s9y1nUn8b48LkSBn71ZCdr/SM3bo6P6aTqFV8wuR
         46KLftnkVLQXAZ/2JlSekfdsDqqvjgwXHC1ehgDUOVzdMYVvKSgmvVHu6DGOxJcFowNv
         zZVGPScYMHyV3b+B/IkTaJOctjvDBJEbsLKXv4euxOgNutKJaSfdKhzUUdb31e1Lekcg
         FA8DgL5Oei9zP6Nqwd6OudRoJaQzN8VPKEctwJQhQP6JdUM2BA6gI+gWmiPS8IOScqlI
         pS1wvotJKTC4501TWTAOlYZqLY4FvwO6V11QxOh9fq/FBuEcQ7HErylMaaeRf1wBv2cL
         GNSw==
X-Gm-Message-State: AOAM530GpyGoN6LfHZw2qkIVnLC0MASmdFaPyle0gnLsMx5/3dIAyNxl
        bI7hoeA1gEL4Hz8dej9M84k=
X-Google-Smtp-Source: ABdhPJxyOY8f9HePXoAkAnX1SwACxaoL30Z6zsnkdcCD87NRVW5+ptocDCf4tfU8oc7vP/tQRvB87Q==
X-Received: by 2002:a05:6402:105a:: with SMTP id e26mr9924472edu.164.1619849509295;
        Fri, 30 Apr 2021 23:11:49 -0700 (PDT)
Received: from localhost.localdomain ([151.32.59.148])
        by smtp.gmail.com with ESMTPSA id v19sm4129237edr.21.2021.04.30.23.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 23:11:49 -0700 (PDT)
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, dfaggioli@suse.com
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
 <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
 <20210420221746.1899d496@oasis.local.home>
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
Message-ID: <04a0218b-e70d-4a84-1f60-797742ff7115@gmail.com>
Date:   Sat, 1 May 2021 08:11:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210420221746.1899d496@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 4/21/21 4:17 AM, Steven Rostedt wrote:
> On Tue, 20 Apr 2021 11:12:59 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
> 
>>> diff --git a/examples/checker.c b/examples/checker.c
>>> new file mode 100644
>>> index 0000000..0b04343
>>> --- /dev/null
>>> +++ b/examples/checker.c
>>> @@ -0,0 +1,202 @@  
>>
>> The first problem is that this patch fails to apply. My guess is that 
>> you hand-edited the patch and removed some lines starting with "+". Note 
>> that the total number of additions and removals in the file is indicated 
>> in the line above. If this number does not match the number of lines 
>> starting with "+", the patch will fail to apply.
>>
>> As a general advise - try to avoid hand-editing patches unless you are 
>> certain you know what you are doing.
> 
> Or hand edit the patches using emacs ;-)
> 
> That's because emacs has a "patch mode" that updates those numbers when
> you modify the patch!

Oh, I didn't know about this kind of mode in emacs. :-O
I will surely try it, thanks!

Regards,
Stefano

> 
> -- Steve
> 
