Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92FCC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 12:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83AB5619B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 12:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhCWM6S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 08:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhCWM6M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 08:58:12 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC4CC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Mar 2021 05:58:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j3so23287348edp.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Mar 2021 05:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nD2L22oMALh6zctufE3y5c8NqU+hdVTbks3ruW68ANU=;
        b=AldqkxkKMkKwY8CJklnyoD80u8zR20tGABcCd+/uAD4KEtE+0hEIHUcq8V1txaP75+
         qBwyxZfiApZgNVQJiiEpvw1C91WS44Vp5xLB6WlDD/rD6ZZ+TZImSjMXTIu99A3JchnI
         m7q5bvXDs6NsnIkwFA3U3oRZ8z/OKFiDMH/lhKDoZC7yL2NqWlDeEgdeH9KtA/n2GtcS
         W7bFDY3Aw3TO9PgVlkuRMy/UnDLeeSX1tn/f9J7r5iOSPEjTMJrFJq6xkRdkmcE+B0oJ
         fPG7dYNSDnn562PrSyTumnTTfNzCLMGtS3Bvr2VfBoslImDfUwCAAUvKLlkAMV5yeDXR
         l9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nD2L22oMALh6zctufE3y5c8NqU+hdVTbks3ruW68ANU=;
        b=ml1aryLUBTYs2MXsIyBRCrf8wftsW2fWVPKAgirPn1W2/yY4wXnDiaHPjY5XkT2Wpc
         DrPNLhtK3QLahmcd9IZi5QvJEhD6rT/96jeEecQw5PRJ4tRYJL8gbx/DqzorzO16C1PC
         kzKTsBMS83tyuSbNexBR4b5vgPeeI1UcS12pFmN/RmuB1rFRK42sqKJg0XBEjlsVE2kk
         tzk//8+UgS4X7HheBND8yUWUnr3nTCrVl7PzgJjZsA5FZaTBHFKR7wilVPaadpTruJnk
         O8wtCwn4GxVQDN9Y+UlWroiyNTD3Pz51iIEWf9pwb+9TyHlukjEb1a0SUPEMqthYWJBi
         XbWw==
X-Gm-Message-State: AOAM532O6vKWJR3U0jD8w4XH/IczFndRZ8pZkwY3Qb9yyvW6gDhsa7Yt
        OnpfKpGlrEqUwPRrap/jYCPYRgVh/bAeZw==
X-Google-Smtp-Source: ABdhPJzi/OXofzTobWE5VeqeBOSvoH6TywJ1W6ZjbG0c9Pu7CP/ZbYM49hcYuqoUjsB2EaTrJzCHnA==
X-Received: by 2002:a05:6402:1115:: with SMTP id u21mr4377681edv.383.1616504290734;
        Tue, 23 Mar 2021 05:58:10 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id i2sm12677426edy.72.2021.03.23.05.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 05:58:10 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Prefer using const pointer arguments
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210322142912.26521-1-y.karadz@gmail.com>
 <20210322114721.118c83ae@gandalf.local.home>
 <64861357-e2ef-e2aa-239c-9b8a96a5bf9b@gmail.com>
 <20210322182917.622f6126@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c414dd4b-60c3-bdfb-0e23-ee9c307a3518@gmail.com>
Date:   Tue, 23 Mar 2021 14:58:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210322182917.622f6126@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 23.03.21 г. 0:29, Steven Rostedt wrote:
> On Mon, 22 Mar 2021 18:59:42 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> I understand your preference to keep the flexibility of those API,
>> however generally spiking those are "getter" functions and they are not
>> supposed to modify the encapsulated object. If we allow the "getters" of
>> the API to modify the encapsulated object (tracefs_instancein this case)
>> this will be a bit of hacking stile of programing. At least for me,
>> having a firm and intuitive design of the API is more valuable than the
>> inconvenience that this reduced flexibility can potentially bring.
> 
> Is there an immediate need for this change? I.e. python complains about it,
> or some other reason.

Hi Steven,

I really need to change all "char *" arguments to "const char *". 
Changing "tracefs_instance *" to "const tracefs_instance *" is more a 
style preference.

Thanks a lot!
Y.

> 
> I'd like to hold off on changing this. This shouldn't break APIs, as the
> code should still link fine if we decide to change it later.
> 
> I looked at various other libraries to see if they use const pointers for
> "getter" functions. It's somewhat inconsistent. I'll look at more
> libraries, and see how they are done. I'm more interested in keeping with
> precedent here. C does some things differently that C++.
> 
> -- Steve
> 
