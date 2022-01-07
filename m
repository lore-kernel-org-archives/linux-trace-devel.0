Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE2FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jan 2022 12:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiAGMYK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jan 2022 07:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiAGMYJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jan 2022 07:24:09 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0D7C061245
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jan 2022 04:24:08 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 18-20020a05600c22d200b00347d3a13c7cso326557wmg.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Jan 2022 04:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=hCwU+oZTkfQUuuUi+Oo6LHQZAtZmdlPKA2c+ImjozXY=;
        b=CQmhnNPXajFIfaQL7vx8d8WtoxC1vHUFIit8d0AfR8UpnhOczjoiGeuDTG7geYbR0F
         Thmll/iBC/dPAUltq/NXuVoMqy7BhQuGIJVznxpdI37gYqQmJv5gM6t0nGiUDeN2+AOu
         4NcKG74m0/Ei1ncg89I8gD4fdE4pgXQODhKE9Wa5dGb0um65pesO9oX/uW+PzenBMuEt
         MAmXuAtVAMYDv5e06VSkFQMT2yAEBSMF3e6GFqEaYtHI/j93ITwMVM5RWykY2qBq1BlV
         KISDXWoRbTRbNpwTVvwfxilIY0uUsBC+r+SNS+aVnU0txdGxIUGrdPw5VvpTx3W1MkMm
         4+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hCwU+oZTkfQUuuUi+Oo6LHQZAtZmdlPKA2c+ImjozXY=;
        b=nnH8ccrbB3PnlwMFyxxfzep2LlUfAQbwd9CaAYrKa0Gsu1cJDR1ObLSc4BizJWnduQ
         dwTIGWzSaBgfmhwV+b2/bApPb6B/AeDei1iJeMWUXgpd9ReNw7cK4DUOEKneIAkSfUcJ
         sEQqo7i5URsiM8lfTGBn8XIlag9Vb30srE7uyYlMwhwMnSmPJJCfereVGZgc9YdR5T/r
         cCOwYDsXndHyc9mx8d7Klz+3p9g/b9TIic/1PhOycyuchlTkgwuoqiWNu9j58l68QInY
         R3dcIbzW19GR+EiR2bl5h6DupnvvOVb50M5w1bf1kv0psrdnBqck80N0FpA/sWgY4g3y
         x2bg==
X-Gm-Message-State: AOAM5300//Aj0B8zoZwq2ZWJ6I0N2dXnm81Zs7ESwOP1lTJXp07fc4zd
        6F2MXMl+rXLlLK++m1gBMkk=
X-Google-Smtp-Source: ABdhPJwfjnz4N4ANa4jPSIRikJ5WFjmMasyyUy/jD2o1fpvrM009AhconJ/K6ziAlIhE8bwYHcXY8Q==
X-Received: by 2002:a05:600c:3493:: with SMTP id a19mr2617683wmq.37.1641558247512;
        Fri, 07 Jan 2022 04:24:07 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id p11sm5519815wru.99.2022.01.07.04.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 04:24:07 -0800 (PST)
Message-ID: <50c5932c-d35b-3739-0277-508c69be9a7d@gmail.com>
Date:   Fri, 7 Jan 2022 14:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 2/2] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Content-Language: en-US
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20220107021846.893-1-hongzhan.chen@intel.com>
 <20220107021846.893-2-hongzhan.chen@intel.com>
 <9e84f570-f9f0-fcdb-e6e8-7b08fcb2932c@gmail.com>
 <059411fb-b691-7bb1-9acb-7d4b005f1bc0@siemens.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <059411fb-b691-7bb1-9acb-7d4b005f1bc0@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 7.01.22 г. 13:57 ч., Jan Kiszka wrote:
> On 07.01.22 12:10, Yordan Karadzhov wrote:
>> Hi Hongzhan and Jan,
>>
>> Have you decided something about the way this plugin will be maintained?
>>
> 
> No decision yet. I'm still waiting for an answer on
> https://lore.kernel.org/linux-trace-devel/9ac9a1af-6829-425a-7943-755decf7c273@gmail.com/
> regarding maintenance of different tracepoint revisions. That would be
> implicit when keeping the plugin in lock-step with the tracepoints in
> the same repo.

OK.

> 
> But then the question would be how mature the interface lifecycle
> management of kernelshark and libs is /wrt external plugins. Those may
> need to account for potential changes in those APIs over the time, right?
> 

The APIs are not supposed to change. I cannot give you an absolute guarantee, but we will do our best to keep the 
interface stable. Anyway, even if we have to do some minor changes in the future, it will be our responsibility to 
communicate this and help with fixing all external plugins we are aware of.

The whole idea behind the design of this interface is to be friendly for external plugins.

> We will likely pick the path that is least inconvenient.
> 
> [...]
> 
>>> +    eventFieldIntervalPlot(argvCpp,
>>> +                   plugin_ctx->cs_data, checkFieldCS,
>>> +                   plugin_ctx->cs_data, checkEntryPid,
>>> +                   makeLatencyBox<XenomaiSwitchBox>,
>>> +                   {0, 0, 255}, // Blue
>>
>> Perhaps you can use 'cobalt blue' instead of just blue ;-)
>>
> 
> Makes sense ;)
> 
> Seriously: Is there some caption somewhere that explains the meaning of
> colors? If so, how to hook into that?

So far we do not have special convention for the meaning of the colors.

Thanks,
Yordan

> 
> Thanks,
> Jan
> 
