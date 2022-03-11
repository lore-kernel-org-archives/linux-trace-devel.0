Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67735C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Mar 2022 16:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbiCKQdr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 11:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiCKQdq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 11:33:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D77E351E56
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 08:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647016361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wIiyo/Hz9JMpDwt94KYeCOdCYlTzYuM5+GHnQsk/7+4=;
        b=XfBXaUe1mvTlppshHGteBc5saB2kMeAv9RlR0Iz94zBe+ChNOD0PgFr7DIbq+krAP4rOf+
        7PZgLloUjsa0dNRyymnJQ07lsXek/90L881ZYUvWf+qdR2sDFqb2X8/qGK8ne4Z/xHHxlC
        2eumQNcp2DruZ9LypirKR9xtTt9l3JU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-mHt-TQYqPkCAKV3aazC2jw-1; Fri, 11 Mar 2022 11:32:40 -0500
X-MC-Unique: mHt-TQYqPkCAKV3aazC2jw-1
Received: by mail-wm1-f70.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so3640751wmc.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 08:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wIiyo/Hz9JMpDwt94KYeCOdCYlTzYuM5+GHnQsk/7+4=;
        b=7J7+aJwlSfMgswTrUPlLxIMVvcVAaWMjdUCksI58UjdmuMutuAFyzP3C9wIFpBd7Uc
         pcpsMDodZarcTnPtiX9OaMBaRLEMoUhRCi6H5bCbzr0n9evwLBDf2mnkZ66qYMmRXI3u
         qJz5ce2K4VsniF2aSLAhhwXwkvJftfq0x+Jdqhl5RM4j4W3U+BeFGF6j2BEdlJ+MIA9r
         EsXonjq6eP8KW5k+o0Na2w79kEhvn8WY0coVr0ksluwtorJhTkqaXoMXjR/GsswmtjoD
         NYzx+9GHHNo+sKaEFNUWzfbm8ufxyp+xHU9HdYNIk7mfNiFcj9lcQ3iz+j70zEkN93P7
         Fbng==
X-Gm-Message-State: AOAM532ZZNfnH0oMUt+vyYp111UX5GpBGi16ieNIsblTCksRk0hkjdZr
        N0KzOteJYk3flcyZqvsby6D+DS8f81jtk6cOT+JwtP12kMWEyLTZzLyEbjJwMXZHC+5S9arvrav
        EXjHq8KrlN4bezl0lY9ohtV1GlI6skDI=
X-Received: by 2002:a05:6000:1104:b0:1f9:7df6:c864 with SMTP id z4-20020a056000110400b001f97df6c864mr7890479wrw.63.1647016359447;
        Fri, 11 Mar 2022 08:32:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxW7xVvJKrOS4i/VOXAwIU8h5bRNK36QLS+yGu7beP2gTUOBkmEGhe0SKy7JrVLcX09APi9Jw==
X-Received: by 2002:a05:6000:1104:b0:1f9:7df6:c864 with SMTP id z4-20020a056000110400b001f97df6c864mr7890465wrw.63.1647016359206;
        Fri, 11 Mar 2022 08:32:39 -0800 (PST)
Received: from localhost.localdomain ([2a00:23c6:4a1c:5a01:f0e6:1d65:f381:51c4])
        by smtp.gmail.com with ESMTPSA id i1-20020a1c5401000000b00389f76c1325sm578681wmb.47.2022.03.11.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 08:32:38 -0800 (PST)
Date:   Fri, 11 Mar 2022 16:32:36 +0000
From:   Juri Lelli <juri.lelli@redhat.com>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Clark Williams <williams@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V3 00/15] rtla: Improved tracing support
Message-ID: <Yit5pMZVCPFAXE/e@localhost.localdomain>
References: <cover.1646247211.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1646247211.git.bristot@kernel.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On 02/03/22 20:01, Daniel Bristot de Oliveira wrote:
> This set introduces some tracing facilities to rtla tools:
> 
> - Add the possibility to change the tracing_thresh to osnoise,
> allowing a fine tune of OS noise detection.
> 
> - Add the auto-tracing feature (-a threshold us), which aims
> helping the first approach to a problem by setting common
> tracing features with a single parameter.
> 
> - Add -e/--event option, allowing osnoise and timerlat to
> enable additional trace events via (possible multiple)
> -e sys:event options.
> 
> - Add the --filter option to filter the previous -e event.
> 
> - Add the --trigger option to allow the usage of tracing
> trigger of the previously set -e event. If the trigger
> is hist: one, rtla automatically saves the hist file
> associated with the -e event.
> 
> And some more improvements:
> 
> - Add --dma-latency option to tune exit from idle latencies
> 
> - Some minor fixes
> 
> Changes from V2:
>  - Rebased to for-next
>  - Add --dma-latency
>  - Some more fixes
> Changes from V1:
>  - Add -e to osnoise/timerlat hist
>  - Add --trigger
>  - Add --filter
>  - Add support to save hist file
>  - Function name refactoring

I took this for a spin and it looked good to me!

Tested-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

