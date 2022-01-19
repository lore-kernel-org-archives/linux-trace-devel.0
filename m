Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B2EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 12:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347096AbiASMKP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 07:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiASMKN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 07:10:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4524C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:10:12 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m11so10053703edi.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=4Kyj4IJv8mTRIlZkREERMC06l5MSMqilnOZUMF6esnE=;
        b=DT7Jo5YG0MkDF/WfuVJgxZHn+Xl9ewOfpLro0kL/M/oQOs6SoiXZmAWS4p4i/fhjLY
         FqwkTaGCszkz9JNJ5hhHGGx4rYAfBEcdwuap1UHvnJHpLeki7cJ0gUW0aMowm8aVWd2F
         8gxUh/MWaVL+KsmGBES1nhXyyGjQ/JnM+rh9P5J+Krlt4YSFm6jsWz0WmHQ+ENBhYcgo
         WNpG3pueAXFQztCd84qYyYaS7vVoCqDsDKL7IJqjDWACFcLSKqyKJMcRDcmIjz287dH2
         YBPxeVzwPvBytLrT0IDoJndRfQkcJqkqqHmyiFAtkK/5EqEvrou+4O+EClq2lVygGiA1
         AT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=4Kyj4IJv8mTRIlZkREERMC06l5MSMqilnOZUMF6esnE=;
        b=M+zmzEzCOIHn0FUgBwyVudv3ToehlKlhM7U2DPpsRztd5+wuR3ENbncbfbqXEIYMtv
         NWuX5aD92xcJEgmWQDFoWh2E72WzM85sRce9PHeBjmupKZx8a3x+3GHo/raRFajJ+Kp8
         5juZ1Hbfa5e3MILeRWkYO0h/CLLBBePyV74VGORj94YWmYZ8WA2DWzmWBUyTXkzXt/5O
         Lqaz+f2p2jbrbZzlXeTORXLU8sg7H1Na4OZsWDR8ABFGFbdofAKF1wXjCsPwheqlRvUV
         8NSmcKQJb4UznZoKPEyBUCqC7yCF+YNtpkDf64erIxi5Ta6TChqegTBqomNQeuukH00S
         nKfw==
X-Gm-Message-State: AOAM5323JgtZtZQ4+yTJLeRwMURfFjn0S8pW9gS+AXjZ9WctEbE94Vsz
        8zmV1rx00DW6aVctJj8dy5hYOfp/mTU=
X-Google-Smtp-Source: ABdhPJy29KQop2seV+AYV1+aOD4PIEj7RW4YyQzMlfGlV1bNoOjNmzk63+uitC4zRO3iESJV8zYnsg==
X-Received: by 2002:a17:907:1c03:: with SMTP id nc3mr23639359ejc.145.1642594211067;
        Wed, 19 Jan 2022 04:10:11 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id 21sm6283915ejz.24.2022.01.19.04.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 04:10:10 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------hD1Q4HebskeGP2PROu4LSerE"
Message-ID: <27543723-5970-a968-30ab-e30e5731e53a@gmail.com>
Date:   Wed, 19 Jan 2022 14:10:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org, hongzhan.chen@intel.com,
        jan.kiszka@siemens.com
References: <20220119120229.68627-1-y.karadz@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220119120229.68627-1-y.karadz@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------hD1Q4HebskeGP2PROu4LSerE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

And here is the version of the plugin that can build standalone. In order to load it just do:

kernelshark -p path/to/xenomai_cobalt_plugin/plugin-xenomai_cobalt_switch_events.so

You can also load it from the menus.
Note that I only tested that it builds and loads successfully but I have no data file that contains 'cobalt' events.

Cheers,
Yordan


On 19.01.22 г. 14:02 ч., Yordan Karadzhov (VMware) wrote:
> Hi Hongzhan and Jan,
> 
> I tried to build your plugin standalone and I realized that this is
> in fact not possible due to some missing header files. This gets fixed
> in the following patch-set. I also made some minor modifications in
> the code of your plugin and will send you this modified version of
> the plugin in a separate email.
> 
> Please let me know if you find this modifications useful or not?
> 
> Cheers,
> Yordan
> 
> Yordan Karadzhov (VMware) (2):
>    kernel-shark: Add KsPluginsGUI.hpp/.cpp
>    kernel-shark: Install missing headers
> 
>   src/CMakeLists.txt         | 12 ++++++++++++
>   src/KsPluginsGUI.cpp       | 27 +++++++++++++++++++++++++++
>   src/KsPluginsGUI.hpp       | 22 ++++++++++++++++++++++
>   src/plugins/CMakeLists.txt |  4 ++++
>   4 files changed, 65 insertions(+)
>   create mode 100644 src/KsPluginsGUI.cpp
>   create mode 100644 src/KsPluginsGUI.hpp
> 
--------------hD1Q4HebskeGP2PROu4LSerE
Content-Type: application/octet-stream; name="xenomai_cobalt_plugin.tz"
Content-Disposition: attachment; filename="xenomai_cobalt_plugin.tz"
Content-Transfer-Encoding: base64

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
--------------hD1Q4HebskeGP2PROu4LSerE--

