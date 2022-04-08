Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43E0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 13:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiDHNvs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiDHNvr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D83DFC882
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 06:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649425778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2/8jlF212Dq8hkyxMbM3GcH6GkK/VKjh9OP6Uu7H4G8=;
        b=TRrfZ96TNAreHPN5zqgIztR/XQ48ybbev4Bvrgs3z4a/P/KCsjAO/2KF+A/EN/Vd1290iN
        DkyvCJVScoaObgXBDllYx2vmb3jJ3E36dMXx4fS3BWSqHu86Z+/RdzA/N+Gtev7EvjJPkn
        mSw2MHuB37GDNk/AE12GqRA3dYL1Mmk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-qNaBfAh6PBGFRWen_LhQDA-1; Fri, 08 Apr 2022 09:49:37 -0400
X-MC-Unique: qNaBfAh6PBGFRWen_LhQDA-1
Received: by mail-qk1-f199.google.com with SMTP id h8-20020a05620a244800b00699fb28d5e4so3630132qkn.22
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 06:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=2/8jlF212Dq8hkyxMbM3GcH6GkK/VKjh9OP6Uu7H4G8=;
        b=l9/VHgUz6x9PrfuJUXeEPrjLnLlQM/Nh52i+buC+6lyexSx5ohr3tN7sJfLmaUP5II
         J6Y049qEgG10Zq2tBpfwDcY9XI3ejKgynV0M2wGhJvKFn7cQKFuWSDrGGW7zpNjJ4ls+
         IjttqzoNonkLqDTsCP6nlzKXafdHICgCbNUQnMh7sG6NVl8MBbGSrv5tM0Ierv55DdW1
         wSgoCAvofZhDfZn9OMekLRzG5/E1BYPNYCQ5aiNPq+ldgHappZERhMF3b5Ao18i72qOp
         KEV/3K/nHz0GiTUgm8EU2ld2Q7nLNxW2HOr/1wDgejcmu6f8kuFptHIcEWM7Ir60qtEF
         O5nA==
X-Gm-Message-State: AOAM533dgETsJvZhzJHIMA88TvY54alPp8XDxxyv2O6xqWoPGneJN0Yh
        SkyjTuQRGTvM0CK5myvnSeLyTLp9cYVszWJNBB6+iRZu3dBwlPexvAw8H8u/YkCx3h5CytdTPwg
        dI6qO9QQXPOSYA/s6T1+JY+M/4bzBHG4=
X-Received: by 2002:a05:622a:64f:b0:2e0:6a11:7b0d with SMTP id a15-20020a05622a064f00b002e06a117b0dmr15799567qtb.9.1649425776816;
        Fri, 08 Apr 2022 06:49:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywxztvYVFzqW0tZLwRDsrMH8wHvSk844odzCLr7i9gAaMUGLRE8wta2F/K7vQWPD5JyW60Dw==
X-Received: by 2002:a05:622a:64f:b0:2e0:6a11:7b0d with SMTP id a15-20020a05622a064f00b002e06a117b0dmr15799554qtb.9.1649425776626;
        Fri, 08 Apr 2022 06:49:36 -0700 (PDT)
Received: from fionn (bras-base-rdwyon0600w-grc-11-174-88-121-127.dsl.bell.ca. [174.88.121.127])
        by smtp.gmail.com with ESMTPSA id f12-20020a379c0c000000b0069a048e7f0bsm2802111qke.76.2022.04.08.06.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 06:49:36 -0700 (PDT)
Date:   Fri, 8 Apr 2022 09:49:35 -0400 (EDT)
From:   John Kacur <jkacur@redhat.com>
To:     Daniel Bristot de Oliveira <bristot@redhat.com>
cc:     lkml <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] rtla: Minor fix to grammar in README.txt
In-Reply-To: <24f79a7c-0146-ad0a-988a-608edd402faa@redhat.com>
Message-ID: <6b8d24c-d793-866c-30a7-f015c7babd2d@redhat.com>
References: <20220402043939.6962-1-jkacur@redhat.com> <20220402043939.6962-2-jkacur@redhat.com> <24f79a7c-0146-ad0a-988a-608edd402faa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Fri, 8 Apr 2022, Daniel Bristot de Oliveira wrote:

> On 4/2/22 06:39, John Kacur wrote:
> > "The rtla" doesn't make sense, change it to "The rtla tool"
> > This is better than removing the word "The" since some packaging tools
> > need the description to start with a capital letter.
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  tools/tracing/rtla/README.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/tracing/rtla/README.txt b/tools/tracing/rtla/README.txt
> > index 6c88446f7e74..3b809eeff5f9 100644
> > --- a/tools/tracing/rtla/README.txt
> > +++ b/tools/tracing/rtla/README.txt
> > @@ -1,6 +1,6 @@
> >  RTLA: Real-Time Linux Analysis tools
> >  
> > -The rtla is a meta-tool that includes a set of commands that
> > +The rtla tool is a meta-tool that includes a set of commands that
> 
> I do not like bike-shedding but 'the rtla tool is a meta-tool" sounds repetitive.
> 
> Does:
> 
> The rtla meta-tool includes a set of commands...
> 
> sound good for you?
> 
> -- Daniel
> 
> 

Perfect

