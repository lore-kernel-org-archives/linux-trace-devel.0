Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7DFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F0EA6120E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhKEOnO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhKEOnN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 10:43:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DC7C061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 07:40:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n8so11221150plf.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 07:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5xmw4AqiB3I1NS5WAHXhsaiWJqYsLII1rDXauPeDCPc=;
        b=DXW9TmSaBECclWccWqjoghQu2uNAXF58toN2eoXYEfiIyBIj6SUfJ+SnKiXcbtWPlo
         MRiBskhJ6vm/TIb1kxBd32jcW/Qm9gM1Ti47B87TVPPzE3bGyk3EafXzNYM+IVmVBM8V
         NSEsIcVrLhX+K6U7jCPmiwcvehf8sb9K2yf8om9NK7mk4E8f5SMnxgdWQ78vO2xdiFpD
         ldnnLcaJDRBhl+V6TEQ3tLHWdmWPcwsOjQvbkjVklsYN74B4GRkobeG+a1cb4t4oUoMx
         P6hxNkBjiYcOhtpRyCWUR3V2ei3ebig3kFzf6patXPmdyj1zLrekdh5jSTmIQqovEz5v
         gv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5xmw4AqiB3I1NS5WAHXhsaiWJqYsLII1rDXauPeDCPc=;
        b=YMxcZZ710BFqdCP18xgosBuHAwFJzQjg0sX+grygD97EniUOCBxElbJ5SL9LuLlMcr
         YPS052sYRW4CEv20Qd0F8/X9xxtz4IqYr2Eo3f/8n1OYTFYBoE5t4/U5i6jeLPSLSC4Q
         ssLs9OAIwk1Kk454oAr9g9D5BNQLLzqQyG/KnhzooNbO+kTlO31ixlZ1+mpn84sycjdz
         erXsCZY+03CW2J1l8PTwcRMESPbt3VkSwa2fxApzZc83jd1rri5m56/yAH1/bW55OxKy
         2792ZYM4w6US4RMtrkie5xJOButwF9PaF+LhxooszbA7CC2zw8D8+YmJWM76mtD7Sidi
         SVfg==
X-Gm-Message-State: AOAM5322mfrZRv8TukQfKsoYVrjSMK63gAonli8zkQusrjAlO1fVW6tz
        v6mOIPUsfEjdp80UKhSXHO15otX1H4HMKrOkDX8=
X-Google-Smtp-Source: ABdhPJw46bbpxAns2s2ZkCfI50d2aXM1BtNgH5ctxKrpnGzcgTM8bZKzbw7/PgS+ngUPVfe9R+12P6nfqSOZJECnBto=
X-Received: by 2002:a17:90a:5917:: with SMTP id k23mr30840628pji.111.1636123233204;
 Fri, 05 Nov 2021 07:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
 <20211105121624.398717-12-tz.stoyanov@gmail.com> <20211105102426.76a20a4b@gandalf.local.home>
 <CAPpZLN6E1f3KCnCxS_=D=Qjv2zxB3tiunie4uMZGBHJXm7BvHw@mail.gmail.com>
In-Reply-To: <CAPpZLN6E1f3KCnCxS_=D=Qjv2zxB3tiunie4uMZGBHJXm7BvHw@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 5 Nov 2021 16:40:17 +0200
Message-ID: <CAPpZLN4u7oW9+nbmcHBvh5QWjQyEm40hXFtFAiP4vYvt=tD7pQ@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] libtracefs: Remove man page compile artifact
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Nov 5, 2021 at 4:34 PM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> On Fri, Nov 5, 2021 at 4:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri,  5 Nov 2021 14:16:23 +0200
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >
> > > The libtracefs-sqlhist.txt.1 file is generated during the tracefs
> > > library man pages compilation, it should not be part of the sources.
> >
> > Are you sure about that?
> >
> > What creates it?
> >
> > -- Steve
>
> "make doc" generates it on my machine, and "make doc_clean" removes it.

hmm I'm wrong - only the second is true, "make doc_clean" removes it.
That should be fixed.

>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
