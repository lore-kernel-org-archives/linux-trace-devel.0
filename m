Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48DFC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E0A610F8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhEKNwz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEKNwy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:52:54 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB4DC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:51:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id s20so24363429ejr.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g8xJguwVVHocSBux+n+VISyP5k7u2c98ngNHZb97DQY=;
        b=qQ8jb/L/oW4x0/RfDb0K0M5Lj4ZH/qIoWXxr2/HXwhjQ+hZU6QbKsQlWisM4UC1q8W
         g6l8QrZRoosgeRBAHZkf8fePRKctBqhU5qQ821CsWcvlczii6UQkQhbaIFyZpNm6gBNz
         l1uE2EVEjHA5dbnql8Dscv/76BQm6ZadElSjbvLP9NSAXtM3Y6njye5WQZYBSHyr5KHv
         L+P2+KBaJwtkd03/8SwZ0RUs1Y+JO08mrFZyCMZiS8WlocJhOCIS8ruyTQjaTCepCrTl
         Ggjptuxo/IUT6BJHn2fFovhM8BmUoxAw5bWX0NB3ldVg+0BzA6GnrQccbHNkEI6+rd79
         c6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g8xJguwVVHocSBux+n+VISyP5k7u2c98ngNHZb97DQY=;
        b=RCf3HleR0zwIqiUUTJ7FDDky5LR+42abvvctfp9pbtXHT53zLoCEZ525xRXmxcMsm5
         IwX/+yyPsF/kM5ifFQCbuSgguR0rTY9OmlJUqIJ9Co98MrVNiGMzVQV4i1F/ZLhSz4F5
         bEGQSI4JmR6/r33rSO30cgy8tUfwe9DxRNW0clvnCiU9f5t5KSYk0pYRcgLMxIm9Wvx1
         6yCxSkB31ngcSGtZG7TQbFFYys3PkwZe/2GprImYfUxtm1GszEfalFAGNYWWwmMKUJgJ
         lmBhAxRpxQK9ZaWVz4zG1KF/olVe/Nn4pZy9o1+TGfP5xSxm7dY4kei+cecEgD0rY0Ci
         rBpw==
X-Gm-Message-State: AOAM531huQw+cITuf+3syEv2veuX175nCftYgz7qlPiAwrHzHC83aw8x
        u5jyRUKYt6yBvGVuapUnzuSxZoHTH7Y=
X-Google-Smtp-Source: ABdhPJyADQqfCCTEgqRFJQiXhL8hBQvSkFM+tmkYI5dvoQHR/XXj6x5tqUXKHDizNH4jWcqIEkKf6w==
X-Received: by 2002:a17:906:4809:: with SMTP id w9mr28924062ejq.401.1620741106507;
        Tue, 11 May 2021 06:51:46 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id l11sm14232612eds.75.2021.05.11.06.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 06:51:46 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Add check for return of
 ksmodel_get_cpu_front()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210507093848.72bf0bed@gandalf.local.home>
 <2bc740d1-e093-17d1-a9ba-b4319e0ebbfa@gmail.com>
 <20210511094045.1673b76a@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <be412fdb-3064-6456-9ae7-3739014fdde6@gmail.com>
Date:   Tue, 11 May 2021 16:51:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210511094045.1673b76a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.05.21 г. 16:40, Steven Rostedt wrote:
> On Tue, 11 May 2021 16:25:35 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>>> You can reproduce this with:
>>>
>>>      http://rostedt.org/private/trace-no-map.tar.bz2

What should I do to make it SEGFAULT?
Y.

>>>
>>> diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
>>> index 225dc34..abef5f8 100644
>>> --- a/src/KsPlotTools.cpp
>>> +++ b/src/KsPlotTools.cpp
>>> @@ -1280,7 +1280,7 @@ void Graph::fillTaskGraph(int sd, int pid)
>>>    						 false,
>>>    						 _collectionPtr,
>>>    						 &index);
>>
>> I wonder why this fails? Is it because "pid" is negative? The fix below
>> is appropriate, however we should detect negative PIDs and abort
>> plotting much earlier.
> 
> I believe the issue is that we failed to map which host task goes with
> which guest vCPUU, and just randomly picked one (or none).
> 
> I fixed trace-cmd to get the mappings when qemu is not found, and
> KernelShark works fine on that case. This bug only appears when it can't
> find the host thread that corresponds to the guest vCPU.
> 
> -- Steve
> 
