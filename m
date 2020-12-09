Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFE0C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 14:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 778A7233EA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 14:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbgLIOuY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 09:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733117AbgLIOuU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 09:50:20 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15543C061794
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 06:49:40 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 4so1048088plk.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 06:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XEPh8PD7eqjAEpwZk8T5/6LYnwunIle+n0ehVbqwCds=;
        b=AgVkQ1sYNyEJ1xtN+mIyYW5jz/5N+M9ooRr2Y+bcYRbpBeso9rbFHLBesPZo4uwSex
         m4pv7TjNKEyWClXGSVMKHjaTdL+LxvUOTIoXkzmysRKhF30C4OvDDWH6fBNBBzNMmOli
         ySs/xr4m34cVf/09MO9zfeawFnIXMFyWnVkb962X61ERRiDJ4hHkP6nx+JWO+/toItZ/
         kp6IXtLzEkA0ESbpsnNQXzpSBhk60UaP1OQ9/xkNaHCGQS7176ZmhywTDwW38C99JFDB
         KCX5adF1/L7qttrGbdGDiXy44pTiUiveeV+j14zOFVa90WRKAmK51mJYVTdSNuFI5FuY
         WrHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XEPh8PD7eqjAEpwZk8T5/6LYnwunIle+n0ehVbqwCds=;
        b=TmIc7F9mRCzcholj2uj4lgH9fdd0ja6Aj94J4pO8mjCz0ggqJXWSrNOJOfV4gA54fh
         jX3ZjZ98kQYPDvUivkA7QEX9kil5hkpkDCtd5wMMLS4u1bZcIFoRtPa250QDrUSYi8tu
         4NJDRfDMUhkuVKZ05reVlakuz6zC0r2kdRR4RC2+27gceCOiuptSVdMqxQaitcAyqdt6
         6nRP4MAlkAsL5qZM5dydyyt50KFG/X6+nZdHGmm1M/uOztD2j8zaq63THuEm4hf8AaIB
         XB21wBBaRLGmd08uYGWL0QlkgSJlfaJkMK4ivYGDVEZwETtQ6BKqMMFuD3yitF/MS/DZ
         1KEg==
X-Gm-Message-State: AOAM530f13gZZVVyqmZWLqH54q6EOt4C7M3NtP/Qdh9e0XHo5I9lhl3e
        yIoQ2Q2HJWqI9DZkEJw9S6hRA/38Q3BYRHLkElpmeFIM7O2XVU7G
X-Google-Smtp-Source: ABdhPJzuH3g1XJ4+WHdmy9eNNWfo/WMH7tVDd5aeXK7QFQdZmQMdivMSEbLJ2QNGsyJpWFpHdHnncSkpdhTuvzBPtow=
X-Received: by 2002:a17:90a:66ce:: with SMTP id z14mr2485774pjl.153.1607525379650;
 Wed, 09 Dec 2020 06:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20201208215404.135186972@goodmis.org>
In-Reply-To: <20201208215404.135186972@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 9 Dec 2020 16:49:22 +0200
Message-ID: <CAPpZLN5tOGVM=PmFUH49-iuDRGSKptPjcSpPB=EoFB2Fw84Ngw@mail.gmail.com>
Subject: Re: [PATCH 0/6] libtracefs: Clean up of the source directory
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Dec 8, 2020 at 11:57 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Steven Rostedt (VMware) (6):
>       libtracefs: Move features.mk into scripts directory
>       libtracefs: Remove LIBTRACEFS_DIR as it is the same as bdir
>       libtracefs: Use LIBTRACEFS_STATIC/SHARED instead of open coding them
>       libtracefs: Move source files to new src/ directory
>       libtracefs: Use pkg-config to find libtraceevent
>       libtracefs: Have make clean remove the .so.X file
>

The changes look good to me.
Acked-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ----
>  Makefile                                     | 54 +++++++++++-----------------
>  features.mk => scripts/features.mk           |  0
>  tracefs-events.c => src/tracefs-events.c     |  0
>  tracefs-instance.c => src/tracefs-instance.c |  0
>  tracefs-utils.c => src/tracefs-utils.c       |  0
>  utest/Makefile                               |  2 +-
>  6 files changed, 22 insertions(+), 34 deletions(-)
>  rename features.mk => scripts/features.mk (100%)
>  rename tracefs-events.c => src/tracefs-events.c (100%)
>  rename tracefs-instance.c => src/tracefs-instance.c (100%)
>  rename tracefs-utils.c => src/tracefs-utils.c (100%)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
