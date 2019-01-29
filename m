Return-Path: <SRS0=wE5d=QF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PLING_QUERY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA58C169C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jan 2019 13:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C2720880
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jan 2019 13:17:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f061IAuH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfA2NQ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Jan 2019 08:16:58 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:51899 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfA2NQ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Jan 2019 08:16:57 -0500
Received: by mail-it1-f196.google.com with SMTP id w18so4416566ite.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Jan 2019 05:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IkoDHTcoQExAmP/zAYGRu0okBS/vxY+ZLfd6eRLq2ws=;
        b=f061IAuHSK40I6nwWINrYYQYRCskJ9MACDwUkTWtcLX1aQvOTh17RYGlMImOEtf+Dd
         acKrpU8urBDqKrja8BBPGU/+nT6RVfROPCxwCZimgWsUrKreBe5PqpstY3NI800dTk+B
         xGYZymOzfSWs2UXdEK/ekgexvdqxH4+1Wk//UTa9dtBFpo0iAjzUhnRSykfnS7uBhbnN
         xG7r2zSbXB99vdr3zYuyP6yFz7OtwCKcvffIm3rA1PDQ7gmGm4e80jifZc0GNTJxN1as
         DApyhr7QFfWnC1NyvEwujhryzwldweuPn5V6sbbYfUgf4p8zP9/hJE35p67u0XSBY3hb
         GzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IkoDHTcoQExAmP/zAYGRu0okBS/vxY+ZLfd6eRLq2ws=;
        b=Q1dXj+6FxoO3JWqU9VvW2hliS5Za4sEuAlQ4HINzcuFNTAEPalDPu+6MinPe+fIja6
         /An/RRHv1YE0bpHhZ8nMbmUhVnHfZbsBcZ/Q5nfnSq9gI35e9t6StDYQkmVdtSGGb0Kj
         A27z9anotjVxU/mcLUkR0uGksKvpeI3/6qygNfPAk/llXF84Ofs4yCU/Ssh1Pp6LPslu
         anmYx7KU+J2nXO+YAWuEgHDUv+tqSY9DK6E/LiJ6kttzlQPQhZe05Rhwd+rNRhW70Z7c
         GoS97aOC1ZkYtEoAweCOAVnlGkik74Vw+UmQYTHscocyzpDBpWdOWfEfMUZvsdj6XrB1
         fTpg==
X-Gm-Message-State: AJcUukdC65Zt7HBs8JvMD3EqgwfFc2usu/mHvOPLOPxl11KvlFf2DxEF
        ibKzYefTu4zrD0K7nQumn7KWGRHa9ydTy9AjFK5kYg==
X-Google-Smtp-Source: ALg8bN6HUj/A2UU9bghOpcHs1qK2Z+MApKf0C4wuxVMRcYDAospR59LbC5gWi/li/WD2y0jw96rJ6UbiFVPgZsFKDXE=
X-Received: by 2002:a05:660c:f94:: with SMTP id x20mr11173972itl.144.1548767816077;
 Tue, 29 Jan 2019 05:16:56 -0800 (PST)
MIME-Version: 1.0
References: <CAKcZhuW-ozJp-MVU3gw=uhuSc9+HTMVJza8QRUL3TaRrbqjJew@mail.gmail.com>
 <CACT4Y+aJADsj37Y8jPAV7PASqKm_L-iJ=MDv68yPUO0TFvhdRg@mail.gmail.com>
 <CACT4Y+ZxgzdbCeFquYmKThfiTGg3pZhn90X_Fk3yRXGYfepU4Q@mail.gmail.com>
 <CAKcZhuWE_2+D_AP_U0XZP-bjb=8Eec1Ku3KD8qO8K0zDGo98Ow@mail.gmail.com>
 <CACT4Y+Ye+0bBV5sB1F3wVbCC1guyA=RdsRnYHgrar=AhftGtQA@mail.gmail.com> <20190121175842.0f526757@vmware.local.home>
In-Reply-To: <20190121175842.0f526757@vmware.local.home>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 29 Jan 2019 14:16:43 +0100
Message-ID: <CACT4Y+Y7PJ1=dv6wzDTVRkFJCnrtDYyksmYp6UibW9a8_ob0Nw@mail.gmail.com>
Subject: Re: [RESEND BUG REPORT] System hung! Due to ftrace or KASAN?
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
Cc:     Zenghui Yu <zenghuiyu96@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 29, 2019 at 1:27 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 21 Jan 2019 10:36:25 +0100 Dmitry Vyukov <dvyukov@google.com> wrote:
>
> > > Thanks Dmitry! I'll try to test this commit tomorrow.
> > >
> > > BTW, I have bisect-ed and tested for this issue today. Finally it turned out
> > > that
> > >         bffa986c6f80e39d9903015fc7d0d99a66bbf559 is the first bad commit.
> > > So I'm wondering if anywhere need to be fixed in commit bffa986c6f80 ("kasan:
> > > move common generic and tag-based code to common.c").
> >
> > Thanks for bisecting. I think we have understanding of what happens
> > here and it's exactly this that needs to be fixed:
> > https://groups.google.com/d/msg/kasan-dev/g8A8PLKCyoE/vXnirYEnCAAJ
> > And this commit already fixes it.
>
> Has that been sent in my direction?  I can't find it.
>
> If sending it please add
>
> Tested-by: Dmitry Vyukov <dvyukov@google.com>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>


Yes, it's here (State: New):
https://lore.kernel.org/patchwork/patch/1024393/

This page says it was mailed to linux-mm mailing list too:
https://groups.google.com/forum/#!topic/kasan-dev/g8A8PLKCyoE

But I can't find linux-mm archives here:
http://vger.kernel.org/vger-lists.html

How can I add a tag to an existing change under review? Patchwork does
not show something like "add Tested-by: me tag" to me on the patch
page.

Patchwork shows Todo list on the main page with "Your todo list
contains patches that have been delegated to you". But I don't see an
option to delegate this patch to you either...
