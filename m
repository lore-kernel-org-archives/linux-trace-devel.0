Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A13DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Feb 2022 08:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245733AbiBDI7J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 03:59:09 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:38310
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244494AbiBDI7J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 03:59:09 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 575463F1BE
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Feb 2022 08:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643965148;
        bh=pyktf8dH3ml5EKO996ur4ZVjdWZr+lEMckMbteYJXPM=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=Oh0uIg0q1rbvYn1ovmgh3cA6Wvyz1fUuh1aTbXBEctP6Qs4cJ8b+J2bvUGIov84yO
         ldxE8GWsXtHf6PHL13TQtUwQXf5Zsr2kOIiZRO+NMHP6CBl+urpQOWmrSYkzZmoGZf
         UiD7XDqoMwpvZ/xBMeojiKyT+Tj3qkYU5yHUWTcbs4ltf/3xakOhT5E40oaKlwnGG9
         Ej1gBKF8tJBULdWPGgHCJe3TqI8D2mggP/qFMlO1sotyBTIj1ZU92FkvyCHyO611Bl
         0sO1+Gs2I0DPMZsx1VLn+28lIrVs6PMG5D0mswLcKP6Q8rLQ1sKoGmLSngvYzVb5zC
         HZWcGU6pQ3AYw==
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a056402268f00b00408234dc1dfso2928292edd.16
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Feb 2022 00:59:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pyktf8dH3ml5EKO996ur4ZVjdWZr+lEMckMbteYJXPM=;
        b=QiOqhKjtX8Nn0UGjvXT0n29zc+wVNjiDLp2b7ZWfVLmvPMG0J1Zdg23vD3ryOFu+Qp
         l20VsxirAM6uGpk+DhHZgv2K2kYMixDmyt+JTa5CUb5NcO/B/tvvsWS97T+6AwgKCvZG
         89ZTWxT41EpTu9mLom9b1pjCsQh6A+4M/1XqzzwmBJW0AtmgsJjLcYFdSqCvisFgWG6r
         Teg+fmGux0ZAEkgSvEKMb0nEtb7H27qiTYkIOtfbhQpaByueHPEJYWhwpfArjHsJSG/c
         oCAdYzBAnWfEafLh+tdJPPKeP2W0Lng9cxPeginiftAnObugC4Known/nOX8fcRiaQLg
         tf+Q==
X-Gm-Message-State: AOAM533yQya5LAKxm7NECQK2K1LPybRTS18/+ASGYkNPvELa6tjgFODc
        kCNBnvEmi/DEZkCids9UiuSBY7Gb2GTgD/PecVfKtRu/Wc6Q1/lVheAVd9xcmbTm34JQ1lzreUA
        CqVPbj5mHgAw8hj+6HiFGB4/nBGC6Q0ZCFzeKYC7zu3KV4zlC
X-Received: by 2002:a17:907:86a1:: with SMTP id qa33mr1575644ejc.516.1643965147502;
        Fri, 04 Feb 2022 00:59:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz96B2qT6oTLKy7Coak7M2WCbwho0UT2XFG0Ba4M+JNGSvDfmFz1AfsztgV/kMIqQqmG7Qkjg==
X-Received: by 2002:a17:907:86a1:: with SMTP id qa33mr1575634ejc.516.1643965147316;
        Fri, 04 Feb 2022 00:59:07 -0800 (PST)
Received: from [192.168.0.81] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bt6sm429404ejb.222.2022.02.04.00.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 00:59:06 -0800 (PST)
Message-ID: <652ddddb-6770-ca49-d00e-3b24ebc602a4@canonical.com>
Date:   Fri, 4 Feb 2022 09:59:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] libtracefs: clean also docs by default
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
 <20220203214106.458cb2c4@gandalf.local.home>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220203214106.458cb2c4@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 04/02/2022 03:41, Steven Rostedt wrote:
> On Mon, 24 Jan 2022 11:52:51 +0100
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:
> 
>> Logical is that `make clean` cleans everything done from build, not only
>> parts.  Leaving the documentation unclean requires additional step
>> when building for example Debian packages:
>>
>>     $ dpkg-buildpackage -us -uc
>>     ...
>>     dpkg-source: info: local changes detected, the modified files are:
> 
> The reason we did this is because docs are not made by default.
> 
> (Yes you can say the same about utest, src and samples but those are all
> code).
> 
> I've always kept the doc build (and cleanup) separate from the normal build.
> 
> Is it normal to remove the docs in other projects?

I don't know actually, but I find natural that clean removes all
objects, even ones not created by "make all".

I see your point, so I do not insist on this solution. I can fix the
incomplete cleaning on Debian package side.

Best regards,
Krzysztof
