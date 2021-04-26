Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07A3C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9978560FE5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhDZPRy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhDZPRy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:17:54 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A49BC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 08:17:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n3-20020a05600c4f83b02901425630b2c2so949970wmq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 08:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eybPhZHTrDZ7KSbqT0pkbgwg3anbgoqoAyEw0cCud80=;
        b=N/2YYUMUr9jtP4pisZEo7hkBoaMpnhvaHax/j0GyK5Zue18o84jh4xV6Vmz7XI+epL
         Po0GBVu4W8xpJk44mDXM2+CqqE4ijL7rQM5Qcjbo6rEcBN6YbLYJyCfRWzddpQfpeW/Z
         QfgSwVI0NqeL9XQRYCHB2+mY2/F3ThMmngyNbz3wC3aZPeQ/wr23OF8U5zKMdgNOnPqc
         TwGUhi61dI8Q1AkAD4Xyx22hazh/LjyytRTqf9NF9+4svDtNLIkQPfTimJUvNMCzCjZ7
         49rZGsLoJntNrXUydvbMBBzqYZf2k3XYtsHOcvrClCZMjdUCGo5Arx/W+hUMOmRZnOco
         KbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eybPhZHTrDZ7KSbqT0pkbgwg3anbgoqoAyEw0cCud80=;
        b=oTb/YHKYnC0jQQaYLqSNXfj5Vt8Bma3cNIUxg0juy5OxEeSbmGqRcOQ9gGHwwFLIi/
         NeMmSpGHMVwywMOnJctWnNSJo8iOiTZvi9qObQKjXt9BzCtZgVWxrzPgn9K3Ot/Mnkx8
         DDlCRo7Gc5YTmZE+faiXnZ5IyhtgJynqLDPuU3mTUF6clBNoQV0xF7K9IL2yqRz7uW1M
         FOvigwuzxASct/e+A7S6yqGlUqDnGXKgPOqRZIuhbYrd6Ce2xGUFljy7j+UI7npl8sfe
         ypNC5GL8aJRBRt9ivQ1sZR3k4MebT9KhGhrLOe6ZI9VXUntdoSfyQtgC2rOhA/mXmrTv
         bQNg==
X-Gm-Message-State: AOAM533I6bNztSZJ7IvMKmqyHn6KjIR2iZr9nVNmNHK8X1yJrdV4EQCu
        maX7c6ucErBFWkeN9T75ooV30J06DCmkbSw+bmcY+w==
X-Google-Smtp-Source: ABdhPJwS2qOIvgsD4yWKusQugfFpNUy83lHAFRgEH24COfRJQMVuSgK9GDtsxBfMTpOEgG+d8mzMT7fqETYF3wZsyIk=
X-Received: by 2002:a05:600c:4142:: with SMTP id h2mr21702704wmm.87.1619450230964;
 Mon, 26 Apr 2021 08:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210423035438.2221760-1-irogers@google.com> <CAPpZLN4Ny2BkpfuBczA-Bs9-Nzf5md_CuqbEHgDYUD4pggtvjw@mail.gmail.com>
In-Reply-To: <CAPpZLN4Ny2BkpfuBczA-Bs9-Nzf5md_CuqbEHgDYUD4pggtvjw@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 26 Apr 2021 08:16:58 -0700
Message-ID: <CAP-5=fUbGQZAHSfDhvKQsggdN9hYQ+GmAieEW=AXkYZOtfJUyg@mail.gmail.com>
Subject: Re: [PATCH 1/3] libtracefs utest: Silence string-plus-int warnings
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 4:25 AM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 6:54 AM Ian Rogers <irogers@google.com> wrote:
> >
> > Fix warnings of the form:
> >
> > utest/tracefs-utest.c:476:35: error: adding 'int' to a string does not append to the string [-Werror,-Wstring-plus-int]
> >         CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
> >         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
> >
>
> Hi Ian,
> Thanks for testing and sending this patch. What
> compiler/version/options you are using to get these warnings ?
> The whole patchset looks good to me.

(Re-send with plain-text mode enabled).

Thanks, the compiler is clang 12.

Ian

>
> Acked-by: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
>
>
>
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  utest/tracefs-utest.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> > index edb3a3d..c5efd5f 100644
> > --- a/utest/tracefs-utest.c
> > +++ b/utest/tracefs-utest.c
> > @@ -453,21 +453,21 @@ static void test_instance_file(void)
> >         CU_TEST(ret == strlen(KPROBE_1));
> >         kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
> >         CU_TEST(kprobes != NULL);
> > -       CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
> > +       CU_TEST(strstr(kprobes, &KPROBE_1[2]) != NULL);
> >         free(kprobes);
> >
> >         ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_2);
> >         CU_TEST(ret == strlen(KPROBE_2));
> >         kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
> >         CU_TEST(kprobes != NULL);
> > -       CU_TEST(strstr(kprobes, KPROBE_2 + 2) != NULL);
> > +       CU_TEST(strstr(kprobes, &KPROBE_2[2]) != NULL);
> >         free(kprobes);
> >
> >         ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_1_RM);
> >         CU_TEST(ret == strlen(KPROBE_1_RM));
> >         kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
> >         CU_TEST(kprobes != NULL);
> > -       CU_TEST(strstr(kprobes, KPROBE_1 + 2) == NULL);
> > +       CU_TEST(strstr(kprobes, &KPROBE_1[2]) == NULL);
> >         free(kprobes);
> >
> >         ret = tracefs_instance_file_clear(NULL, KPROB_EVTS);
> > --
> > 2.31.1.498.g6c1eba8ee3d-goog
> >
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
