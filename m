Return-Path: <SRS0=uef1=D2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B4FC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Oct 2020 18:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6526D222E9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Oct 2020 18:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1F9ZsVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgJSS7z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Oct 2020 14:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgJSS7y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 14:59:54 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42C1C0613CE;
        Mon, 19 Oct 2020 11:59:54 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id d15so457684ybl.10;
        Mon, 19 Oct 2020 11:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hjNvB7DOT6hanEZJZatHoN5FAFK/jJShTwKmBOtELEk=;
        b=L1F9ZsVxsg8tYe+M4XNGV3H19GYw41Q6vCAitJJNG+0Up2T8CPibTOCQSa+N/tuFVr
         fBNVINqgFL/fk6UeYa9SXLI+MnCFf0DDxvOYE+66rKOembIiLIpBETUTrNM3xngqSdUi
         tD34fXSCuGRJU/G7PGQblng0nklY6v1rTdHJKTfNQs22Md/BP9gn4XfgH8TiH/0rhLBC
         nSLaIqhbtAUYlyuex7CjVPAnqTBR7nqCTcmnQB0R3KLU0g5drIxJQlKSd/cQ7lfPl5Yq
         x6ocjwTUqaoQMxu7K595Ls3RFk8YwvKij42eXwbdkc1Noio2VNkDzAJTwrdnRr3IoHSg
         4N0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hjNvB7DOT6hanEZJZatHoN5FAFK/jJShTwKmBOtELEk=;
        b=HOKnkyQn+Q7yofQRmCpWaItFAUZoYTDSRxEcZexIOeFQK/uWMJNxG1Hvuc+YT2HexF
         5mAgmSgglkowUdfJaeHOpT/bG46RTwNomBll+2MB31TXL/ljVr5Rr7iOPqjjnt0OmMsK
         /icWUskGtrax9TOZkrXbeIZfH+Btyt4t2MfXdJAQdcTQ748C+Kc0EEYwLAuSL/fIAGFT
         OhEfZwt+lnuBS6uSenh0jvqCaxLFDyZi23QN4e2uxhxQGysLd+OnfEHseo2pPoJYEcOP
         tXpqM1+bTni/Rcs6tSV9QekJoktg9/Y1Gtt13r82ymIu43U5vnUx3nE5/TuPAn9XlAoi
         oxKQ==
X-Gm-Message-State: AOAM5314W40Z3zrtmfxorFwU4hjeCtXwgRvLRzPK7fm3cIfqwPwEZqXM
        5aLoQVsGhH6BJasWfatRWIiFXVBeA8749uKNbkMe+/oK8KcW0A==
X-Google-Smtp-Source: ABdhPJzSSdgVQOY9/H8dTyrx2wsuu5Rkmk3duLISBGvxMABsTit8DuujOqNWnjV2xQe+TbDIA7GKGdyODIURJaDXCl0=
X-Received: by 2002:a25:41c9:: with SMTP id o192mr1010880yba.127.1603133993971;
 Mon, 19 Oct 2020 11:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201018211912.17541-1-sudipm.mukherjee@gmail.com> <20201019094234.0b36bb61@gandalf.local.home>
In-Reply-To: <20201019094234.0b36bb61@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 19 Oct 2020 19:59:18 +0100
Message-ID: <CADVatmMPHQvO1CwTEpgtotiDjAQiecbAQf=Mt_5oHHcqa2GV7w@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: install html files
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Mon, Oct 19, 2020 at 2:42 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sun, 18 Oct 2020 22:19:12 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> > Only the man pages were installed using "make install". Add rules to
> > install html files also.
> >
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > ---
> >  tools/lib/traceevent/Documentation/Makefile | 14 ++++++++++++--
>
> Thanks Sudip,
>
> Although, to apply it to the libtraceevent.git repo, I had to strip off the
> "tools/lib/traceevent/" from the file paths.

I was actually confused about which repo is to be followed for
development purposes. I assumed all patches will land here and you
will then mirror them to libtraceevent.git repo when you decide to
make a release. I can send you a patch for libtraceevent.git repo if
you want.


-- 
Regards
Sudip
