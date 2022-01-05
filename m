Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A5CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jan 2022 11:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbiAELcM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jan 2022 06:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239712AbiAELcL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jan 2022 06:32:11 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F21DC061761
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jan 2022 03:32:11 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id f134-20020a1c1f8c000000b00345c05bc12dso3132344wmf.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Jan 2022 03:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=V4r04YxH9icIenbLDdpXp9rsygxS3DTAAUIk6Yy5SqE=;
        b=Ob3zf33J48dyPKv6fU6HPi5qnVSTQthRDejiPLk+CukhmKCCzMe4PN3njRChsIAXis
         XT8p4hLpdOVuzZjXzOdYgKkjE6BUmopFyLaRB8D8wDKMX8gitD8Kqei332vAk1TU3W51
         5K8lJe4TmmTC4F9OwopE51zxfMbfTzju0iojT0WHIEbq8ZY8pgR5XWFdOQxWR8u/YMqV
         MntAFmyW+ecqV3JEeLvBvxRz2yIeUR2ILMTgPznenNHDEo634/gp1+4oE/9jaej7cCzu
         /JpsQ55s0f8gsb2BTH4GKhVEdgvSGPztVqREBmKrBiGeTngiUuEc8/GUs9BzbNfdsHlD
         cqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V4r04YxH9icIenbLDdpXp9rsygxS3DTAAUIk6Yy5SqE=;
        b=jCouIlUoN3iQeIclkiWihtpkcQ5buwK/GNuQ9bbHVpXKFEA3rR595YKH2a2TSsat6r
         s/smqWGxBkZNZ6lXkzHnb4JEeQPzrrDOTmfcFN/8A+jzDPaIjIzTUj5Z1y7WJM7EZdcp
         3dncoSvcf4TPUihosPEwNWfpGJdGceTQ6Z647YMS3jDiNp+57C4klmwADW6YkVuq4h0H
         lp4qJCDHsq5B31TpASyMz0HE2ceBI65yo2MmN/hI5IqbOGjT/S+pT8j3TqzMTVrH836D
         SitHFEeAeHIDVOFHPECaMHaptbrWRrbkmXHugPrgIyv+qaxfzeE4typWIyT5YmetmFRH
         G7ng==
X-Gm-Message-State: AOAM532g6oH4u/RVhmtgF/DWeV7CV+Fi31EdCsHLYEPsuZvt0Qhg3QRG
        mshDlAn6O07rAFnM4HeTHldoxoNi1vE=
X-Google-Smtp-Source: ABdhPJw7J62Q9W6K2Z3eZ1akP7cmc6OK6A70K8lOowr6kyH9X86IRQKfdf1KRny8WntNny8nveNSSg==
X-Received: by 2002:a7b:c202:: with SMTP id x2mr2446045wmi.57.1641382329886;
        Wed, 05 Jan 2022 03:32:09 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l8sm42197423wrv.25.2022.01.05.03.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 03:32:09 -0800 (PST)
Message-ID: <9587a26b-e9fb-a9b4-c94d-29354abc3b84@gmail.com>
Date:   Wed, 5 Jan 2022 13:32:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 0/2]kernel-shark:add new plugin for xenomai
 cobalt_switch_context events
Content-Language: en-US
To:     Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20211222064014.4471-1-hongzhan.chen@intel.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211222064014.4471-1-hongzhan.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.12.21 г. 8:40 ч., Hongzhan Chen wrote:
> 1. To avoid code duplication, move some common APIs and definitions
>     out to create new files and share with other plugins.
> 2. add new plugin for handling xenomai cobalt_switch_context events
>     to visualize OOB state of RT tasks.
> 
> I tried to move common APIs and definitions to KsPlugins.cpp/hpp but
> found these definitions finally depend on KsMainWindow object used
> by _doubleClick of LatencyBox assigned by plugin_set_gui_ptr via
> KSHARK_MENU_PLUGIN_INITIALIZER.
> I do not know how to remove this dependency so I create new files to
> avoid code duplication. Please suggest if there is better way.

Hi Hongzhan,

Indeed, this turns to be a bit trickier than I expected, but it is possible.
I will comment in the patch.

thanks,
Yordan

> 
> Hongzhan Chen (2):
>    kernel-shark: Move common APIs and definitions out to avoid
>      duplication
>    kernel-shark: Add plugin for handling Xenomai cobalt_context_switch
> 
>   src/libkshark-tepdata.c                    |   1 +
>   src/plugins/CMakeLists.txt                 |   6 +-
>   src/plugins/CobaltSwitchEvents.cpp         | 125 +++++++++++++++
>   src/plugins/CommonSched.hpp                |  99 ++++++++++++
>   src/plugins/SchedEvents.cpp                |  87 +----------
>   src/plugins/common_sched.c                 |  37 +++++
>   src/plugins/common_sched.h                 |  50 ++++++
>   src/plugins/sched_events.c                 |  37 +----
>   src/plugins/sched_events.h                 |  12 +-
>   src/plugins/xenomai_cobalt_switch_events.c | 169 +++++++++++++++++++++
>   src/plugins/xenomai_cobalt_switch_events.h |  54 +++++++
>   11 files changed, 545 insertions(+), 132 deletions(-)
>   create mode 100644 src/plugins/CobaltSwitchEvents.cpp
>   create mode 100644 src/plugins/CommonSched.hpp
>   create mode 100644 src/plugins/common_sched.c
>   create mode 100644 src/plugins/common_sched.h
>   create mode 100644 src/plugins/xenomai_cobalt_switch_events.c
>   create mode 100644 src/plugins/xenomai_cobalt_switch_events.h
> 
