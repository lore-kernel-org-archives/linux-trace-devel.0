Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D4AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7817561288
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhEKNbx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKNbv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:31:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683A1C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:30:45 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t4so29847078ejo.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vr7OfPsKmc4GRtcO6bVgJm1DnH9R0nx8SsWeRpWQv7E=;
        b=Wr3a9uZ5nHfSEY7Uq/oBbZWi7PcFRP3qD6C+y+93f9LI6ElEMTifxWn0nG/mh9rhDl
         tYwx/RnEt/QQlU0l14b3ZHROQ1jA8Djhpd+Wwkass/EyTtiJbYcpjzL3N93iP8HmlqM1
         DHbE4gYrgvZJGFn690Q5CdCiKaGmgzHkKV0YBlgh92bS/e6VoLxBrgMOZe2I4nRSVCVZ
         gvMStTVA5d32sXQkg2NRCF1DFRHjzGwf8YHhd4h6Au5N8gKHd3K3YxrJRFeAU1UEweJ7
         3P+gybOCXIs4r3c4/xX/hm9nZD105F0sbD5zdut4a3nEJLbc7roL6IIqD7ISfEcduLbV
         ibmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vr7OfPsKmc4GRtcO6bVgJm1DnH9R0nx8SsWeRpWQv7E=;
        b=dseiq97Ba2yhVSpi44mkd+uXdkl2tnJFOYFuFcGxvRwZszm4gMZhed1hGRWOcGtmtn
         IEL6oT6j2pwjuKgQgglINMKa4xoeGbHLTBeWPrsiPzAwyWgbUJoZl5ibeL780W/d1mZ2
         QpjI/p2BhA/NRK3vrmTAwF2X+pgqwURZfDSehz7Ls+1D6X1RyXUOqPKuMJYvKshrg/vg
         jkP4xSgPMjCoY11VpqBtSolPdzLoxE4mE2x7bt5xK9MYySJrKIVz1qgAcO09twSI60PF
         N6hJzpLiNynsRviocM0yK6q9d+IeQf+Dwr7iQUjSDzxpzX9Mmz0LCqLXp6hqE3DXpmEo
         7N7A==
X-Gm-Message-State: AOAM530twoMUFzGEyoe4j9sVOVQZ+Hzawv7vDsInRkFudmOwoFUTBfwk
        SqW76rOrCSljeaOMEfSAtaBqtECnr8E=
X-Google-Smtp-Source: ABdhPJyVFtnVnBQACmxMZ2Esr0jwwChBbmzsjRbxyL16E3Z9ukRodpA9VSlQbRESXpUE4t3bqvqssg==
X-Received: by 2002:a17:906:b2c1:: with SMTP id cf1mr22301161ejb.544.1620739843970;
        Tue, 11 May 2021 06:30:43 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id f30sm11969207ejl.62.2021.05.11.06.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 06:30:43 -0700 (PDT)
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210428134730.187533-1-y.karadz@gmail.com>
 <20210428134730.187533-4-y.karadz@gmail.com>
 <20210506141151.2f31f263@gandalf.local.home>
 <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
 <20210510142537.2628c47b@gandalf.local.home>
 <cc7b594f-194e-9d2e-81e2-49f60f6c6eab@gmail.com>
 <20210510152349.3de97b82@gandalf.local.home>
 <96e06290-f5e8-34ac-1b3e-db8559bffd1f@gmail.com>
 <20210510170234.41c8136a@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <191307a6-7b26-4de5-be4a-10a388451096@gmail.com>
Date:   Tue, 11 May 2021 16:30:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510170234.41c8136a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.05.21 г. 0:02, Steven Rostedt wrote:
> On Mon, 10 May 2021 23:34:50 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> On 10.05.21 г. 22:23, Steven Rostedt wrote:
>>> Obviously, I'm missing something to connect the
>>> dots.
>>
>> And I have to admit that the commit message is misleading.
> 
> :-)
> 
> Yes, please rewrite the commit message to explain exactly what that patch
> is doing. That's what threw me for the loop. I read it, and was basing all
> my review on what the commit message said, and not what I saw in the patch.
> 

Done:
https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/commit/?id=e489a3b247aae8a3a556504ce6bf0da37190a99b

and the link in the commit message points to this email thread.

Thanks!
Yordan

> -- Steve
> 
