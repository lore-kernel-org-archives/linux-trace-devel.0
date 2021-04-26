Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88380C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4049861003
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhDZNA4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbhDZNAz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 09:00:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9220C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 06:00:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso5151075pjg.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 06:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2HRocx6+pNIWwXJ+sBmmUSJ19YZYP2pQaBt9CFIIf7Y=;
        b=ZXFfUHpbFld6BqeixYlW/9lRXlxKMDUi6ErdNcBjD+qgzx9D0yN6y77OaAOjcpv/qk
         QBDsBbxTj2XX+YMzznLIpMWHIhw2+0j9zyEJSq1JLymMDwhF+Fky7kkPYWFlrV24WtNy
         JSLru18t9UDlkR5/zERx7PmgcqQhhOpY5+jmvICgWEQA1DgLbfoh+09IqussBfPBnsZv
         KzZTXDNK1iluvN/8/YR5xvFPN6Zls9ZbQIFkhJ169KYgPSlMnzOWK1fu2/Qoz0qUNj/z
         PvS/dl33TLYyBB8H+pPudJK5aJsFV6iAIvxmOQpskfUCMVSsOCEGiaRGkduEXKgtyVeh
         m11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2HRocx6+pNIWwXJ+sBmmUSJ19YZYP2pQaBt9CFIIf7Y=;
        b=CF6Rl2QkHQACecrxs3eau5u84ARLeMio7QcoCIeuugvGFYOBAmXrfIOkV3n+FXQiEK
         mjl3Va557hDa2bzXtauPIptJdETvE4ezDLPTOtZlUfNhpUiDe0aopWy55zLmSvlGXt+v
         Gs1lOZ94DKsFUSaX7ml7nmqXbblLwRMKKR8Y6W3XEloHQDxRxdPXB+nLXLtryDeb9LFg
         tmzaH1gjwVBOX7DIzxzkSz5MCOyQlokcv8DqXQJnli1mHdlAVkrfuktH1xeuBy0oMl1u
         PbR2v1rjIx+diwSmDZplsiZOVWRDCLoCNxTLUTADYw8AQv+Lh9GajcY4sTf4twkqaM+N
         KkmQ==
X-Gm-Message-State: AOAM530LdsYgVJF/BJkKLxZIimO1rmexnTtBZOP7pfO5vlFsZWJZJwac
        LT3Nvz8ESw3oeaDIgvXoX0ILDx97haVaR33JQZow30bHxIA=
X-Google-Smtp-Source: ABdhPJzXTu6S/yY3nJnfV30nmewrAUZXR7W8GIP6RIq1GAQxS7OP0qhgSJQPgd3OUQSO4QqUGPXEgI2DU3FInKTufSs=
X-Received: by 2002:a17:90b:3b43:: with SMTP id ot3mr20875614pjb.100.1619442012266;
 Mon, 26 Apr 2021 06:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
 <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
 <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
 <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
 <20210422153845.3e6e9304@gandalf.local.home> <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
 <20210422154830.52f3e4f5@gandalf.local.home> <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
 <20210422160313.2eee1f77@gandalf.local.home> <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
 <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
 <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
 <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
 <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com> <20210426084408.581364d9@gandalf.local.home>
In-Reply-To: <20210426084408.581364d9@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 15:59:55 +0300
Message-ID: <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 3:44 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 26 Apr 2021 13:58:18 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > On Fri, Apr 23, 2021 at 11:37 AM Joel Fernandes <joelaf@google.com> wro=
te:
> > >
> > > Apologies for the top post as I'm on Gmail mobile and only half awake=
 at 4.30am.  I should check but can we just scrape the crosvm PIDs from the=
 host trace itself ? The vCPU threads are in scheduler events in the host t=
race. Of course that wouldn't work if we don't have events. Let me know if =
that works for you or if I should find another way.
> > >
> > > By the way if sync is supposed to fall back to the ptp algo, why did =
it not fallback for me?
> >
> > Because of a bug in the code. It assumes if KVM is detected, then qemu
> > is used to run the VMs.
> >
>
> We need to find a way to do this without qemu. It's only the thread mappi=
ng
> that is missing here, nothing else. And KVM sync should still work.

The problem is to find the VM specific directory in the KVM debugfs,
where the VM TSC parameters are. The name of the directory is
/sys/kernel/debug/kvm/<some PID>-<number>/
The PID is the qemu process which runs the VM. I wonder how it looks in cro=
svm ?

[ ... ]




--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
