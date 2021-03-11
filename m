Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE25C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BCDA64FF2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhCKOQ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbhCKOQC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:16:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23713C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 06:16:02 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id mj10so46498952ejb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 06:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1gpgS6euXNIYPRL3jo6ffWEdSULacT1k0Qqy3hrRFLE=;
        b=GkwY2jWAI+dOaz82Tr5LRD3lgkkGw5/dlqYXko93cvXtrVWlChoANud6arlD55361D
         WYLrshdbx2sW64qb+gs2mVCj9a/HcG9o8o12Vz+sYOpRWBeSQr1vJ0GElQP+cop45UJ+
         F4F0vada0gFJXlv8GXVn7BwUSQsQ3AagVtCtZLqRyIXGO5BLOS6HbXIJXEvu1yQH6hsY
         OO5r6k/QYyEoD8vkBfUXh64K0r3/JCF6BFK17YfxJmaitxq/aPa8VT8qld17ThW+Q+eu
         P/vI6trsfEJHKp3N9Yaj6tjJBat4ZHVs+QHNUMuYZc7rdNT+QW85a4eKIZk5dLv266+o
         miKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1gpgS6euXNIYPRL3jo6ffWEdSULacT1k0Qqy3hrRFLE=;
        b=N3x55wQEfN3WmB6J2aGu4Y+38BEfNsvuBtUprZ31bu9X1FkA6C5vBi9qKIegTG7jAt
         5oav1pLYaU6MyB1ljdYysN5XcX0Q3ln26Ow9SxgPZPGyi120BBYiV+jCuMdYUapAe0pv
         hTmWc0Qvxos7uLJCz/B/II3m1W1yoq5XRnFSkf3CzRB5J+x6aIlOZCD6ZgOZfyj8Z+YY
         941naWNOelFEhd48dJzMRSjoPeYvd9eZOL/HVDNdaYHUAxNIU9GPM5SVcB8/QMYQ7osR
         ZxR51wG2vuLaNidDxu2jq+IyVBDY9BE8eqxrjrp3lrmCC51y4gPW1p/TY/nwdSeZu9YC
         M1Eg==
X-Gm-Message-State: AOAM5320kevic8VM2IsbGUDG7luJFhzpWSRHDpnLeUMx577YCT/euGnW
        zamqJ+aTBlswc3Amx3Jgn62onUtelRTVpg==
X-Google-Smtp-Source: ABdhPJynNsDV3aNoUGucLXf5YwlXO8WSGnMl5TZXeqPIEbtttiBjR/qHYd65Itw0zhJvRtC6FPIN2g==
X-Received: by 2002:a17:906:3295:: with SMTP id 21mr3287996ejw.88.1615472160656;
        Thu, 11 Mar 2021 06:16:00 -0800 (PST)
Received: from [192.168.0.109] ([84.40.73.174])
        by smtp.gmail.com with ESMTPSA id p19sm1398274edr.57.2021.03.11.06.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 06:16:00 -0800 (PST)
Subject: Re: [PATCH] kernel-shark v2: Change the logic for opening trace-cmd
 files
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210310121135.1620453-1-tz.stoyanov@gmail.com>
 <20210310164839.475d10be@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <42d08f5e-d681-715b-9f40-5763c4332394@gmail.com>
Date:   Thu, 11 Mar 2021 16:15:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310164839.475d10be@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.03.21 г. 23:48, Steven Rostedt wrote:
> On Wed, 10 Mar 2021 14:11:35 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
>> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
>>
>> The logic for opening a trace file by trace-cmd library has changed.
>> Any timestamp corrections, found in the trace file metadata are applied
>> automatically. The old APIs, used by KernelShark for pairing trace files
>> from the same host-guest traceing session and adjusting timestamps are
> 
>   s/traceing/tracing/
> 
>> now obsolete and should not be used.
>>
>> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> The from and SOB should be Tzvetomir Stoyanov (VMware), unless you changed
> your middle name to (VMware) ;-)
> 
> As for the rest of the patch.
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Hi Steven,

Thanks a lot for the review!

Have you tested that this works with the Timestamp synchronization 
patches that are not upstreamed yet?

Thanks!
Yordan


> 
> -- Steve
> 
