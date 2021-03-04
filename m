Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478B6C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 09:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26AA464F23
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 09:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbhCDJpD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbhCDJop (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 04:44:45 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E32C061756
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Mar 2021 01:44:05 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id u3so8433962otg.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Mar 2021 01:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K2l+MS+Y2NeUEUiUjN6ZDBPL780ESCFY2rCYxqhDwf8=;
        b=kzQxjc4hXT7nHrrOpuYDGFNT38mI5LJvrFNA+gVG6A+tcRcGN2CKDXmcIgczkdSGfg
         /Evq5sgnAlGIo5Dd/AnIxwDm2tNQfGTONRFi8R3lCur4j7yPA392ZdDuOV1fGE8a1Eif
         rQuA8533Jq37RPhFTS+0U1ph+E1ItbmRBhOMoruEpCsgSYZXgb86dDXC9QJYo1lHie6k
         7AXH2yp7/Me2BLD9uKbJgKxM9w3+/VLKemW997irZbly4rF+5akaYjX0T5av9fdIPAmM
         iPpT1FPrwjRDRMcg6EE+salcrmjd3gwopLGOB7etqi8X8wVRuBnsSZX6+KfNCQL0y2Fp
         eXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K2l+MS+Y2NeUEUiUjN6ZDBPL780ESCFY2rCYxqhDwf8=;
        b=Ofa78+WCrpu9MDYCtUN2/N6W9zmHJY1XuLlKIYuwLYQXRg1zYUAPDiipzhZn9m7EHB
         Hyo93ap8fJ+x9APq9maIwj0v5cE5snU6cEpVh5rIJCutAnbx425urg/VZKNduY0PzEXS
         KbnkoyTaiD/SjL8wfR0e2bCMp/m+P7DQackd6UaJP1EuU3jZxz7iyq70IhVaJtCJk2p1
         Z42UL0Cx3WkJESJ5K4mzCkvJumfaUN6F7feDa33qiwQHy/bkLcpAy503tWqNIhyNq9Ui
         YY2D1rhI3SzIoTWxCeW5xDt++pXyThC5wKnhGyjg5mKxhUeiUdlzMJuUrHXANbFotwyL
         H7/w==
X-Gm-Message-State: AOAM532XM84+AT+iMZ+DMLxKW0ET+1ASty0yyoQr/Dha5qUEW+vwOH86
        +rfIuhsx/Vq/kEmZoRx12kIZOaBXkEZcbtbHvzU=
X-Google-Smtp-Source: ABdhPJzPOCVbPYD7JnTl5utEmXkTzZfZ+Sf/zc2TS8H/yYWHoL+mFfp9Saakdr9iprQfDpth13gTY07+vLkGBLsELKg=
X-Received: by 2002:a05:6830:920:: with SMTP id v32mr2875219ott.138.1614851044897;
 Thu, 04 Mar 2021 01:44:04 -0800 (PST)
MIME-Version: 1.0
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <20210301131754.11f0be38@gandalf.local.home> <CAK7tX=b4qPFcC+uGHfbBT3v90+qhHuBoLF=HgqUMmD0b00PF6A@mail.gmail.com>
 <20210301202803.3529949d@oasis.local.home> <CAPpZLN4h-cXe7j0sBxviQdttD4OT7H=tW5j0=0qYyDCw2XutMg@mail.gmail.com>
In-Reply-To: <CAPpZLN4h-cXe7j0sBxviQdttD4OT7H=tW5j0=0qYyDCw2XutMg@mail.gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Thu, 4 Mar 2021 15:13:53 +0530
Message-ID: <CAK7tX=Zk5LC9dSGYJHP9fcFH=wo1-9dgX_529hp6Ys1V5Dcmzg@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

sure tzvetomir.

On Thu, Mar 4, 2021 at 2:29 PM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> On Thu, Mar 4, 2021 at 9:24 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 3 Mar 2021 06:46:26 +0530
> > Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:
> >
> > > what if we store the indices of the failed filters in an integer array
> > > and return them back?
> >
> > There's not much difference if we return an array of pointers to the
> > filters or an array of integers to the index. I was just thinking about
> > how I would use the interface. When having a working interface, we
> > should write a few robust programs to see how easy it is to use, and
> > that will help in making the API appropriate. This needs to be done
> > *before* we accept it. This particular API is going to be widely used,
> > and it needs to be simple and robust.
>
> One remark, not directly related to this discussion. When the implementation
> of the API is ready, there should be a unit test (in a separate patch) - as for
> any of the other APIs. Usually these are the first use cases that I write for
> the new APIs.
> Sameer, please look at utest directory where the unit tests are, each API has
> a unit test there. We use the cunit framework, ask if there are questions about
> it. This should be the next step, when the final version of the
> implementation is
> ready.
> Thanks!
>
> >
> > > let's return the number of bytes written, also we will calculate the
> > > complete filters length and return it, if there is difference,
> > > we will loop into the integer array and print the erroneous filters
> >
> > Not sure how that is helpful. How would you use the number of bytes
> > written?
> >
> > >
> > > Let's fix the number of parameters to this function:)
> >
> > Not sure what you mean by that.
> >
> >
> > Here's how I envision this interface.
> >
> >         char **errs;
> >         char *filters[] = {
> >                 "sched*", "spin_*", NULL
> >         };
> >         int ret;
> >
> >
> >         ret = tracefs_function_filter(NULL, filters, NULL, &errs);
> >         if (ret < 0) {
> >                 int i;
> >
> >                 printf("Failed to apply: ");
> >                 for (i = 0; errs[i]; i++) {
> >                         if (i)
> >                                 printf(", ");
> >                         printf("'%s'", errs[i]);
> >                 }
> >                 printf("\n";
> >                 exit(ret);
> >         }
> >
> > -- Steve
>
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
