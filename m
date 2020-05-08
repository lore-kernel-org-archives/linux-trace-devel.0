Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA57BC47254
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 13:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919BD20870
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 13:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iREBKBN8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgEHNOc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 09:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729496AbgEHMq4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 08:46:56 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88361C05BD43
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 05:46:56 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id r66so8299606oie.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 05:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MU2o2U9j5OVyPBrkDtHokwEm2GEbzWTWZHovzYr7d6c=;
        b=iREBKBN8KRbUi72ifTO+4YzDD7l+eTlr1/5m8wNFTC2HxuDdIjCrfdepgrb4y7PfAZ
         Yjt8kN5vIq46oIVQdnbqnq2uULWSl2yvccwq+lUtt08DrNmHpDjl+NMFULktgMeo7zuq
         HkIYBz2KN245AvsuDRtIKc7/j7w9vxcz3bsP0juwTHo7lpxw6/jeI9Xs58k5iZBFguZK
         4VxE0DXOciE8mvx4TyeG4ERytfMbi/nSbo/PG2yv2QLwNYhTqagZgXLtxRD84cUEgZ9/
         W/VKLeAiNydw76+wre9sN1JS2q2p11dFx9HuPf9ZnsQet7fV63zEOX8fQSOr9/IuJ/pt
         WpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MU2o2U9j5OVyPBrkDtHokwEm2GEbzWTWZHovzYr7d6c=;
        b=kMEzH6jk7jzZr41J7NokBsu9bsbL0ptwa/RzOJS29SVxj6FL0GdKR8zsuYRtbyA9Io
         XQhRrPf4v6gmrJ5JZfxbWCe+6dNJgrASZ5kNKtrL21e2Xy11zMrKpKd7JK72tMniiBDi
         2+KoR954q7shvuQx0vMe2TmtVw9uSZfzUJ1w6hQiZJ5dTxhD1Qq+6aev7Bf2LuJibp4n
         v3YtvBlsx8et+W9qehsCHMVtm64I/pd9oWuGuA175oUE+ybB/FVK3nUwJErxnaoQORf6
         SiOwxaA4FAIdbDlr22ArCWyhuV2KaAXE/CCv55QEM8560hUU71dRJiijY7cZrZq6Zg91
         klBw==
X-Gm-Message-State: AGi0PuY1TzeUCucO5M+nifKj9jNGShtsVLimALaaGFGWPDvcn0831sIz
        78p8645/SuGZIiKzbwI50VqUQdH6uUPomnLKYsKFfbFI
X-Google-Smtp-Source: APiQypLDmCcwWsgu7mMvM/1LxysDEtGBPdD1vEeqya7nnlJ+ergNgnT75hRenyetAsKPtCtFybk+SeVwHWPodJRFk30=
X-Received: by 2002:aca:1007:: with SMTP id 7mr10470597oiq.139.1588942015885;
 Fri, 08 May 2020 05:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
 <20200420154325.6072d96b@gandalf.local.home> <20200420155320.55d3c3f2@gandalf.local.home>
 <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
In-Reply-To: <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 8 May 2020 13:46:19 +0100
Message-ID: <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 20, 2020 at 11:37 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> On Mon, Apr 20, 2020 at 8:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 20 Apr 2020 15:43:25 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > > On Fri, 17 Apr 2020 21:39:14 +0100
> > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > > The build fails while building with gcc-10 with the error:
> > > > multiple definition of `common_type_field'
> > >
> <snip>
> >
> > OK, I'll take this patch, and may even enable a -fno-common to find other
> > cases of this without having to wait till my distro adds gcc 10 by default.

A gentle ping.

-- 
Regards
Sudip
