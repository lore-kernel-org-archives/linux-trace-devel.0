Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6597ECAAD5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 15:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343514AbiHZP0E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344578AbiHZPZN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 11:25:13 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5345A817
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Aug 2022 08:20:58 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id sd33so3768575ejc.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Aug 2022 08:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=T8bVt1uu6tSAWPK0NNoAijbWwBZZjhspjR4nZA6Yaso=;
        b=a+CXQf/bveIwaX1wJofMPwfn6PSW/eYpe/FDT2WQByOU8DrqyDV6zKUemO7iIsXUl8
         Sj94jvnxJXGSWk4OFjS3fJirrXVm4ti57fjb4qVBXdZpmPmi5/3Sl0u4Uv1pGA/GtDiJ
         uQ18nyc4awbv7ScnABWMCIYgDfMfpAJKfQfL2kcAapxVbPHWh9wXdM3aHDqjvU1fABmS
         IHwgBkUaHXFP5paANPm5zmf/HGJa22cEcqrYogjKx2L4GqNxrnwyFJoBdgqZ+CwHRX1R
         OBtq0XzYSiFGYedL6mYb2lTctsb1lJQmHUzCd35ymMOBu4D2DJiRQkGzILJdrUdZpH3j
         9u3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=T8bVt1uu6tSAWPK0NNoAijbWwBZZjhspjR4nZA6Yaso=;
        b=pn78mrBsbcq3L/oJBG3FjBQr184jVpUq/3CI0AmLn2BIgj/D1DQykfyJdTKmhkiEGt
         DTAkX9eO8xM+6MmKdTKXRKaDMYjAj3MakkUi0LWJjsygYcOL5U37dlEM9awfiK3+F8Zu
         CCcLBgiavTryZFxRXGF2eVYngxz3W5CC1CEoMHJeNtstpJcKsWq8xdDpWJgKbJdDZ5uo
         8oFe7Af3lLC0HU92jBiPPsthPvD9sYh2J4Ja8+T8bkyfHd0bcJmx5MlnQMRizrxUmHfk
         fkbsFGvbe0Iy4eNzn1VTBXWh7UyLJCar9TMuTQFaj6+3vW3h2qFf9E7Zl4CoJ4WNgmZY
         wssg==
X-Gm-Message-State: ACgBeo334vq30O7PqdqEJ0PWuqVYz1eFKhZWr2cXAzfQqtnYov4ddNQ7
        TuEpx0ZB4pkChW/vCthAf6OwJDGhB8A=
X-Google-Smtp-Source: AA6agR73HrpDO9u/dyazKNxN0W+82euXTprGQ20Qlpz27Hv53fJBR8mLaaoKwbPbs+FWWWRFHHfasA==
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id xh6-20020a170906da8600b007407120c6e6mr1796101ejb.44.1661527256788;
        Fri, 26 Aug 2022 08:20:56 -0700 (PDT)
Received: from [192.168.1.10] (213-91-248-192.ip.btc-net.bg. [213.91.248.192])
        by smtp.gmail.com with ESMTPSA id c25-20020aa7d619000000b00447b5c37768sm1416984edr.42.2022.08.26.08.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 08:20:56 -0700 (PDT)
Message-ID: <2f68dfa2-81eb-d07c-75ae-1b79a9007a21@gmail.com>
Date:   Fri, 26 Aug 2022 18:20:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH kernelshark] kernel-shark: Build missed_event as GUI
 plugin
Content-Language: en-US
To:     Daniel Wagner <dwagner@suse.de>, linux-trace-devel@vger.kernel.org
References: <20220824135309.5347-1-dwagner@suse.de>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220824135309.5347-1-dwagner@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Thanks Daniel!
Yordan

On 8/24/22 16:53, Daniel Wagner wrote:
> missed_events depends on GUI elements hence it should be build as GUI
> plugin.
> 
> Signged-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> I had some build errors due to global build flags in our build service:
> 
>    Linker flags : -flto=auto -Wl,--as-needed -Wl,--no-undefined -Wl,-z,now
> 
>   src/plugins/CMakeLists.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
> index e9d906863424..49aee3ed7560 100644
> --- a/src/plugins/CMakeLists.txt
> +++ b/src/plugins/CMakeLists.txt
> @@ -61,8 +61,8 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
>   
>   endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
>   
> -BUILD_PLUGIN(NAME missed_events
> -             SOURCE missed_events.c MissedEvents.cpp)
> +BUILD_GUI_PLUGIN(NAME missed_events
> +		 SOURCE missed_events.c MissedEvents.cpp)
>   list(APPEND PLUGIN_LIST "missed_events")
>   
>   install(TARGETS ${PLUGIN_LIST}
