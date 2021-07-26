Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DE1C432BE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61CDF60D07
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhGZIY1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 04:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbhGZIY0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 04:24:26 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66684C0613C1
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:04:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q3so10227200wrx.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KZ++N6DUONyGuAV9VuF3fSQz3kMOukTi4rtzUfoo7Lw=;
        b=bJlPqUd59WektuJWaMI1nw8b6ovPNCjJLzHVIbfxsB1z3aCcFM8IqOHHS1UIQMUA7J
         cquZYfxCihDhcW6mlV6NbishiVavRo1Ems0pDV/ecAdfUZXk7Lf30sqimGdab/8NbTk4
         gmrwZMdoX7lbE0X9H1YxiN+sTmT+JCbRTEkOa4WoUjhASnRbm9DfEde1D+6tVpEihGCi
         FPcMmUloadvW5m8byeHwOQRJk0Op+EljBk2AVu+NarFQzPzIO3bUmleVCLCJpS93GiBd
         qSktLKOGKR7Om0D6rok/L/HRmn9Qp7jSYROpgFGg4fbmG6J4lMiz7SxUpMQtEUz0pLzI
         TsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KZ++N6DUONyGuAV9VuF3fSQz3kMOukTi4rtzUfoo7Lw=;
        b=Qu+YkUdJumBp7j6WKKstiRXNdmK2FbnuD1Q37N2+utW1EhiuBWvDjcipUvZ+wyFdk7
         RxAP+JsKYBNKz0cfGY1JsF4W7U4DU8lsMCgcItnb6bnmSVbksdG5weQjGIMdnKXjGGsL
         H7t7jd3B6xeXI9D6LCTCtPoZTS2JEa0HATLsbK5jU8h09RdzFaca1UtrQwzwmyX/y8g6
         fJgvV4fzYvjjmWq0UHGbCa212ANGXJLfxbCDElsLMoqDTCNEZktepSKoj8pKp/mCD1vr
         y7jjSq+Ab2m+zMSvUMyBYrRUk3jEiDqRalwzRgjQbatd36T4PxYpt3D4kONkhn/F6vrj
         U9LQ==
X-Gm-Message-State: AOAM531FJ17nZ0BFLEFCGckXXOLsGw33PfgJfsszGoWTGeLouXelwd+3
        Dxht7daZsF1lGORFUu+2v43lGEKEuHM=
X-Google-Smtp-Source: ABdhPJwdV+XsFizSL0WQ9c4fjYAjOyi02oCSZulCQs2tedN8HxZZZvMAOi75yTm+QQ7+tbrypoo2Wg==
X-Received: by 2002:a5d:5541:: with SMTP id g1mr3271493wrw.29.1627290292565;
        Mon, 26 Jul 2021 02:04:52 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id 125sm11856491wmb.12.2021.07.26.02.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 02:04:52 -0700 (PDT)
Subject: Re: [PATCH 3/4] trace-cruncher: Allow for detachable instances
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210712123242.223500-1-y.karadz@gmail.com>
 <20210712123242.223500-3-y.karadz@gmail.com>
 <20210722171930.608c8926@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f7a6290e-ace6-743c-417e-b46e0fc1846a@gmail.com>
Date:   Mon, 26 Jul 2021 12:04:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722171930.608c8926@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 23.07.21 г. 0:19, Steven Rostedt wrote:
> On Mon, 12 Jul 2021 15:32:41 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> @@ -600,6 +610,11 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
>>   	}
>>   
>>   	iw->ptr = instance;
>> +	if (detached) {
>> +		printf("detached instance: %s\n", name);
> 
> Do we really need to print this? I would think this is up to the
> calling function to print this or not.
>

I think there must be some notice that it is up to the user to take care 
about this new instance. This essentially detaches the instance from the 
garbage collection, which is quite something in the Python world.

Maybe we can change the message with something more appropriate?

Thanks!
Yordan

> -- Steve
> 
> 
>> +		iw->detached = detached;
>> +	}
>> +
