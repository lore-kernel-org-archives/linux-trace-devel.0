Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC12CC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 10:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E2760FF1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 10:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhEQKXy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 06:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhEQKXx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 06:23:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F427C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 03:22:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id b7so2663675wmh.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 03:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3O30tIPnFWcXkwD41r9Nt/LUc9xqWHNW77Cl2xDiZGQ=;
        b=dpYZoNSdbMPzng3JSwzyt9uFtDmIVRFh1+iRqMs6EopqbiwY39+JTmnev9Lrp95u3N
         zczawyBSDSmLY+v3/cPSOOxbbg6oo8lskHvWCTS3bWo/x/NJsQjcEDLIwXuVRPNUZYEX
         cV6Xw9La0zUPT/6uQeFQZGU7fCtZgU0HPrqqCCeUvqKBfm2atiitfSQ601uckHiB0GyR
         jE0DKTO+HNIibx6bUuVNFjuQHBreEDYQxhPnCjqas8f9PiYrNpFee+ed2wOMD6wPIWxD
         LtwYkIYePpB9rRuL0YrA/Bnba8rojpTUS1U5Oei+6fXquie8QGttm3mb5TVxFLvrVmm8
         RI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3O30tIPnFWcXkwD41r9Nt/LUc9xqWHNW77Cl2xDiZGQ=;
        b=eUS/FV77FAOEiQ70kz/k530vAm4AgBUaSlM0MeoH9fJTqxrOTheng/ubRTekETjvBO
         bW5wHaWXsntfwa9mZaKZOo/zgiz9PjxW27C7m3Ujqa7KoBGow+mLNTL2C0548zAHbzeA
         6jE2uQKovUtyoQDFhe5BIrPajJHKf0QXsjIlkIBtw0j9wtKJXoayEcQZCCWDIOZOEEsu
         PN5QaYjUiIinQeHPmPKQcGl86deHpRmC0ALFwALlOY4Tm2ZJ5pAf8/sU6W00pIWqUclI
         q6bYP8od3TLEh9kXd17IEC1ISNYmp0VB3SG+d+XHugAKeBWTZjNGQS7UyzVMjQ60bHSq
         Z7Hw==
X-Gm-Message-State: AOAM530rHVzxoERCpxFnDuYH1Fm0s6JiXWTi3DzWMQzNJd+73tBqGlOm
        FlzeLu51pjl63MT0vZfG0d9GStsPKNk=
X-Google-Smtp-Source: ABdhPJygpBUcBRScyJkh7Pc70UF2kMRW4qVkyvh3KEomZErllxTfbxVAJj186mhWmlmUPaPhqcf8TQ==
X-Received: by 2002:a7b:cc83:: with SMTP id p3mr7541561wma.169.1621246955783;
        Mon, 17 May 2021 03:22:35 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id f4sm17323766wrz.33.2021.05.17.03.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 03:22:35 -0700 (PDT)
Subject: Re: [PATCH 0/7] Final fixes before KS 2.0
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210514121826.161749-1-y.karadz@gmail.com>
 <20210514140109.5615e1a2@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <1edacb8d-3ad3-73c4-fdd5-09baa908d404@gmail.com>
Date:   Mon, 17 May 2021 13:22:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514140109.5615e1a2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 14.05.21 г. 21:01, Steven Rostedt wrote:
> On Fri, 14 May 2021 15:18:19 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Yordan Karadzhov (VMware) (7):
>>    kernel-shark: Preserve markers when appending data
>>    kernel-shark: Preserve open graphs when appending data
>>    kernel-shark: Clear before loading new session
>>    kernel-shark: Better handling of plugins when appending data file
>>    kernel-shark: Do draw the combo point of the mark
>>    kernel-shark: Check if "trace_seq" was destroyed before using it
>>    kernel-shark: Quiet the warning printing from libtraceevent
>>
>>   
> 
> After applying and testing out this patch set, I realized that the appended
> file does not have any of its CPUs plotted after it is loaded.

Yes, this is how it works right now. No new plots are added when you 
append trace file.

Do you think it will be to show all CPU plots from the new trace file?

Thanks!
Yordan

> 
> -- Steve
> 
