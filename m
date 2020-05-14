Return-Path: <SRS0=AbPd=64=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DA4C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 01:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA13205CB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 01:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BX5bomlP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgENBZ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 May 2020 21:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgENBZ7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 May 2020 21:25:59 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59021C061A0C
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 May 2020 18:25:59 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id d26so1079787otc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 May 2020 18:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYTBvrztFtUW7Wi1WdQcNRrNP+ITcy1uioK/E626e9E=;
        b=BX5bomlPFll+YTOg+M6dGNnCUR1oTof/SWFXZvlvdKF8ysMXfjPlzB5meAgXmtsbhL
         iFhQC6UQiHBUUF6kqmDhQSAOr8UVGaGXo7+0wlPZxcJqAoWqfLnhFrK5qESSs/DE0/0P
         0St7q4SDGwonrtgNNdo6KwJbCkz/FpoK4LZitvAKYoo0wyzDJ50/YeKM1BznjGvl4R8D
         c/L/Spgm8CycGJ8Th53prT8CWmq5QqZ6h3q0sUrKHz6RsWmefo+T7z4WHX9bilmxUoVr
         oRIsk8vQO1lS1njGgI5L6cKnkvcd6cXigeTPXVPr0xvKmKts4wr+Sv7xJ6R6M1ISqNbU
         Jjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYTBvrztFtUW7Wi1WdQcNRrNP+ITcy1uioK/E626e9E=;
        b=WocKsOosQ3fmospoud0y8hgNSXV9fG+5idji22a1IR7ML3PUYLRC5pAIagofwG1jJe
         YWIxxVqtsDCSJB4TWoLzZUzeqpqrgd8BYrRCePq7BKGVM+uL/mw5v+v+CcUNnVNwcyWT
         e7PZ1Qy/oxssZWzomv7syTchGch75jgaojcnwQyH8U4o6X5Klkw+FP+ijRRy/YVS5J8Z
         ZCoHPBaNk3kgaUYamiNXd6qDcc7h1KYYKynXC5185Fm8tNXv2gyqa7cCuA2tV994pZyq
         TdZN7D8j3NiHbhLfWnPc7YubkjoH4y7loOZTt8yNpgov3TYnXMcuGz4/2cI6dIo5djO5
         kg0A==
X-Gm-Message-State: AOAM532hB6eZgGEJKlYu1QTeXYetzZGqY0fcN8O+4y+D4cjrLCdQ9Pxv
        xPJeAIgEx9MQVlXoAtHc90IWaRP8nzMt33ad2bY=
X-Google-Smtp-Source: ABdhPJx3CqTgzt6giY+bKSzd8d2c/0uXpQajn5uoff1A8lXyJK8IukK6HhPry2CafcyoiK2z4JZHBZTxiK+Gw+O1+e8=
X-Received: by 2002:a05:6830:1483:: with SMTP id s3mr1740869otq.176.1589419557425;
 Wed, 13 May 2020 18:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200513170529.22605-1-bijan311@gmail.com> <20200513161633.0ef67ea2@gandalf.local.home>
In-Reply-To: <20200513161633.0ef67ea2@gandalf.local.home>
From:   Bijan Tabatabai <bijan311@gmail.com>
Date:   Wed, 13 May 2020 20:25:46 -0500
Message-ID: <CAMvvPS5j1nGMiQKcayppfijkxjeyNQK0cUHq6LZAghVSLvA3mQ@mail.gmail.com>
Subject: Re: [PATCH v3] trace-cmd: Stop recording when processes traced with
 -P exit
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I just tried that and discovered an interesting problem.
After the first sleep ended, my computer completely locked up, and
after a few minutes I decided to reset my computer.
Then after rebooting, I checked out the master branch, recompiled, and
tried running the same set of commands again.
This time, my computer locked up shortly after I pressed Ctrl+C after
both sleeps exited.
I am running Ubuntu 20.04 with Ubuntu's version of the 5.4 kernel.

Is this a bug that has been reported before? If not, what is the
process for "officially" reporting it?

Thank,
Bijan

On Wed, May 13, 2020 at 3:16 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 13 May 2020 12:05:29 -0500
> Bijan Tabatabai <bijan311@gmail.com> wrote:
>
> > From: Bijan Tabatabai <bijan311@yahoo.com>
> >
> > When the -F flag is used in trace-cmd record, trace-cmd stops recording
> > when the executable it is tracing terminates.
> > This patch makes the -P flag act similarly.
> >
> > Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
> > ---
> >  This patch has changed to use the pidfd interface to determine if a process
> >  has ended.
> >  It also has changed to work with the patch "trace-cmd: Handle filtered PIDs per
> >  ftarce instance" (5502bcef0f962cda).
> > ---
> >  tracecmd/include/trace-local.h |  2 +
> >  tracecmd/trace-record.c        | 84 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 86 insertions(+)
> >
>
> Nice!
>
> Although I just tried it out and noticed that if I run the following
> command:
>
>  # sleep 20& sleep 50&
> [1] 2216
> [2] 2218
>  # trace-cmd record -e sched -P 2216 -B foo -e all -P 2218
>
> It will exit out after the first sleep (20 second) and before the second is
> done.
>
> It appears to exit as soon as the first process is finished. We should want
> to wait till the last one is finished.
>
> -- Steve
