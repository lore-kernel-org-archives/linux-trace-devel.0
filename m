Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B09EC352A1
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Dec 2022 09:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLGJ4m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 04:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLGJ4g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 04:56:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0DF37223
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Dec 2022 01:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670406933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ojphaq1iHwcXyLH5W6Z+h2EU2FFjs2keAwhsoLXaNI=;
        b=PUk8iOOrwaelehVqT1Wf16QIQOxpxOBKmzHDiCRPcko7XIccB4qV+2eaDt9mnnkym3C8x6
        DXfwIyCOBJMoAUgegVX6LQQuulXKYZ21qPBPOg8Wr/e7HoP7PdC41KT6yCLJa+J3VcighN
        XYUz54Zfj+hZTLMImYT1yTu72+di/l0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-7z4ly4X1PDqtTlVRjuu6AA-1; Wed, 07 Dec 2022 04:55:31 -0500
X-MC-Unique: 7z4ly4X1PDqtTlVRjuu6AA-1
Received: by mail-wm1-f70.google.com with SMTP id h81-20020a1c2154000000b003d1c8e519fbso569650wmh.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Dec 2022 01:55:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ojphaq1iHwcXyLH5W6Z+h2EU2FFjs2keAwhsoLXaNI=;
        b=LfrBKZ4ix10FaHDBQQlO7DumDQAOL2sGGq1uG8mGbvjJpelvbxMpR7oHq0NMM7fdkM
         RsLhue4j2G6+KVQrO3WeN6/ULCo1XrFXO3N7uAXTID/H0t0BTECqkII8jWFL32S6jpXh
         lphWT8PdmJWE1EY99Dp+sgiY3TsPOAnL0FDmek2FuMjQmuJv5vVsuf0mrvnKYhLMbC+n
         eJJptm6Meg1dqNVaS6jx3iIy7Di/r5W6DfQyWt2T6l5DvZ77fO9uS9skG0ziFMF4IRqQ
         HPje4E0C21DhU33tIfl8mabJeNKQVf1G8TBzdGRAOgfu1BNZpsauZjcDqanM/JHvAui9
         P2og==
X-Gm-Message-State: ANoB5pktpvZ+zmLRboGH+lQvkn3Qnn1c82rX9xvKjDB8PtoUtQVNMda0
        JMtxq3nQGUkkgQhrQHfKUycVcM67Va1Oh0fRB3qWzXtfwEdPAHA5CMzDveGzf/Cru58USJaUoja
        lU8d4NKgXD4jCSIyhVUoGpgpV8NwFiK0=
X-Received: by 2002:adf:e30b:0:b0:236:aacc:ea87 with SMTP id b11-20020adfe30b000000b00236aaccea87mr55911907wrj.414.1670406930763;
        Wed, 07 Dec 2022 01:55:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7qRTJyuS8qSDFaoLkcPzVzlhjXr2T/M6T1etvAzCqY+UqCUZSUVi12LJUJlqI1aCLPC1kwnw==
X-Received: by 2002:adf:e30b:0:b0:236:aacc:ea87 with SMTP id b11-20020adfe30b000000b00236aaccea87mr55911894wrj.414.1670406930566;
        Wed, 07 Dec 2022 01:55:30 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id n6-20020a05600c3b8600b003d1da8c7854sm1166051wms.45.2022.12.07.01.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 01:55:29 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH v2 2/2] libtraceevent: Pretty-print cpumask fields as a
 cpulist
In-Reply-To: <20221206153240.737e378b@gandalf.local.home>
References: <20221116144154.3662923-1-vschneid@redhat.com>
 <20221116144646.3664012-1-vschneid@redhat.com>
 <20221206153240.737e378b@gandalf.local.home>
Date:   Wed, 07 Dec 2022 09:55:28 +0000
Message-ID: <xhsmh4ju7pmgf.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 06/12/22 15:32, Steven Rostedt wrote:
> On Wed, 16 Nov 2022 14:46:46 +0000
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>
> This is a rather complex algorithm (I'm too tired to try to grasp it). It
> really needs a unit test to make sure it's working as expected.
>

I had missed there was already a testing infra for libtraceevent, that's my
bad. I'll convert my local tests to that and ship it in v3. Thanks!

> -- Steve

