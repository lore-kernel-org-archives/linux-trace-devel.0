Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673EDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 14:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495E761212
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 14:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346738AbhIXOTz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346674AbhIXOTt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 10:19:49 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B05EC061571;
        Fri, 24 Sep 2021 07:18:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v10so32063131edj.10;
        Fri, 24 Sep 2021 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gHOStWMCK7OAk4WNmyhB8AOV0xGKghPloFqm8n1hgsw=;
        b=n4sPdqkUV94NR0iwbrGaffwgsZdzOBvEtkEb6nB/2QCO9Ac0hBCtkgMg7ToRyQy3SX
         PIjoCvG3A7N+aTEITEF91M22qvb7bTzFNYejqdsefRqQMmIQoj6klpMcsvjkq/He8aMx
         QkgdcdBKe1J83w35tNrolNGY3KTnw5AJuRvr4O6nsYhY5jggHfSlz9APhuJa/8FT6Kuj
         uqXY5jIRgcLdY5/mQq6F95VgEKBjkrm6jaB2BJQS11bfgnJTm39iwgWfy5zzBEX7T+7/
         izAp6a+rBl9oDwml9Ftgw1gPqJVGEY2HLNnSkAGSatr15pld5/pyI4TuTBg7R6LgljG8
         KnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gHOStWMCK7OAk4WNmyhB8AOV0xGKghPloFqm8n1hgsw=;
        b=qCfhlyUuw4pkqhXlpv67SE4qAwwijB8yfrO4xmQ4587TTOZtOyAKDAZSFRhhb7NlmE
         RALJGjCrs8fhzXY+tMiIyGbwSQ/AsYLmCE61faHZ/1CH9eMHeEmtllramOl8+AY407zr
         mdcxXobC+i2T86tPGvKh7CWonhbMf0tls/2NfrNHPs5hZ+lDap81NgCjoOXHOe8sfdXM
         UvxH85p2YUa7jtMci+4Y3nxnvGcqi3Yg1TtJ7SkmFK668mTP5ryCNaqdSxBMLKSQ5g0L
         z8UBOP1A7ZUaVrlSj0kA/ZcSHwGBVDnfwxQP08EbJfcstk9LOBBLcaITAmr0QkMCTfr0
         NQLg==
X-Gm-Message-State: AOAM532md3II5BjKVbElJELtkq3nupuJcVEvPla8jSdRFODLhUG0EJAQ
        bYFa0s7/CW9t7yo+yvPvDhB2DNQjIi/ZgikJsfU=
X-Google-Smtp-Source: ABdhPJx2L2ox3cbiokR2hOeud64gsnh2MhGMZeWzssE0Sjw4IdYgSlSDQjeHYMyZ40X50cG4aBC+WrQcjUUotCpKQt8=
X-Received: by 2002:a17:906:688a:: with SMTP id n10mr11446840ejr.389.1632493094561;
 Fri, 24 Sep 2021 07:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210924033547.939554938@goodmis.org> <20210924000717.310b492a@rorschach.local.home>
 <CACGkJdtsHWBstw_Gzb-Dq4Xs_eAW1jsARr5wbh0yE_=NsPA5bw@mail.gmail.com>
 <20210924091627.645a8fd3@gandalf.local.home> <20210924223549.c41a89befe11534dfd56f01c@kernel.org>
In-Reply-To: <20210924223549.c41a89befe11534dfd56f01c@kernel.org>
From:   Eugene Syromyatnikov <evgsyr@gmail.com>
Date:   Fri, 24 Sep 2021 16:18:10 +0200
Message-ID: <CACGkJdspTL=tnDOSvY3ub235rr+6eUBU1uBhHFZbqBkegcRvnw@mail.gmail.com>
Subject: Re: [PATCH 0/2] tracing: Have trace_pid_list be a sparse array
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Sep 24, 2021 at 3:35 PM Masami Hiramatsu <mhiramat@kernel.org> wrot=
e:
>
> On Fri, 24 Sep 2021 09:16:27 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> > I'm optimizing the top tiers for size, because they are likely to be em=
pty.
> > Why add memory for something that will never be used, and can't be remo=
ved.
> > Note, the middle and lower tiers can be reused when they go empty, whic=
h is
> > a likely use case (at least when I test this using hackbench).

Makes sense;  I was thinking about worse case scenarios=E2=80=94tracing
thousands+ processes, but those probably not as common and important.

> > I looked into xarray and it appears to be optimized for storing somethi=
ng,
> > where as I'm just interested in a sparse bitmask.
>
> I guess he suggested that store the bitmask in xarray. Anyway, both are
> OK to me. This is needed for reducing the memory.

Yes, the idea was to store pointers to bitset leaves in XArray and
leverage its radix tree implementation, at cost of somewhat lesser
efficiency (since XArray indices are longs and thus it employs more
intermediate levels on 64-bit architectures).

--=20
Eugene Syromyatnikov
mailto:evgsyr@gmail.com
xmpp:esyr@jabber.{ru|org}
