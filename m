Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583A1C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 01:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 213EC611C9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 01:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbhDNBDl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbhDNBDl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 21:03:41 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59B9C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Apr 2021 18:03:20 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id d12so18892937oiw.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Apr 2021 18:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iDLCVsMwo2I72tyvUUZxnj3CFk/xLEBRBkoUAK4reKA=;
        b=Jclb4AzGdEUeNnn/ihLBdnc81QC1MXu4Ndk5Y2DHTSlL0vvrTkeiNIbGm+ojEr8zcS
         WqsFemwkpA5wKtE0fUlsYzOQrgX/ezumj3GBFzg80z5b8kNCW4n4xMOiAMLpPYKyS+Yh
         B4nxoxK1m87yUAnDcVYMQJm8trtWjuB0ZEKBu1+EnlQi21/RkfUBUJcd7H2syvxz8g50
         Qx7F4H7ti+2rueFiIpGxEFycFaH2vBbn/gPqFDN2lZ1wlArnrbURxZPDa3TnAJe1CHKZ
         cNCmKOHmPg/+8sxPzeCQV0N94GeHvTd9Zl1rHdFe5IJkJDxHN5g3OKSLcby5AtPZJvO8
         lTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iDLCVsMwo2I72tyvUUZxnj3CFk/xLEBRBkoUAK4reKA=;
        b=lMU1zjewBoDX1dzBF1vzcHT3YKWC+8fDt88rzJfr3CBHnPrig1/WVE4dwlKV4hVmCt
         P9DbUHoxP0eWKPrz/Y6UxFtetFpEzqd5p+HFdTKkWFqU2k8Mk1OlgLDILXxFY4j8CFzV
         iunip1epWIO0Gk/E3xHzl0FtH6fZJuR9Ei8RCgmunPTPA0bip2iHcVSwEqjaf6re+umr
         2QLQSgIJAotxX36M/dOGQpAtqi2Lu5DfyWvc0DP+WC6EpoVw/klFs0PAryLZZOMwhwSA
         RiBfba+v6RErJwosBxxGBrKugtMGG9PbsVLaxxILcSwWrc49Qx4bWP/OKqA3hSWuDyKf
         EHcQ==
X-Gm-Message-State: AOAM533CPAxlgNd6yH/vHewcogEHa/80mYodSS5ee+6/+/IAjkxgJ6ov
        Fanuo8LSLzDrRfVik20PFbRyfmRixzwKkUsKf3GCvoVjWSI=
X-Google-Smtp-Source: ABdhPJzNi0jsnrYi2wEjKLt9I7OKdqO30iuBHy/7whI75+iSquYNFSx3U3quM7GhypAvGA+wgLfahWi3n2RY/LSXiLk=
X-Received: by 2002:a05:6808:114b:: with SMTP id u11mr392594oiu.2.1618362200255;
 Tue, 13 Apr 2021 18:03:20 -0700 (PDT)
MIME-Version: 1.0
References: <6b3b676e-b57c-5d05-142e-9e85e61a6ce5@gmail.com>
 <20210410222331.24d04032@oasis.local.home> <1fb3ff49-133c-2414-3de9-922dfb73fcc6@gmail.com>
 <CAPpZLN6H7gn0_xsE+PsjQH9aDTkmdY8YcZZ1hvEr++2hcqeEHQ@mail.gmail.com>
In-Reply-To: <CAPpZLN6H7gn0_xsE+PsjQH9aDTkmdY8YcZZ1hvEr++2hcqeEHQ@mail.gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Wed, 14 Apr 2021 06:33:09 +0530
Message-ID: <CAK7tX=ZLAyUSPffWLjQUmTsV3D_AU_gGU1oPGFfpoYtX=ESr6Q@mail.gmail.com>
Subject: Re: Bug in Test code
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi Tzvetomir,
Its worked
--sameer.

On Mon, Apr 12, 2021 at 10:02 AM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> Hi Sameer,
>
> On Mon, Apr 12, 2021 at 4:05 AM sameeruddin shaik
> <sameeruddin.shaik8@gmail.com> wrote:
> >
> >
> > On 11/04/21 7:53 am, Steven Rostedt wrote:
> > > On Mon, 12 Apr 2021 06:43:44 +0530
> > > sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
> > >
> > >> hi,
> > >>
> > >> Test: tracing options ...FAILED
> > >>       1. tracefs-utest.c:746  - check_options_mask_empty(all)
> > >>       2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
> > >>     Test: custom system directory ...FAILED
> > >>       1. tracefs-utest.c:746  - check_options_mask_empty(all)
> > >>       2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
> > >>     Test: ftrace marker ...trace-utest: ../nptl/pthread_mutex_lock.c:81:
> > >> __pthread_mutex_lock: Assertion `mutex->__data.__owner == 0' failed.
> > >> Aborted (core dumped)
> > >>
> > >>
> > >> Above tests are failing for me, what about you guys?
> > >>
> > >> Do i have to give any command line options when running the test ?
> > >>
> > >> I ran test like below
> > >>
> > >> -----------------------
> > >>
> > >> #./trace-utest
> > >>
> > >> -----------------------
> > >>
> > > Hi Sameer,
> > >
> > > Thanks for the report. Yes, it is a bug in the tests. We did a last
> > > minute change to have the options bitmask be stored in the instance and
> > > it is immutable, but did not update the tests. The below patch should
> > > fix it for you. Let us know if it does.
> > >
> > > Thanks!
> > >
> > > -- Steve
> > >
> > > diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> > > index 1f48e6f..3407202 100644
> > > --- a/utest/tracefs-utest.c
> > > +++ b/utest/tracefs-utest.c
> > > @@ -679,7 +679,7 @@ out:
> > >       return ret;
> > >   }
> > >
> > > -static bool check_options_mask_empty(struct tracefs_options_mask *mask)
> > > +static bool check_options_mask_empty(const struct tracefs_options_mask *mask)
> > >   {
> > >       int i;
> > >
> > > @@ -692,8 +692,9 @@ static bool check_options_mask_empty(struct tracefs_options_mask *mask)
> > >
> > >   static void test_instance_tracing_options(struct tracefs_instance *instance)
> > >   {
> > > -     struct tracefs_options_mask *enabled;
> > > -     struct tracefs_options_mask *all, *all_copy;
> > > +     const struct tracefs_options_mask *enabled;
> > > +     const struct tracefs_options_mask *all_copy;
> > > +     const struct tracefs_options_mask *all;
> > >       enum tracefs_option_id i = 1;
> > >       char file[PATH_MAX];
> > >       const char *name;
> > > @@ -745,9 +746,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
> > >       }
> > >       CU_TEST(check_options_mask_empty(all));
> > >       CU_TEST(check_options_mask_empty(enabled));
> > > -
> > > -     free(all);
> > > -     free(enabled);
> > >   }
> > >
> > >   static void test_tracing_options(void)
> >
> > No steve it didn't resolved the issue,
>
> Thanks for running the unit tests and testing the latest release.
> Indeed, there is a bug in that code that leads to a memory corruption.
> And we neglected the unit tests, did not align with the latest changes
> in the APIs.
> Please, check if the patch set that I just sent fixes this in your
> environment: "[PATCH 0/3] Fix unit tests and APIs for loading saved
> mappings".
>
>
> [ ... ]
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
