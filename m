Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D88C38A30
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 02:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F5A2084D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 02:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCSReI3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgDUCBN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 22:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgDUCBM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 22:01:12 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF3AC061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Apr 2020 19:01:12 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id i27so9966640ota.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Apr 2020 19:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IdIjpEBGRPajeyQ+pwzK4LyewEz8jo+J3NN5vft1quk=;
        b=WCSReI3dhFWvevfewD38UmCXgCS2y6OCMjG3uVTe7Daq4S2R5On8pnWNLrv3KuAy5y
         6IT5/XrgJQ8cNYVwGKzoprCwq48ggRm0ubicFWGJNS62WHTg1dFBUmyZlIC7jgezw4T7
         JzmOi2RF3+sucC/K4zll0igv4/O7nBqQPERbo8HYYyk8avRPMljbBbKkDajqBcGfXPgN
         dcukuHeAmggeRctlw529LP3sVWXJba2ODMKoYAw+dKjnwyCW2AUUXEoFWOziqiFqXkP7
         tPewqPmh5L5MIUumajIJ4JnqSa1OAJ4rKtNiErZ4Fw01tjWLa+FuZBxc6duNqFPOBdiN
         PRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IdIjpEBGRPajeyQ+pwzK4LyewEz8jo+J3NN5vft1quk=;
        b=I3lgP1ov4bAi1Xu1FlO2p0/8y1knacp1/2W1YEjbjTXVAr845NLpR9NzxJjd4DvhlM
         8DwC74ZjXDd6INjW7U8Vug+zbLhRNq+bsEJgOLLM4m20R2KTHwN8jO97FNAauBcuf3dU
         tujzl92P+/SBPGQhlvUG5faEgW9MdKFSD7dev1IJtIwlqpomfcwiGm/gP+cT//yUe72o
         U02lfg9VG/laUr/tTP8mCPQHalpn2tY/p02z/VEwCYERML+URU0s2ZZUjq34IPQdKSs2
         iunWhj89hoXDl6y6eFh7M8sYT1WTrUiUylViLv7Dj7VUM+kafX/lTQkuFpdiLEh8lVAx
         8SKw==
X-Gm-Message-State: AGi0PuaQoaXoG7w0kXohljDBVxGs69OGF/XqtEmI2OvY84Kwf+1j12/0
        Hj4OtEMTwDQ8l45l/lCGBcu020GyAoCX/yFuo0Y=
X-Google-Smtp-Source: APiQypJS/vFVVv+Fz3ZT/HKugIHd5d+ZKI2rp765qXj3JrQK9USwB4sUK75L3RSLGFyRfCDQ/blpHEZvTbq26eugZhU=
X-Received: by 2002:a9d:4f02:: with SMTP id d2mr546652otl.211.1587434472052;
 Mon, 20 Apr 2020 19:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200418163605.32461-1-bijan311.ref@yahoo.com>
 <20200418163605.32461-1-bijan311@yahoo.com> <20200420170706.0d813d96@gandalf.local.home>
In-Reply-To: <20200420170706.0d813d96@gandalf.local.home>
From:   bijan tabatabai <bijan311@gmail.com>
Date:   Mon, 20 Apr 2020 21:01:00 -0500
Message-ID: <CAMvvPS5eAoA6nsv9s7iA7wU1g3LKGXOusgg0Lfnyag25L0oTjQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Stop recording when processes traced with -P exit
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Bijan Tabatabai <bijan311@yahoo.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

> Won't that while loop just go into a spin?
>
> What about something like a fsnotify on a /proc/<pid>/ file?
>
> I rather have trace-cmd sleep and wake up when a task exits, than to do a
> spin. Like it does for the -F option.

I just tried doing this using the inotify API and hit a snag.
It turns out inotify can't monitor pseudo-filesystems like /proc, so I
don't think that suggestion will work.

What if I put a call to sleep in the loop?
It's not the most elegant solution, but that way it wouldn't be too
different from the current code that sleeps for 10 seconds after
checking if finished is set to true.

Thanks,
Bijan
