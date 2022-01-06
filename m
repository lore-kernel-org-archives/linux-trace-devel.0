Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B431AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 17:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbiAFRdP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 12:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241895AbiAFRdD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 12:33:03 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2CC061201
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 09:33:02 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b13so12177505edd.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jan 2022 09:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Fhadj6Vs2dFl+kRTGIa9kQX1zrycgOEMsvTiKTDD2m4=;
        b=Afs3wKJdRRD3uobuy/Z/tyNn/GdU29yGzexHnR9kKV47cC+vbUA/mWuxTPKOUvz/GI
         +vK4Dz5pYMKmVGq/g9ZXuZBzYWwzkk1bbj7PSBLKYcNY5IyggtT+mu9knDSsmSTRWcJ/
         u7iJHuCJH26BJQDWq2CCa/9YUjzsqbry8vd+MGaIXOSQqE2YnGRwY6T2sJHzZl+2zBvK
         pnTrdmDden38ZQDbt0EMc2vq1ZKDmENxYsb7ZaVK3tF4a5OjVL8z/lZYExy1JOblNu/L
         Y6/cjQP6QcDuZ1TRAAwvxrPgKJl3494QW9Ftccoh2b1HmiMlO/TUXj+0ooOAme5uH4d9
         K8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fhadj6Vs2dFl+kRTGIa9kQX1zrycgOEMsvTiKTDD2m4=;
        b=L+zPECdo/bpWcxX65mBydtajTS28HaaG7bEqpUvzttxZ2Ne1zo/k+vEP1jlqzCtCt7
         MmHQQT2AP1XwZg5lt5iqUQbYK1cBhbVPecQdGmCQdFM8YDsIZ1GIYvsks4wvr3eQLY+O
         2BY2J4ybVmVZPAhEsv0exsjKZ1lVwzlvUB4ipgAsTepLOGG6suBl+bkX+Qwm2xW5vK4d
         mAnCHUNViWvZ8gnaGBp2FVA8BJq4MjIFa9t299lNwfJF6OmZRjhjamM78GEcgTsHQUwf
         FKY8FHyLY4PNhHYRTBkBp7NAZvAZ36X2kfofplA8dhc6eNTIBTeYH3tYW+F/dIe5VSR8
         pdBA==
X-Gm-Message-State: AOAM530fliZmlGlgPLmUDEH6rMVPdU+zc/AGZRh0XM6qyUtan7XGovNp
        M2avPQci02CP6LVBEDWMkLI=
X-Google-Smtp-Source: ABdhPJzRwF5YIavxO2kHpv5N0IvA/Vha36hMT6nIzTJVAmnHOX6aceapB6GVvVH8z6wqUKSRSWN9Eg==
X-Received: by 2002:a17:906:dc91:: with SMTP id cs17mr46412740ejc.568.1641490378064;
        Thu, 06 Jan 2022 09:32:58 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hw8sm642328ejc.198.2022.01.06.09.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 09:32:57 -0800 (PST)
Message-ID: <5de4819d-2f49-86c0-900d-a4aa585b67ec@gmail.com>
Date:   Thu, 6 Jan 2022 19:32:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 0/2]kernel-shark:add new plugin for xenomai
 cobalt_switch_context events
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Hongzhan Chen <hongzhan.chen@intel.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211222064014.4471-1-hongzhan.chen@intel.com>
 <20220106121854.106d5b27@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220106121854.106d5b27@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,
Happy New Year!

I already replayed, asking for some minor corrections.
https://lore.kernel.org/all/bb1741d5-600a-82a9-d8bc-91222400e129@gmail.com/
I think the plugin is almost ready.

BTW have you finished the renovation of your office? If yes, I will send you a review for your trace-cruncher patch.

cheers,
Yordan


On 6.01.22 г. 19:18 ч., Steven Rostedt wrote:
> 
> This was sent during the Christmas vacation. I don't want it to be
> forgotten about.
> 
> Yordan, what's your thoughts on this?
> 
> -- Steve
> 
> 
> On Wed, 22 Dec 2021 01:40:12 -0500
> Hongzhan Chen <hongzhan.chen@intel.com> wrote:
> 
>> 1. To avoid code duplication, move some common APIs and definitions
>>     out to create new files and share with other plugins.
>> 2. add new plugin for handling xenomai cobalt_switch_context events
>>     to visualize OOB state of RT tasks.
>>
>> I tried to move common APIs and definitions to KsPlugins.cpp/hpp but
>> found these definitions finally depend on KsMainWindow object used
>> by _doubleClick of LatencyBox assigned by plugin_set_gui_ptr via
>> KSHARK_MENU_PLUGIN_INITIALIZER.
>> I do not know how to remove this dependency so I create new files to
>> avoid code duplication. Please suggest if there is better way.
>>
>> Hongzhan Chen (2):
>>    kernel-shark: Move common APIs and definitions out to avoid
>>      duplication
>>    kernel-shark: Add plugin for handling Xenomai cobalt_context_switch
>>
>>   src/libkshark-tepdata.c                    |   1 +
>>   src/plugins/CMakeLists.txt                 |   6 +-
>>   src/plugins/CobaltSwitchEvents.cpp         | 125 +++++++++++++++
>>   src/plugins/CommonSched.hpp                |  99 ++++++++++++
>>   src/plugins/SchedEvents.cpp                |  87 +----------
>>   src/plugins/common_sched.c                 |  37 +++++
>>   src/plugins/common_sched.h                 |  50 ++++++
>>   src/plugins/sched_events.c                 |  37 +----
>>   src/plugins/sched_events.h                 |  12 +-
>>   src/plugins/xenomai_cobalt_switch_events.c | 169 +++++++++++++++++++++
>>   src/plugins/xenomai_cobalt_switch_events.h |  54 +++++++
>>   11 files changed, 545 insertions(+), 132 deletions(-)
>>   create mode 100644 src/plugins/CobaltSwitchEvents.cpp
>>   create mode 100644 src/plugins/CommonSched.hpp
>>   create mode 100644 src/plugins/common_sched.c
>>   create mode 100644 src/plugins/common_sched.h
>>   create mode 100644 src/plugins/xenomai_cobalt_switch_events.c
>>   create mode 100644 src/plugins/xenomai_cobalt_switch_events.h
>>
> 
