Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8ECC49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D4C2086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVQuJOhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393465AbfITK1t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:27:49 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39348 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393464AbfITK1s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:27:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so1746982wml.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YKP0doev8PbEiB8V6RMDe5qv/YIE2yiWe358P0uLik4=;
        b=jVQuJOhfAJnZND8LN7mtBzGeJf5Y5Tjj2GUAE6pSK/Bk8pw23QHYp0beshFD8Pr/By
         7R6LlpZNpO9R1eCMrGdL1mClVZTFQQFkJfFIQxEd1kClfvUJYCa3EUoCLQnauRO7iDnq
         nY7c7ArE53vIwrBLYFVZBhKE9WPIRx/BnPWm2oxlyJkV6OS4TUBUssklqtGts0cN0JY0
         AedvrYrvGaiTW0uUArHgzHSduoZvvd4440Kp3mkdcvvN7Y1xY+4zoSMiCsxut4XTQsML
         C+ylFGVCZwzqm3DNOxP1FisrP3FM5FiESW1uCTXb32SrfLvjaRx8oemI4xYo8XnlrikW
         B9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YKP0doev8PbEiB8V6RMDe5qv/YIE2yiWe358P0uLik4=;
        b=MqDAYal3xXuZ8kD3VcLxchPoYs5OYIS85/zycU5hs4LYoTQlsC5L2/g64Ud6kFOGvD
         oaWvtjNtVUvLsnkuhXG5GIQG0kfT0daWs3+sp8beeIz5tJ5GzcJnLGFXNxU8A39dJ0cT
         pfwqwf20DH0MqhCE7WXliY7u0Vcc6VRiCuIY87XqAHAYfXAp3HZIJmHOMjaSiSPJzMLf
         STl7O3+0EEY8iQj//tfjKOlMdWaJid7CuKU7ujWDdNVmepkuwm8tQPi5Turka9+VrjOq
         8RygDNkzLKxX9ap0znAX7l3XWyxB3mKxoo5iPe5ItnMAgrlQZPF7kXc5PXm5dXxC0QAp
         uyRw==
X-Gm-Message-State: APjAAAXOyRP9i+3H3LYP1/VuS2ioZfFb5pmbtTbjZvFFf/nh93djabmF
        /7oWiAa94TrRzcpA5seK/IlWwD88
X-Google-Smtp-Source: APXvYqwW2Vl1VWgnTutrvWMGutEgVszm339fhOB5uWN6hc1yocgIwIeyJ9P33kWaGAreGgtX1aFwyw==
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr2968615wmm.95.1568975265195;
        Fri, 20 Sep 2019 03:27:45 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l6sm1741122wmg.2.2019.09.20.03.27.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 03:27:44 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] kernel-shark: Show warning message when running as
 Root
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com
References: <20190826155811.32021-1-y.karadz@gmail.com>
 <20190826155811.32021-2-y.karadz@gmail.com>
 <20190827182253.2d230e63@gandalf.local.home>
 <20190919163210.7740f372@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <af472fe3-4f01-f739-9f61-3a693a7ffc28@gmail.com>
Date:   Fri, 20 Sep 2019 13:27:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919163210.7740f372@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.09.19 г. 23:32 ч., Steven Rostedt wrote:
> On Tue, 27 Aug 2019 18:22:53 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Mon, 26 Aug 2019 18:58:07 +0300
>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>
>>> +	warn.setText("KernelShark will have Root privileges.");
>>> +	warn.setInformativeText("Continue on your own risk.");
>>
>> This wasn't updated.
>>
>>   From: https://lore.kernel.org/linux-trace-devel/20190809091914.75f553b2@gandalf.local.home/
>>
>>>> +	QMessageBox warn;
>>>> +	warn.setText("KernelShark will have Root privileges.");
>>>> +	warn.setInformativeText("Continue on your one risk.");
>>>
>>> Probably better to say:
>>>
>>>    "KernelShark is running with Root privileges."
>>>    "Continue at your own risk."
>>
>> I could update the patch if you like, instead of sending out another
>> series. Let me finish the rest of the series.
>>
> 
> We decided in our meeting that you were going to send a v3, right? Just
> want to make sure (too many things to keep track of ;-)

Yes, I am sending v3 right now.
Y.

> 
> Thanks!
> 
> -- Steve
> 
