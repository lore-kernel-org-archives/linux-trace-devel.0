Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8871AC43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482736120F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhDLEcz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 00:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhDLEcz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 00:32:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E2FC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:32:38 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u7so3875359plr.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXKvVfXVVQkKn3WY7E1stiRKrKnRb8cLL/2KKGUqa+g=;
        b=CAKKgmDh5KNK55+hPsDc+yDw1xz/iZuEybNPommzc4Uc+lzCg6CXLXOUE2mcojcUiI
         iuiGvjhPrQ0O9srWkmQlnP/old3GwXLgD0linArmQsRUqdQQtCfl47bSj6nQn+iPtR1r
         XrOE5s9QVV91bTt7pP3RH6btDqS12/dAQP4r4gQAPyeLM8wK1BSBYIunfUsZkgOfnW5u
         nq7mU9sSegKP82Tn8ARzB+/nEv0cPWZd9LzF382eMTMv+gB34y21sCupSgFvFdZtOk0I
         6HgctHnH2LGOP7VjW6AjNv0MjrK57D3vB8d70wdyd7axsV5KaFMXJEQrIZTw4RRkoWqT
         /G8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXKvVfXVVQkKn3WY7E1stiRKrKnRb8cLL/2KKGUqa+g=;
        b=Xozvt9hjjgQrk2Fmb8fbhRvhEDK5vw+zRIsULkYCtt/qfO/ygqdTI/SwJXdq8yJkQy
         HK7I/eCQlHSqXghI85mr42hOLKoI46WFdTZBod8drqbcPdyjmwqePPG0rJ3F1qfwOENx
         KtSubtMHbAcFanIGt8nQiSfVKHhzOs67Fiu7sSxgkFTTleidLstK6BFkcJY98GIl9hDE
         gT9V5udWP3kjpIo+a9J4D9aLlOljlknj+HSxqJxEj7cyFPUB1RzAmyGTCvZ5A2r3Y2zR
         h3JoiRrd2TwsrTf8xB0WuigN5fRXFHu6MMEMU56R8oNOI0bsPbdRLGdnkuKTzRml9Xmn
         SIbw==
X-Gm-Message-State: AOAM533FfWRDeUm5YqcFnJIYOsz/iXnrY7CcIA14cLTqzQEvloCWEwwN
        kFqCGBFwD+BhNvJ7ByqkJTrJJNsnIu2x/yu4cNI=
X-Google-Smtp-Source: ABdhPJyMrX9t9qrGErzcVnz7UDohejCQXBIsIS/Sas+vf/8jX8PYNMWsS38Zfu/N9a2wyrWTOM3FpQD/65cuDDuZ0oc=
X-Received: by 2002:a17:902:122:b029:e8:bde2:7f6c with SMTP id
 31-20020a1709020122b02900e8bde27f6cmr24893632plb.29.1618201957747; Sun, 11
 Apr 2021 21:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <6b3b676e-b57c-5d05-142e-9e85e61a6ce5@gmail.com>
 <20210410222331.24d04032@oasis.local.home> <1fb3ff49-133c-2414-3de9-922dfb73fcc6@gmail.com>
In-Reply-To: <1fb3ff49-133c-2414-3de9-922dfb73fcc6@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 12 Apr 2021 07:32:20 +0300
Message-ID: <CAPpZLN6H7gn0_xsE+PsjQH9aDTkmdY8YcZZ1hvEr++2hcqeEHQ@mail.gmail.com>
Subject: Re: Bug in Test code
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Sameer,

On Mon, Apr 12, 2021 at 4:05 AM sameeruddin shaik
<sameeruddin.shaik8@gmail.com> wrote:
>
>
> On 11/04/21 7:53 am, Steven Rostedt wrote:
> > On Mon, 12 Apr 2021 06:43:44 +0530
> > sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
> >
> >> hi,
> >>
> >> Test: tracing options ...FAILED
> >>       1. tracefs-utest.c:746  - check_options_mask_empty(all)
> >>       2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
> >>     Test: custom system directory ...FAILED
> >>       1. tracefs-utest.c:746  - check_options_mask_empty(all)
> >>       2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
> >>     Test: ftrace marker ...trace-utest: ../nptl/pthread_mutex_lock.c:81:
> >> __pthread_mutex_lock: Assertion `mutex->__data.__owner == 0' failed.
> >> Aborted (core dumped)
> >>
> >>
> >> Above tests are failing for me, what about you guys?
> >>
> >> Do i have to give any command line options when running the test ?
> >>
> >> I ran test like below
> >>
> >> -----------------------
> >>
> >> #./trace-utest
> >>
> >> -----------------------
> >>
> > Hi Sameer,
> >
> > Thanks for the report. Yes, it is a bug in the tests. We did a last
> > minute change to have the options bitmask be stored in the instance and
> > it is immutable, but did not update the tests. The below patch should
> > fix it for you. Let us know if it does.
> >
> > Thanks!
> >
> > -- Steve
> >
> > diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> > index 1f48e6f..3407202 100644
> > --- a/utest/tracefs-utest.c
> > +++ b/utest/tracefs-utest.c
> > @@ -679,7 +679,7 @@ out:
> >       return ret;
> >   }
> >
> > -static bool check_options_mask_empty(struct tracefs_options_mask *mask)
> > +static bool check_options_mask_empty(const struct tracefs_options_mask *mask)
> >   {
> >       int i;
> >
> > @@ -692,8 +692,9 @@ static bool check_options_mask_empty(struct tracefs_options_mask *mask)
> >
> >   static void test_instance_tracing_options(struct tracefs_instance *instance)
> >   {
> > -     struct tracefs_options_mask *enabled;
> > -     struct tracefs_options_mask *all, *all_copy;
> > +     const struct tracefs_options_mask *enabled;
> > +     const struct tracefs_options_mask *all_copy;
> > +     const struct tracefs_options_mask *all;
> >       enum tracefs_option_id i = 1;
> >       char file[PATH_MAX];
> >       const char *name;
> > @@ -745,9 +746,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
> >       }
> >       CU_TEST(check_options_mask_empty(all));
> >       CU_TEST(check_options_mask_empty(enabled));
> > -
> > -     free(all);
> > -     free(enabled);
> >   }
> >
> >   static void test_tracing_options(void)
>
> No steve it didn't resolved the issue,

Thanks for running the unit tests and testing the latest release.
Indeed, there is a bug in that code that leads to a memory corruption.
And we neglected the unit tests, did not align with the latest changes
in the APIs.
Please, check if the patch set that I just sent fixes this in your
environment: "[PATCH 0/3] Fix unit tests and APIs for loading saved
mappings".


[ ... ]

--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
