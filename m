Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86CFC433E7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 20:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E4A020BED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 20:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+8uHOnk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgJLUYw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgJLUYv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 16:24:51 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D88C0613D0;
        Mon, 12 Oct 2020 13:24:51 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h6so14297657ybi.11;
        Mon, 12 Oct 2020 13:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mPDRTH/UAmqiZe/Nd+O6hbWblTr9qXFpQQlns3fD3iE=;
        b=D+8uHOnkHBz6iSEEfFJ/OjAVHb1XtTdx+1e95GnMxjpu2pF+zhCl3FqZcj8HMxQPsM
         CgzHOcJDIsv8FtmwI+zARpBurSzoWLIFx0o0d2KnZmnf6NGQ3rljyb3w9+Zv1xiJFnj6
         wLouEidevcL8/eRNQUyKqudfW7Xt7YnjqVHlJK417GWp22ga2YM6TLZP2ANJnMwg71JM
         B1/ZMT3jwjNVaMVuyQEHj41h+mefdvIwc+yAW07bYiDG4mdPeQYZMrt4u9w+kCs+7sGO
         JB1LXZ5A0BcPxHVJ9GFWx7EWAYUWVsdarZsIAmm6G3jD38jJJZTtKiiqFOEoJR+weFg7
         9OQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mPDRTH/UAmqiZe/Nd+O6hbWblTr9qXFpQQlns3fD3iE=;
        b=HtA4aA3rXKT5mvfjphpToSb/l8Ath/i+HuiaymX33frHYfU8Zvr2PuzarMt8rOmbwV
         64maD29S4Ws6WhXNT4qL20oe+U7su4r7yDvle/KtsePzSx6I3ouCdMprlXGs9gWZEgjb
         zD/1+TDKj+lytxh+FvwYV0undEcPKp90AZb2MtH8L7NMV1BPTOHcLQsFy9a56tkuj9PY
         S2O97c1hZe5pjhkUVhsnOrzUAPkYM2SuJXUH6xIwCPaBzoEeKMcFwSTQmFYb7XvbNf+G
         QU6AVmE/V+bYmSVaO9tboHzcm0hnNzclgMyod54bltjP3qSAh1Vp0dGfqsnxTOdW94PE
         DKSQ==
X-Gm-Message-State: AOAM53392t/ez/q8hXf7Yn0MYOjeG2kz/Rf6k45w129zhPV8lMndqZ0A
        PrkP342PlzDs2ETUuBFCAggiCReSF9avqSRBLm44ZYx2o6InZw==
X-Google-Smtp-Source: ABdhPJwA8pSXy3h5uyuwCmRBdEH4YIZ7cz8KHMk0jhM+8tfmo+ZE+GC3QpYs2LgLTOIEKlk08PwWU+EL1WTTWBWyFRI=
X-Received: by 2002:a25:b88d:: with SMTP id w13mr14219456ybj.39.1602534291042;
 Mon, 12 Oct 2020 13:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20201007130750.49349844@gandalf.local.home> <20201012101208.GF1099489@krava>
 <20201012111950.55a73588@gandalf.local.home> <20201012184120.GN13697@suse.de> <20201012151732.6e439886@gandalf.local.home>
In-Reply-To: <20201012151732.6e439886@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 12 Oct 2020 21:24:14 +0100
Message-ID: <CADVatmNwkpArcEqDfFYPrFxpSWuSoDiVAKVBQsaW9zAide-jTg@mail.gmail.com>
Subject: Re: [ANNOUNCE] libtraceevent.git
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        zsun@redhat.com, Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Mon, Oct 12, 2020 at 8:17 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> [ Removing the powertop mailing list because it's rejecting everything ]
>
> On Mon, 12 Oct 2020 11:41:20 -0700
> Tony Jones <tonyj@suse.de> wrote:
>
> > On Mon, Oct 12, 2020 at 11:19:50AM -0400, Steven Rostedt wrote:
> >
> > > Once it's shown that it works for all the package maintainers, I will tag
> > > it which should create the tarballs automatically on the above link.
> >

Works for me.

> Can you see if this patch fixes your current issue?
>
> -- Steve
>
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index edb8623..3a981be 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -157,7 +157,7 @@ endif
>  do-install-man: man
>         $(call QUIET_INSTALL, Documentation-man) \
>                 $(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
> -               $(INSTALL) -m 644 $(DOC_MAN3) $(DESTDIR)$(man3dir);
> +               $(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
>
>  install-man: check-man-tools man do-install-man
>

I faced the same problem and this patch worked for me.


-- 
Regards
Sudip
