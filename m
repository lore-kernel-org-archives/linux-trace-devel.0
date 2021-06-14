Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAF9C4743C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 16:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E810613DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 16:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhFNQQk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 12:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbhFNQQj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 12:16:39 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A74C061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 09:14:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id s70-20020a1ca9490000b02901a589651424so213432wme.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 09:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4yiF2vhip9zwhmZ9+/R6HIJAlAqAXdCRvYu1mvEtcdU=;
        b=Q6ygX6FW1PV4W/XLTWDNGAoTE4IoPTndAG/4BonEkXAfZOFu5Wpv7BaSGw5lo9Ra5f
         QVgFEBWj6M2XiQB5+Hxr/KmO/W9hTB667UFrluXkAKuNmRKqUFjH4PcERhhn514uW4N6
         zmFYV20ILTwB8CeeduuIVN7H3HdVEps7NvDjJm36S+qJoGtpHZMiqnQobLDJhz17xEHe
         zvV1+TlsCI0mgWd0WgdKYfsL85mfSxRynfV2Z5qH+0q2HkvvEtl1iKw98kF8XABcMEPY
         cVq0F0GstJH2S7IhlZonCYycnbEVnzYRPeJsaxQ8I76yK5ASE6tIx59OHTaSKkKuF0Aq
         I9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4yiF2vhip9zwhmZ9+/R6HIJAlAqAXdCRvYu1mvEtcdU=;
        b=iieltct1cT6vO01GUh8t3qjNzVqu3ZXTZMrMoQTe3fMFctlXRqIAlxz2quSzGJ0pDA
         Nt7ljGw0jM3iBQQgRMLojkhFNVrcxruvXJRbdBL514hHRO/NVXhSo50e/mFpgD6ERq/y
         8rBktfJb91ncQbudEH1jv7i8QmhMo88DMgX1E4VmQZ2d2EJBELw57Y9qi5KO/PgzD5JK
         FgsdYBJ6VBXfhmBFdHYgAa8H1gySZFX8klR5cq+oPVFInqoI2YnYVdh3qw1Y4RtZ78Me
         9oJBODZzK5KhviQ+m2B8GnUSAd32Vqyxu7ozv+NOViX1+XjX2by6BGA5hXoZEWfIBRwJ
         FPpw==
X-Gm-Message-State: AOAM532kUKbGyZyvpI2QKGOfuBY8lXulYkBKrPdJ0hKQtW2+5yqa0XtJ
        JH4JUvKTav3Ubp2/ioI7PeKkaBK9gSH4+KecrGFJxg==
X-Google-Smtp-Source: ABdhPJyr1W34f1fzTdbXuPdHGksw+RboOnrQItkWMrnVmWKwPtskdczbT1WYM+GGmZIzEXohLvyyyvN/QSBBpgAKbgE=
X-Received: by 2002:a1c:2015:: with SMTP id g21mr33945315wmg.87.1623687261445;
 Mon, 14 Jun 2021 09:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210612014501.890593-1-irogers@google.com> <20210612014501.890593-3-irogers@google.com>
 <20210612190049.7e09d8c6@rorschach.local.home> <CAP-5=fX1riLr6y8KapEhmxk3BW1Xq9kV_zMywoQ+B8Dgs6fxeg@mail.gmail.com>
 <20210613192926.6cb6b983@rorschach.local.home>
In-Reply-To: <20210613192926.6cb6b983@rorschach.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 14 Jun 2021 09:14:08 -0700
Message-ID: <CAP-5=fX00qHJmNeEpPCaCj5tqUkjbMc_Lk18o6Dv_ux6ESvSHw@mail.gmail.com>
Subject: Re: [PATCH 2/2] libtraceevent: Changed angled brackets to double quotes.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Claire Jensen <cjense@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Jun 13, 2021 at 4:29 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sun, 13 Jun 2021 14:31:42 -0700
> Ian Rogers <irogers@google.com> wrote:
>
>
> > Would it be more conventional in this situation to use quotes within
> > the library and angles outside? This change is within the library and
> > not with code trying to link against it.
>
> Does it matter? If not, what's the purpose of changing it?

Sorry for not having this in the body, in the cover message I added to
Claire's email with:

> Some build systems are picky about angled vs quotes, fix this minor issue.

The problem is with certain build system, we use bazel at Google,
where iquote is used for includes within the library, and other
flavors outside the library. There's a similar conversation here:
https://groups.google.com/g/bazel-discuss/c/6MNuZ5bKoa8?pli=1

the failure you see when building is:

In file included from src/event-parse.c:27:
src/event-utils.h:13:10: error: 'event-parse.h' file not found with
<angled> include; use "quotes" instead
#include <event-parse.h>
         ^~~~~~~~~~~~~~~
         "event-parse.h"

Arguably -iquote is more correct within the library build, hence bazel
using it. The libtraceevent Makefile is using -I, hence this not being
a problem for others. We prefer not to carry internal patches, hence
wanting to send this upstream.

Thanks,
Ian

> Note, the change log is empty, and is where rationale for the change is
> suppose to be added.
>
> -- Steve
