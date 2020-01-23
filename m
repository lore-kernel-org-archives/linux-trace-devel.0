Return-Path: <SRS0=jdea=3M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF3EC2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 19:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319D12077C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 19:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JhMRF4+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAWTwG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 14:52:06 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44650 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgAWTwF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 14:52:05 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so1883358pgl.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Jan 2020 11:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plr9udFqOdWSWP6wPQiYTlgGw5C+4I75HPGmV3nOd3o=;
        b=JhMRF4+i6Wtp0o0LlEG1T3E9MtAR/qFQtqBU5oDzQXAT3MHM/M/lvm46Iuor7Y1xhu
         elaNfxFds8bJDXCl8TPGvOJ4SIJFFgrK6kvwAWynIYILJUVEokcvaMsFplMHlPJ2fpg2
         qbhLUYSBuNmKTzm6JYcPBlePARrfMApkIblCsxLwWOewmwziETucLiZrI5hOsFlFu7Og
         wFsplw9c5MNqCs1CVWL4gdGFWgYmiaRpCQqvbIgNgeOgtonAmDoaX/f7fUBsZSIysZ0n
         q2Pe+8LiVoKYf7gRJjEc5KQbthW4NzgoEN6lvV3DaWt9+8O/1LRaHF0vO3ZWEPySlVaf
         bmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plr9udFqOdWSWP6wPQiYTlgGw5C+4I75HPGmV3nOd3o=;
        b=rCoJq1DWCMr5bRg5M465gg1gCcy60aw+GSITb/1minhY0H9IEeftNdwV1qVoh+F7wr
         Cg9nDav+kj/zc/i5Q401C9Giij5b/Jm6ikcc9J8TW3dNBFuNKCa7ZX/FnmouOfWt23Uv
         L/TE//ghic9qTbgqXRQeAQ5oVWucWXe2qqhLT9w94pYuWcfWZgvveZAN3OGCoPTO7Uc4
         CWeHGvP6tJS4vQykpUstF9adelLw+6wWBjOGhL0vev3+OjeV7JFX2FMEMQipqM1UoHTy
         RCL/S+B27Aa1tqZ1ctHs0KvwDKeHQ3AfRCOWzZHvoTyCGeNLEGEBXniS2nB8gW7doH/n
         JxHQ==
X-Gm-Message-State: APjAAAW8RZ/BCOrQOMU1DIYRWc8Lg32HuoDE6mkOivy+JL7JjjlOrSya
        jmv3vQvLfsaQtMP/KJanuZfY+HkV+slJVDEFpnXVnIuT
X-Google-Smtp-Source: APXvYqzFCF5NwvRV+V2P2egfGkTqMAq70rw+oRGXHLfGORRvRGuw2+qrvwMoERrwADQw3VQgrI/I0LCatYsRTdwdTWI=
X-Received: by 2002:a63:7744:: with SMTP id s65mr20959pgc.312.1579809124873;
 Thu, 23 Jan 2020 11:52:04 -0800 (PST)
MIME-Version: 1.0
References: <20200112190537.170197-1-marcgonzalez@google.com>
 <20200120173335.7ec9609f@rorschach.local.home> <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
 <20200122122805.0ecfdb1f@gandalf.local.home> <CAKvFj6qxHBHk3G61qqo8vMeu9JFQ_3VuiwJZs4X8EBfYX00sag@mail.gmail.com>
 <20200122140830.2111942e@gandalf.local.home>
In-Reply-To: <20200122140830.2111942e@gandalf.local.home>
From:   Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Date:   Thu, 23 Jan 2020 14:51:53 -0500
Message-ID: <CAKvFj6odA2Ac2NvQ5zzc3=4wG18uXc-ECEQDWr+wjpS8G1TGiA@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope index
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 22, 2020 at 2:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 22 Jan 2020 13:49:40 -0500
> Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:
> >
> > > then I'm OK with your approach, but we need to make sure we update
> > > the .gitignore and clean make target to remove it.
> >
> > Ah good point! I'll send out another version if this way's the way to go.
>
> Yes, please do. Thanks!

Ah actually, should these be covered by the 'cscope* ' lines in
.gitignore and the clean make target?

-Marcelo

>
> -- Steve
