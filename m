Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0093C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 14:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8369261465
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 14:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhENODK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 10:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbhENODK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 10:03:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E80C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 07:01:58 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s6so34768549edu.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 07:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ZaBOvOkRe7OhSwdTMYw+9Rb/kfDywGj2zs4D1Jn5zs=;
        b=ZN74rw2r5m9wTRi5Lnde8dRJrOF9Guw9LaedJNJyCkNPMSR5SF2qy3jWaRRIudeX9v
         qk7Wtqqx+J1LbU0xKLYR3C1KRQcZggKhM2y4ZGt1Df7WDBvRH4epjN4EwE5DZBXLf/7T
         qP3J3YxB1sGmZeHQPF6p92P1LcSbfWTFZEgMf0olDuQgbRh5jTyBcoVp1r1UQdiLXYC6
         C3fmFrmrrc0wxgzCsQFMPhqeiKqLsak0PyuMluMFtX9mjEgzTVyjnrS0YKHSgNHSathJ
         rcvyhQy5X21hjyLWUAahwa8i7djoxGlcRb964YeMW6PSzp9/9LYpDw8FT2LZ9MJbJNPT
         zxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ZaBOvOkRe7OhSwdTMYw+9Rb/kfDywGj2zs4D1Jn5zs=;
        b=uLu9quNeYU0V3OxtI2VJKzbRyps1oXAir/UQEhE/ceLAW+QFDAxxXSAlTdWvXlYKy/
         Y9XPm5C8WL7BUlT5td5JmikzNMT1kVqj4M/5bqgw4yjSNMBZwvGEKtkHgG3OjDoHidBX
         EyRQ/E6Cyb6DhMhE4yxkHWbKhq2RL5u0gNv+RQQq6P+AGYYPjLaiXposM8caAkiApeAz
         GUpVBgq2ydmcp4Mu38byKKjbZSJU+0CjqMKqD7szx/8U0BLnAGjqyTUduhFTE5H2LClp
         hg+XBKHYQ9nqjlLWgYk5h0qs+LNQHr4FxmeU+gc860mE2p3FtBdu6ztxqHseFjEHzxNc
         gJJg==
X-Gm-Message-State: AOAM532I5E9lPO+NGYKz4ThOOZpcD/pFSGImcoYCiLuTWHpXPewPS0fD
        rBNGQXOPuBJEgd4WJYJTPd68jKvb6us=
X-Google-Smtp-Source: ABdhPJy3qEn96mNVYBABEHJfpEuUp8eSP+vjccyaymu4m/gJ2lf5KwSxJohPWh0nf7KPrGFucLTSvA==
X-Received: by 2002:aa7:c7d3:: with SMTP id o19mr42075090eds.142.1621000917101;
        Fri, 14 May 2021 07:01:57 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id l11sm4478535edw.42.2021.05.14.07.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:01:56 -0700 (PDT)
Subject: Re: [PATCH 6/7] kernel-shark: Check if "trace_seq" was destroyed
 before using it
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210514121826.161749-1-y.karadz@gmail.com>
 <20210514121826.161749-7-y.karadz@gmail.com>
 <20210514093133.504d1008@gandalf.local.home>
 <29e3a3e1-26fe-a7e2-fec0-605794e2f353@gmail.com>
 <20210514095743.4f265de0@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <0ffc23b0-be8f-f76f-c6a4-8a2db6590440@gmail.com>
Date:   Fri, 14 May 2021 17:01:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514095743.4f265de0@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 14.05.21 г. 16:57, Steven Rostedt wrote:
> The trace_seq_destroy() function is only to clean up everything that
> trace_seq_init() had done, and the seq is no longer valid, and the user is
> free to do whatever they want with it afterward. Like set seq.buffer to
> NULL.
> 
> This is a perfectly valid use case.

OK, thanks!
Y.

