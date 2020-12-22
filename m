Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5ADEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7756B23123
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgLVFHS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 00:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgLVFHR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 00:07:17 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28D4C0613D6
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:37 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 15so7639421pgx.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jzzExfHP5rL3RYBHLOhfJ4+gak9sZa10zKRdDorHa0M=;
        b=SknfBpxYWrvwkPyK7y+j4QxwxRvh6CYWbFWbyyqYpJTgeXwtx2KawsoiTek/HM0xLM
         I25+O8dlct47uU6poqn7SJlptUAyLqsSbxEH3flRtfOOCyGXyfXj+xbIweSq02b5zkf7
         CB8okMIjcUZGGIH6HtI3L9zNzB31EjQgw2EXQF1D3xzHsLLbapy3AkU9psR66byhjjbQ
         EHzxREVsF1Mf3NpvnzO3OJ2wBjpot5z33x1+QiwL+NxxVvEbDy2np1+DJfjhf4kBv+N5
         tyWjDPTZakzv8g3v0NZj3MPARUFHG+oMt1ir/D9Z2fjMkp+8jkjOh2zgugHCPTvvILbW
         R4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jzzExfHP5rL3RYBHLOhfJ4+gak9sZa10zKRdDorHa0M=;
        b=XCdXY+HWFf2aIWHls/gYpxq3Z7z6wvCCgI39l1aiFFjQbHuachl3kktCU0qJDKweWe
         w5nnKJITAz9nTZFSTdG6dFAxMbRzcHPl78OiPsq9I9UjvtqQBY9if+TrEloxkpV68iia
         7O9GqSRpAyZWrZ3mXOrcDkqEGE3j6ESgmUQgFsAn454CLf0Q8/X2z547KFGs5YOInVve
         n1lzTOR33ew9XQw1lMtSDR8TYiFMJHjJD187RdsOWQHS7PKqvIsvBdxL9u12++I4i9MR
         M3oYlyuG+1Wq9u2gMCmKr1bn94pLx3WzDCJmY/vQpVWl1ecFiCUCrq9jZXppeh9RQ/IV
         uvHQ==
X-Gm-Message-State: AOAM531VYLcDPL2aLX5B2kPmbVorbw5ZNnlJ2+W4m3Ii40XIQzW7s8zX
        SWtM5IlIoc5BI3+C/wXDuP6t8PS4crVd54U0sr2UpcRGIxsnNg==
X-Google-Smtp-Source: ABdhPJztYMSk0m3PDAocGy9BFc4EJj8fEgfkDPc2j6GlC0+c1ZNExakvGas53PC/gIxj1MNtIvFvLx0e2QAa+1cdBOA=
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id
 f10-20020a056a00228ab029018b212a1af7mr17987742pfe.55.1608613597285; Mon, 21
 Dec 2020 21:06:37 -0800 (PST)
MIME-Version: 1.0
References: <20201221065103.199777-1-tz.stoyanov@gmail.com> <20201221101558.6fa01b6e@gandalf.local.home>
In-Reply-To: <20201221101558.6fa01b6e@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Dec 2020 07:06:21 +0200
Message-ID: <CAPpZLN5GZFYypb43782RAFR69JSPwv2Hp89Z5TFo+Q0U9i9_Tg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Use tracefs_tracing_dir() instead of tracefs_find_tracing_dir()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Dec 21, 2020 at 5:16 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 21 Dec 2020 08:51:03 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The tracefs_find_tracing_dir() and tracefs_tracing_dir() are
> > consolidated. All usage of tracefs_find_tracing_dir() are replaced with
> > calls to tracefs_tracing_dir().
> >
>
> Hmm, I appear to be missing the patch that renames
> tracefs_get_tracing_dir() to tracefs_tracing_dir() for trace-cmd.

I forgot to send it, going to resend both patches in a set.

>
> I have it for libtracefs.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
