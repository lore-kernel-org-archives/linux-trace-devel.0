Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3544C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94AE861261
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhEQNFk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhEQNFj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:05:39 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883DBC061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:04:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l1so9094213ejb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s08gsmauzoZfUq3ECPWSbD8nk23tSjYwviTeCzjGiVA=;
        b=ChdLU+/BGPNvfaAW+w99e6524I2NqwuESDXacu1E0fLH7fCYDaebP4DeTNYv23ierE
         wtLJKPYXNSpjVA8AjhHho9xi0NSDB+jkAbSeFFEI/5jJCI/0QeoygsIgKnQ9APsjjO0e
         9l6hql3w1BlP7fs2svxLMTg44tlbxHsjUNMHjeNKBVAAZXbiQp+9fcA5/Cus+NOFiJyL
         HBHU6KcAXod4lQtfdQ5mBW7lNrrEpBPgioWVKPvTGOIl2b34ZbyVnvgRnNJLfsg1xhVT
         r45CYkBxMJI6CcxjLwAizYV/9k0AkslRuIB643J2GpPLrpRFD9nIUKqwu/n6Z3rk3W4J
         fGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s08gsmauzoZfUq3ECPWSbD8nk23tSjYwviTeCzjGiVA=;
        b=gc9LixIoD2P/aVdZjdBel4138bkuQnwBghVxDy2XTZAQapoegtS8ShuGsxfM5WiAX3
         KTM4/u5Mx2ooTW+xRQhC6nQRIbHU5PSLyyPVmdn15OQBRnyZXLMCGhVEIEODsrCSC9uN
         hynfECVWA5aezqlFMZlxxh7Bsy6E6LpUk5/INRUnlDXb9WA4Fo2uF5Fez9k6tFwbU5vU
         1wZ1lyMnZvYF/H3s9MvCkGpHfYCJ70M2GKe+knOQcq0n3iTAHYqEfYcSeZ+49+m8/xxE
         g1NvKmDUveO8KbL5Z7aU9IZIxT0wx7ju6PoVgtOBesCr483MMkpkPdHL5Rxr03P9KgWf
         6qjw==
X-Gm-Message-State: AOAM531dPaaie3HPStpTrKZDx6NT9+RIy/FeN4PvOYPRh9zbU/JJLDaT
        zHG0Ubu6O49070kIiqT96FDn+6qTBTo=
X-Google-Smtp-Source: ABdhPJybO9CySycn62Xm0e8hegjHs1sGP6sgXZ9YAuU6fS4vakPjRPkFtM6FKpoWm7EbGcv7O374sg==
X-Received: by 2002:a17:906:7c82:: with SMTP id w2mr63202252ejo.448.1621256660913;
        Mon, 17 May 2021 06:04:20 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id h13sm10609846edb.65.2021.05.17.06.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 06:04:20 -0700 (PDT)
Subject: Re: [PATCH 0/7] Final fixes before KS 2.0
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210514121826.161749-1-y.karadz@gmail.com>
 <20210514140109.5615e1a2@gandalf.local.home>
 <1edacb8d-3ad3-73c4-fdd5-09baa908d404@gmail.com>
 <20210517085442.6be8723f@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <c4265d75-e658-0b40-6173-265098fa71d7@gmail.com>
Date:   Mon, 17 May 2021 16:04:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517085442.6be8723f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.05.21 г. 15:54, Steven Rostedt wrote:
> On Mon, 17 May 2021 13:22:34 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> On 14.05.21 г. 21:01, Steven Rostedt wrote:
>>> On Fri, 14 May 2021 15:18:19 +0300
>>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>>    
>>>> Yordan Karadzhov (VMware) (7):
>>>>     kernel-shark: Preserve markers when appending data
>>>>     kernel-shark: Preserve open graphs when appending data
>>>>     kernel-shark: Clear before loading new session
>>>>     kernel-shark: Better handling of plugins when appending data file
>>>>     kernel-shark: Do draw the combo point of the mark
>>>>     kernel-shark: Check if "trace_seq" was destroyed before using it
>>>>     kernel-shark: Quiet the warning printing from libtraceevent
>>>>
>>>>      
>>>
>>> After applying and testing out this patch set, I realized that the appended
>>> file does not have any of its CPUs plotted after it is loaded.
>>
>> Yes, this is how it works right now. No new plots are added when you
>> append trace file.
>>
>> Do you think it will be to show all CPU plots from the new trace file?
>>
> 
> Yeah, I think it is better to see something than nothing.

OK, I will send v2 that is doing this. It will be a trivial change.


> 
> I don't think there's an issue with showing it. Although, if you could
> automate the kvm combo to be selected by default on appending a file, then
> you wouldn't need to show the cpu plots of the guest.

This can be done as well but it may be a bit tricky. We should probably 
also provide a command line option for selecting combo plots.

But let's release v2.0 now and keep this feature for v2.1, together with 
the other features you requested on Bugzilla.

Thanks!
Yordan

> 
> -- Steve
> 
