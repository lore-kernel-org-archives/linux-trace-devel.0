Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4996FC433E7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEA5F20776
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hagRM1td"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgJLOSo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbgJLOSo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 10:18:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46CBC0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 07:18:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s9so7297786wro.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 07:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v2j8L/rpFKX+AYz1dIPLsAzzXatK3gyTQubYuSnO7ck=;
        b=hagRM1td9xVO5Ee+ImMIWUZn1B04umgTNMuqmUQ7g7Vji+Lr93Nw4RZIS1EuPELb8B
         u3qVVELU2LN5c9GIP4JC9GnXYyrL4HMYcJsV7uRAHGsM8J6emRaz9UtA+N3GCOehkjQO
         hw4TdE0+0MzHTjHJArNpGtBuUdGZCGWak9fnXkQjVwp7tVI72Q4QRX+IN8nrzSOoKToH
         licNTO6kQjnyc6GNhixJ1n1XkKZofth0VE8ItAQwVjP1GMPdWyQELzctqS+VOPkLoEnX
         th4xFy6L6hciEH4iCyrYqzvaYwnJ1rS/mUTzttg9OA7xrAW/qXjGt+ZqHIJ2KJXePVEY
         /Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v2j8L/rpFKX+AYz1dIPLsAzzXatK3gyTQubYuSnO7ck=;
        b=kCMO4pV06lsQPPdppJdzUnmqXkqBkBer2Igk7t0IQx2KG785G41A4W+pioPBfednYt
         IT4gmyntl8OinZ0ADv4/HRdv0WiMMfXth5VsrXvlNVzXKEwGa7SXSA9FflagkGfIuUNT
         3l922GngChCamyvwyl+qFBWK3/RmHSLKRoqODO4nJXHXgUXuR2YUBC3sda5qUs+d6osz
         5+F92yR1waWOEMD8Sl6Gq0chpq3E7I2iN0GVLkLBN8Mj1CQZyokAbOGbYzyerhk2+xj9
         IpSjekaE28guk2RT5JdHfWHemb9VmO81y8ukOCwOjrHsNq+LXlFfGVX9lm0ZNT0D5G93
         kcNA==
X-Gm-Message-State: AOAM532FQAPsbx11lBA6j20h43+IZy8O6iF6ISFryogq9oAWHF4Wj7On
        UdCtcYEiUcaoi8OD79fCcSgryrCCK/A=
X-Google-Smtp-Source: ABdhPJxl2xrX08Mlur3LUkqYV0zxz/cZSeN/ONK+WWDlECUXqizLW/6v8b0WBcRNzhzuDmkCFXwjgQ==
X-Received: by 2002:adf:97cb:: with SMTP id t11mr32489429wrb.292.1602512322174;
        Mon, 12 Oct 2020 07:18:42 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id u20sm15769600wmm.29.2020.10.12.07.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 07:18:41 -0700 (PDT)
Subject: Re: [PATCH v2 03/20] kernel-shark: Introduce libkshark-hash
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-4-y.karadz@gmail.com>
 <20201012100516.29b3f99c@gandalf.local.home>
 <20201012100538.2fb029cd@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c65f29fc-dc8e-e299-5ef8-f077d2b0e262@gmail.com>
Date:   Mon, 12 Oct 2020 17:18:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012100538.2fb029cd@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12.10.20 г. 17:05 ч., Steven Rostedt wrote:
> On Mon, 12 Oct 2020 10:05:16 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Mon, 12 Oct 2020 16:35:06 +0300
>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>
>>> So far KernelShark have been using an implementation of a hash table
>>> from trace-cmd/include/trace-cmd/trace-filter-hash.h. However it turns
>>> that KernelShark is the only user of trace-filter-hash, which means
>>> that it make more sense to make this implementation of the hash table
>>> part of KernelShark. In this patch we adapt the original trace-cmd
>>> implementation and change the naming convention used.
>>>
>>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>> ---
>>
>> I feel at least the first two patches do not need to be in the "disabled"
>> section. Can we move them before patch 1?
> 
> I meant patch 2 and 3 before patch 1.
> 

OK, thanks!

I will change this in v3.
Y.

> -- Steve
> 
