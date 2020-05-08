Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC043C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 13:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3CEB249A4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 13:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsmGU4A2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgEHNLM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 09:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729273AbgEHNLJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 09:11:09 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B614DC05BD43
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 06:11:08 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id a4so1351098lfh.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 06:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=smMBqsAAsQuYkg3qUQhq7eBScl0h8QjEGbaSIim0uzw=;
        b=lsmGU4A2d0WR7US6X2mB/McN0UFw0pMPk5bnnl0IikKN3J+3gCk1nVv3QlgKHoK1qv
         lMXchvpL4wnXDZG67y880cD4/bsqc5SIXk2o3+YUbv7sT4i7nR2ZsThAk3c1LcqsFxkb
         uSmBGyEWlpqfBceExzj7lwbK4LhZQtQsWZgllg6Joq1A0/2QP0B2Qiwe7qfpxChuNp7z
         dGq62eUzxlGYArHIZmhCB1n3Wt4e4eCKumjYJ4BAJxEFQdv61ncap9M/vquDsvABRVte
         qKaFNaiplp4QdSeD5syp/0M91Emz6kHbWSHQxlOT1rLIbZWYpq5yYLm1RjXXGv+Eufip
         8sZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=smMBqsAAsQuYkg3qUQhq7eBScl0h8QjEGbaSIim0uzw=;
        b=GrpdIEvgrTydn+/rLlZPkOEFLW5FAKH5//3JP5KCAAs6eefYx5qtKBLs9Nr2CKJuJG
         ITTAnt36VLYLAQJ/p4H7ED/u882WFkVSEuULvBioW3YCON4CeXUgO9tXjTaudZU56sMm
         4cGuOE4zIruIVKYFTvu/JLmDc/TU32WI2xpbBz/bn/W2+f6AcSL5EUO1mNDHouH/vsXX
         ssAAaV29xGD/if7ib7YZ34jfdhuw35cl/QDebmP+6+4L+sWi+bs73oNFrF5lNj6Yxk+t
         NjQRGejmxNPaIq8IZvm5Q/Qc9GuAy2sj/4m5NIfjby8/sXJ/0Fc8MhodQD37G75f/ACc
         hm1w==
X-Gm-Message-State: AOAM532RfG6mYFyhWEns8sAQoZxQYkPmh/gdGxbMgaNJu040x3mS5d8G
        uXFPf8LxstUby6Uf3U7FWga0SPNSiNI=
X-Google-Smtp-Source: ABdhPJwew1kKVnDqebAm6W4mz3Q3EmcqKv2IFtTwu2JOofnLjFIcxRtK/cCoozU7yuChtPGp1X06jA==
X-Received: by 2002:a05:6512:10cd:: with SMTP id k13mr1737936lfg.153.1588943466772;
        Fri, 08 May 2020 06:11:06 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id l8sm1164109ljo.5.2020.05.08.06.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 06:11:06 -0700 (PDT)
Subject: Re: [PATCH 2/2] kernel-shark: Add command line options for selecting
 plots to be shown
To:     Julia Lawall <julia.lawall@inria.fr>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200424132542.1620-1-y.karadz@gmail.com>
 <20200424132542.1620-3-y.karadz@gmail.com>
 <20200504151335.6088dda5@gandalf.local.home>
 <alpine.DEB.2.21.2005042117020.13990@hadrien>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <0d955df3-b881-b317-b040-4e508268faec@gmail.com>
Date:   Fri, 8 May 2020 16:11:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2005042117020.13990@hadrien>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 4.05.20 г. 22:17 ч., Julia Lawall wrote:
> 
> 
> On Mon, 4 May 2020, Steven Rostedt wrote:
> 
>> On Fri, 24 Apr 2020 16:25:42 +0300
>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>
>>> Example:
>>>    kernelshark -i mytrace.dat --cpu '1 4-7' --pid 11
>>
>> Can we change this to use a comma instead of a space. Then we don't need to
>> worry about quotes.
> 
> This seems like a good idea.  I was away from it a few days, and my first
> intuition was to use a comma.
> 
> julia
> 


OK, I will send new version of the patches.

Thanks a lot!
Yordan


>>
>>    kernelshark -i mytrace.dat --cpu 1,4-7
>>
>> That's the common format for other unix command lines. See taskset for
>> instance.
>>
>> -- Steve
>>
>>
>>>
>>> This will show CPUs: 1, 4, 5, 6, 7 and task(PID): 11.
>>>
>>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>> Suggested-by: Julia Lawall  <julia.lawall@inria.fr>
>>> ---
>>>   kernel-shark/src/KsUtils.cpp     | 24 ++++++++++++++++++++++++
>>>   kernel-shark/src/KsUtils.hpp     |  2 ++
>>>   kernel-shark/src/kernelshark.cpp | 32 +++++++++++++++++++++++++++++---
>>>   3 files changed, 55 insertions(+), 3 deletions(-)
>>>
>>>
>>
