Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7ABFC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 08:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC1D613F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 08:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFJIWU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:22:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229910AbhFJIWU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 04:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623313224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qx21ouTjaf4akX/OCDVH92ZUN0/idlWW5/RDRzIggyQ=;
        b=J7/8XU92/aTXuGxBdwGTbb78CRzH4kzotygGQrV8miIyu7+9ABkUsJIZRGMdZdpBPycFi5
        h3Rso6ObAkIGuORFKMFEe6FFRuFYXzabI3I6hPNN560LHzhFXgjcTxYkWtMhWdDCsg6n9G
        w5X5KcV7jyja4xmQKzJg3yNmc4MrsGM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-bnNr215iNVWfKFT7DcN9Hg-1; Thu, 10 Jun 2021 04:20:20 -0400
X-MC-Unique: bnNr215iNVWfKFT7DcN9Hg-1
Received: by mail-wm1-f69.google.com with SMTP id f22-20020a1c6a160000b029018f49a7efb7so3570599wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 01:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Qx21ouTjaf4akX/OCDVH92ZUN0/idlWW5/RDRzIggyQ=;
        b=P+CFc+AYpU3V3JvQse/BPPb6C8wQlW0efcq13LpI9s/NuXErn7e3xMHR7OtSUlmZsd
         ZhWqdKQQYAqN8SEM9iBOHMYh1xmM9Xri/si4MCX5sB8AvInUleBj4ESDQAvVuyPF/92T
         z4++nWqbdT1K6BSfMSXENRgEFRD0VaQocktdp+aD4F1KgDKS3UGHM0qd4faJzqu3FRw4
         AQT5gMfvUELsySUOOO8y0UqwT9TmAhmWsTJCqzKNlLJU+JHwC8/Nsq2rDKx7YVFbhGJ8
         BT0y0KKaGRrci4dLxUCp07otr7cDYNMvbOoB3hM0oJYspeJGCWwOce/3PedLLL6fmYqH
         2WUg==
X-Gm-Message-State: AOAM530heQtrIUlypzF0xymkAZj+ycQpjrUNSwLe1oJmmuTGmZfsRgWT
        BVYzb1i7HNF2PfCkTmKrV35SbxyqWpQsND2pd5DTu0iYiWDhfEOEyRwPNXhEEH8k3/IkZ2///kM
        4FDY79B5APK0RG1sIWC1vIY+rx7fyYR0=
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr9721082wmh.101.1623313219170;
        Thu, 10 Jun 2021 01:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4boa7mK3ZEt43y2pcFzTTKNoh5gEWc0KNSOURuX0FOZB8K8neTXDpJ2Z9zYm7VYlozuiTRQ==
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr9721071wmh.101.1623313219048;
        Thu, 10 Jun 2021 01:20:19 -0700 (PDT)
Received: from ?IPv6:2a0c:5a80:3d14:2800:933d:abfc:d8e4:637f? ([2a0c:5a80:3d14:2800:933d:abfc:d8e4:637f])
        by smtp.gmail.com with ESMTPSA id d131sm8681438wmd.4.2021.06.10.01.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 01:20:18 -0700 (PDT)
Message-ID: <9d7604e64497510a118826fe51c8950d188f667c.camel@redhat.com>
Subject: Re: [PATCH] trace-cmd: Add option to poll trace buffers
From:   Nicolas Saenz Julienne <nsaenzju@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Thu, 10 Jun 2021 10:20:18 +0200
In-Reply-To: <20210609161717.10e259b2@oasis.local.home>
References: <20210602090803.12233-1-nsaenzju@redhat.com>
         <20210602100542.076a4b4e@oasis.local.home>
         <20210609161717.10e259b2@oasis.local.home>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2021-06-09 at 16:17 -0400, Steven Rostedt wrote:
> On Wed, 2 Jun 2021 10:05:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed,  2 Jun 2021 11:08:03 +0200
> > Nicolas Saenz Julienne <nsaenzju@redhat.com> wrote:
> > 
> > > NOTE: I'm aware that TRACECMD_RECORD_POLL kind of clashes with
> > >       TRACECMD_RECORD_BLOCK. That's why I renamed it. There might be a
> > >       clean way to merge them into a single flag, but it's not clear to
> > >       me why was TRACECMD_RECORD_BLOCK needed in the first place (since
> > >       it only affects splicing).  
> > 
> > Yeah that was poorly named, and was added when streaming was added (not
> > recording to a file, but to simply read from splice). I don't remember
> > exactly all that happened back them, but you are correct, it can
> > probably be better organized.
> > 
> > Thanks for sending the patch, I'll have a look at it this week.
> 
> FYI, I pushed this patch up to the git repo.
> 
> Thanks,

Thanks!

-- 
Nicolás Sáenz

