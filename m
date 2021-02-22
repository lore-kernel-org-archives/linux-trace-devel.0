Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1CDC433DB
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Feb 2021 12:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D80A64EF1
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Feb 2021 12:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBUMkf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 21 Feb 2021 07:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhBUMkf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 21 Feb 2021 07:40:35 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB66C061786
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Feb 2021 04:39:54 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id d20so11195424oiw.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Feb 2021 04:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s72ebHF23bj2OS+FNlYBFsLxDQwbu4abmUlWSYs5T+A=;
        b=Nn3fU4oA4phCmCPrZL/YKMbzlejV1o94AMygZ0gaPCQzLc3sYI254NUeFgXR6tnwUJ
         NlCY5IJq3wb6K0ISHWYQxr574uriHa/C9gCxS4wvIyGLehok4JHrqgJKYmsyh+D2Gzyr
         FjZRU0kO9OUTFQWw3xoB6mw4oMZo0BsQsUNKMH1PQX0dOsBq1rVMo4Fz/P9juiuOj5GV
         ekxKPSH5rH0Tnwe5tdRXvWTvMsW1bWHLj5sv8zAYPE8+T0/IawODRm/lCMvGU7DH23ZO
         guL3+whv3sQep74Am/xautL037T3NeWPYgRD2/E7EJp0omEhnpXotg6ce3fgvoAvXNl+
         KAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s72ebHF23bj2OS+FNlYBFsLxDQwbu4abmUlWSYs5T+A=;
        b=s/5gEltXjD1SWbbu3o/bmN59thrzLXq5mmQPP5C7XO295nOol1aWnuDApFxuQicHmU
         NWNNy00ODoNzozllSrYCSaLWdka2TK/YdGMsFrX6h8PfcyUtCfDKtTiLQuBKscHx8Xjf
         SY4uwuNiooFugeO9e3TiUXAN43LmbKEcY8B47zOkENKWki//VJ6nTfIqfgN58abYZfon
         iu9g1ij7COzT8npBuvXrmmcNBLut4JwIAp8BdybAmeUSsR8B6yyiF4sajhwl9balGm6B
         R+19HCU0icOEqUiF1gvgwpxCDFMXuwa/vhO2h6X2KFwEzgxvqGBVm6u65JyEWBrqNlP6
         tzHQ==
X-Gm-Message-State: AOAM531EdB7UD3jTLuFeYZx+MKYtD2qjymD2zdeYp9+DgHjznzoHqhyP
        FqThDasPbe2ff2AVuvyxRM8Oz45atuE+e4YpsABdfymmeHha5w==
X-Google-Smtp-Source: ABdhPJw5rdnd4zA4tdYCn05gZC/LD5B7qgbCdIUBDmG756+/CS/xjI11AitJxb3JHsf98fNKq5QfFn3htTyufQcJnuI=
X-Received: by 2002:aca:3354:: with SMTP id z81mr12170602oiz.2.1613911194179;
 Sun, 21 Feb 2021 04:39:54 -0800 (PST)
MIME-Version: 1.0
References: <1613996661-6525-1-git-send-email-sameeruddin.shaik8@gmail.com>
In-Reply-To: <1613996661-6525-1-git-send-email-sameeruddin.shaik8@gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Mon, 22 Feb 2021 18:10:40 +0530
Message-ID: <CAK7tX=bRRtcsAPWuiF8i5T2WnO_kSMKY7ar01f3Ki4awAC08rQ@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: New API to trace only specific functions by instance
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,
As you suggested, i have used an array of const pointers to const strings.
This is the version-1 of the patch, it breaks in write.
I faced two problems here
1. The above  code can't be able to write to  set_ftrace_filter file
string by string (for normal files its working fine), After every
successful write i am getting the count bytes written as supplied
size, but strings are  not getting written in the set_ftrace_filter
file. please give me any review or debug inputs on this
2.I don't know how to reply to previous thread using git send-email, i
apologize for that, please do let me know how to reply to the older
threads
using the git send-email.
Once i have the write functionality working fine, will implement the
other features incrementally.

Thanks,
sameer.
