Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C331C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCF14217D4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3msPNXl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfDEKLD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:11:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37583 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfDEKLD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:11:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so7302356wrm.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mvOxYC3fG3GZte0vroUCvi+RNf8BTC6xNRoC2qVDnpg=;
        b=p3msPNXlY3+VVaQH4xbfyRQJN7RHW3EOLn+97gR911WwiNT2CrwL3oYfl+79lEbX7j
         ZddEoBkUYUG3QpDmFsCOca0qPbWQirxjMD0rFefY4lfr0NthXc/c7H2Kuge2x8KLqIYg
         uXPDnUVFaDY7UE9FE3RiPaOWo9i5SBYkXmZ1nwh8jbdiI4PYRrLsIMt+jl1i1BIS/8R5
         DZ8T7DxiuR979YlWeSMbpzk+cUN0db3AKlJJPoo6UnJXTzWEifPTQlDWKitMSSSGvhQo
         mZ6S0Ci6GlBvFn0B3eoXOqy08eHypsXqazPdt9uDYbSLeS+1AiYfm55PK4fBVXknOC4X
         wofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mvOxYC3fG3GZte0vroUCvi+RNf8BTC6xNRoC2qVDnpg=;
        b=GdDlkt1SHFc9Wqhmlhg1/GKMNUE7Wwl999+rFXRwyX/x9/jGa7pq5lt2B3K+ng9kem
         N5XX6RKDZF+Cq0vZe/f9V7b+ozo+rOCgj3fbKtHbc9yKThT/StlMm0giGpYh3f85COJV
         3FqzstjpByKYYH/FNKeQu1A89Q4z0YIOdst52ttiCIcVGgt6EcA66/YtLyGyADY2bCFw
         Hs/Ba+I+AgORPaLe/MtroNl43ECZ342Dd7C1dscU2pDhlYgpXTEmXT134F/kTYizxSNf
         l48brWjfvsUI6PpCEYtEvcQ5TRscN30ulHTH0jUnAt6l3npaFAbA/zRR5cMj4b7esx3Q
         bjGQ==
X-Gm-Message-State: APjAAAU0fJNMIKQ+qZ6/HHWrVA5kYJSC6x2lyqfvXxK8gPTka+MBBYQl
        xwyKLztvGqAX4GFEgObygvPSplaBAN4=
X-Google-Smtp-Source: APXvYqyxjs/v3sUXKylIcO+86KDIOAXedbK1TVwvqn52Xe4ijEZKP8Xv+yt6rDSo7iJeJv0tgn6A+g==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr6886226wrp.61.1554459061400;
        Fri, 05 Apr 2019 03:11:01 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y17sm25765752wrh.60.2019.04.05.03.11.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:11:00 -0700 (PDT)
Subject: Re: [RFC 7/7] kernel-shark: Add basic example demonstrating the NumPy
 interface
To:     Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
 <20190327160323.31654-8-ykaradzhov@vmware.com>
 <CAE0o1Nuqxs4QarqWnTC_0J2bnR62vSYLMvnSKTxkWGUeZyP3_w@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <ea1c9156-d6ef-0916-3dce-8bbf6a86ce1b@gmail.com>
Date:   Fri, 5 Apr 2019 13:10:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAE0o1Nuqxs4QarqWnTC_0J2bnR62vSYLMvnSKTxkWGUeZyP3_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Slavi,

Thanks a lot for the detailed review of this patch-set!
I am about to send version 2 of NumPy interface patches which tries to 
address all the problems that you found.

Please review the new version carefully and be as critical as possible.

Thanks!
Yordan

On 28.03.19 г. 14:47 ч., Slavomir Kaslev wrote:
> On Wed, Mar 27, 2019 at 6:04 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> [...]
>> diff --git a/kernel-shark/bin/sched_wakeup.py b/kernel-shark/bin/sched_wakeup.py
> 
> [...]
> 
>> +ks.open_file(fname)
>> +ofst, cpu, evt, pid, ts = ks.load_data()
> 
> Returning a tuple of 5 numpy arrays as API will be impossible to
> extend in the future without breaking existing code. It's also easy
> for users to get the order of the return values wrong. Have you
> thought of returning a container object that's holding the numpy
> arrays? Pandas DataFrame[1] comes to mind although I don't know if
> it's worth to take Pandas as dependency for this.
> 
> [1] https://pandas.pydata.org/pandas-docs/version/0.23.4/generated/pandas.DataFrame.html
> 
> -- Slavi
> 
