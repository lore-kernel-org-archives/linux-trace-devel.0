Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5931C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EAC522256
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iBhjGbUD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgKSQBf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbgKSQBe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:01:34 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C3DC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:01:34 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so8656824ejk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sOmvIp6RxhXDgMnb8Fr/wfZHLsf41R1qPmTcnxVgajQ=;
        b=iBhjGbUDDgUzRbUFHZfXjXSEJQJ1+lksKNEFp4KG+Z38rrg+9cmIl+ew27mFG/Lv8h
         IjQGLh25PbRKP968c88VYRaaN5IpYJ6d9azABsCoMFKr+kFhCJxE2cMtA2Kf6c9Om/Rf
         pxw3ARFEAtFWvoACrudiI5Yf3UdgqomC781crdXp5iN5nGG0tOxuI44IyULClPhkgjgX
         3/qLd2EvSZfGH4VwxX/nxx6ZVT1zNAWPBdrLUdICA2i33kz1SeUB8bQaV4VOiUoXmpNg
         njjLwhzmS3sRr14KA2uNXZsuOpMrTzcZZJc/MD4FsYdmy3ExGrQTbhCOqgtORsSasa2N
         TwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sOmvIp6RxhXDgMnb8Fr/wfZHLsf41R1qPmTcnxVgajQ=;
        b=jPWPkdZRoyKp4E7desT0AGfD7NZ/fsXCCWHZPtrJPzzZXFGY8+tx6T1rtQLBjIqNAy
         lkadAWAWccM6WBrljQaEC6fiiHtRVrOOc/wwybYtI4u7WH03riPv0M36VzKYKkrDd/Rh
         mcMavCA+oGCC2e3emrd3qt5feQ6vfcK/xWV/ChiDuLVbZNamEiItVWZLwLgcNUwMQxEL
         k7M2ZwrvosETA9aGxV7dgt67+WV8yKDrF817ChrLq2F8W9KGWzmwnrDdUYMNX/gWWYWL
         VGIZDEDCrNPcUcBLUiw4yBnyhLSnR+yOolLi/wYJfBPl9IaIfsesfuQlseWIcY9e/NMt
         q6eQ==
X-Gm-Message-State: AOAM532Lsel9UN46BiAuNT1F+nkXqMtmALbj7OiGI3fh+QirbvgQAbQH
        vF9aAxkHGg3sWVMSneemsU2E5YbYgh0=
X-Google-Smtp-Source: ABdhPJwxfpl0GWYDPMHd0/U2GbF7k6lGlsyKD0u0F5wE4hQcryx7F/J6Y8ptc/I1bisMRlHk+yUEqg==
X-Received: by 2002:a17:906:dbd6:: with SMTP id yc22mr8599878ejb.252.1605801692524;
        Thu, 19 Nov 2020 08:01:32 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id bd21sm2907104edb.79.2020.11.19.08.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:01:31 -0800 (PST)
Subject: Re: [PATCH v4 06/20] kernel-shark: Add basic methods for Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201118145003.156542-1-y.karadz@gmail.com>
 <20201118145003.156542-7-y.karadz@gmail.com>
 <20201118171314.16662a9f@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3ea5483a-9cb7-cbf0-e3ab-0b354228a387@gmail.com>
Date:   Thu, 19 Nov 2020 18:01:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118171314.16662a9f@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.11.20 г. 0:13 ч., Steven Rostedt wrote:
> On Wed, 18 Nov 2020 16:49:49 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +static void *index_to_ptr(unsigned int index)
>> +{
>> +	unsigned long p;
>> +
>> +	p = INVALID_STREAM_MASK | index;
>> +
>> +	return (void *) p;
> 
> I'm curious to why you add a space between the *) and the p?
> 
> This is now your project, so I wont complain about formats like this.
> You can decide it. But typecasts in Linux are expected to be together
> with what they typecast.
> 
Hi Steven,

I have no strong preference about having or not having this extra space.
For me, having the space makes the C-like casting look more similar to a 
new declaration on contrary to the C++-like casting that will be 
something like this

	unsigned long i(340);
	char c = char(i);

and looks more like a constructor call.
Of course C++ will not let you cast number to pointer this way.

Thanks!
Yordan

> Again, no change required, we just need to be consistent with it.
> (makes it easier to grep for)
> 
> -- Steve
> 
> 
>> +}
>> +
