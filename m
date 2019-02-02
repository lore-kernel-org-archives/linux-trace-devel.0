Return-Path: <SRS0=pRBY=QJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PLING_QUERY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92892C282D7
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Feb 2019 11:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6237D20818
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Feb 2019 11:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RD7FJlwk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfBBLwk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 2 Feb 2019 06:52:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37514 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfBBLwj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 2 Feb 2019 06:52:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so9796480wrt.4;
        Sat, 02 Feb 2019 03:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ksj9lR9aCRIAxKlY5wuozGKeWj7FX+QSVWoU3V6r49Y=;
        b=RD7FJlwk6dyu39zhTyejr6x+hkwOVQLzObRwjw3svckwdOAWEs5qlUrGI1WrTULLt9
         aYRPIC5yuOm9OVhGUV3GkbFTHfBe+WzgJQxlF4MK+cEDAUPasp1IL6qKY9E56GIu3eIE
         t9I/XWdoXItZ7PBhvjf6IPMpO/qZFYqgO0/zIUKSjtDuL3B10U3mNz+xRye/+5arTWbp
         cvx8anxgNUhV+E/vVV3tMVYS65UdgjkkrR1oPDjCZK/GFg9SB+zsrVzFWwMJaxvBKJfW
         1t4IWaM3PMJu0rPTRPkk/ndWEdwRa17+80zxyXshudN1aCwoEO3tTJqMVhuvTXcL420G
         DeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ksj9lR9aCRIAxKlY5wuozGKeWj7FX+QSVWoU3V6r49Y=;
        b=ajHfDdWBFqmoRtHvzZ0q7Pw65uJKMuzjqk8KNQMv7zl8BcstOyGqnR0qfhDPWCVmrW
         CDgCmm3eneya86PeWjUY86j6IDnjADw1Qrsm8Z4CVtyhLKFwD1jS4p+C7noa4jvnvOFj
         ncmkAooCztxCHXbL/f4St40ks7gxXGr4ZfAJVRGuLtijjqaP2+8sw29MZ3X4QvkrLmxm
         ESD6X4jurnED0LbDP3GxGGG5h8vledC8FoQrc5N1huNAwgCgFJA1lS0/LKyywnodhjDc
         IF6cWRtOltKvaHM5X/d8XP5WX/8I4I/pB+JSPRMVF8w//fFgbQPuIz1ilqK4HmBf/3f7
         n4Bw==
X-Gm-Message-State: AJcUukdB5D5PKs8NiAzZI9rf5q+wfBX2IRBC2/xWDqjNcy3ZQMjYGCKk
        AOOWYgYrOCbbDV7y2IDGJcwdhUlHoLgSjowRdMU=
X-Google-Smtp-Source: ALg8bN7Q+G/hi+qkocjZsl7fVgDev5XTi14ZjGY4GY5hfNitqwJGIst7JcbcD7FPrgU4cCmgN2pXACrXWp4EDOH1iak=
X-Received: by 2002:adf:ae1a:: with SMTP id x26mr41120668wrc.0.1549108357587;
 Sat, 02 Feb 2019 03:52:37 -0800 (PST)
MIME-Version: 1.0
References: <CAKcZhuW-ozJp-MVU3gw=uhuSc9+HTMVJza8QRUL3TaRrbqjJew@mail.gmail.com>
 <CACT4Y+aJADsj37Y8jPAV7PASqKm_L-iJ=MDv68yPUO0TFvhdRg@mail.gmail.com>
 <CACT4Y+ZxgzdbCeFquYmKThfiTGg3pZhn90X_Fk3yRXGYfepU4Q@mail.gmail.com>
 <CAKcZhuWE_2+D_AP_U0XZP-bjb=8Eec1Ku3KD8qO8K0zDGo98Ow@mail.gmail.com>
 <CACT4Y+Ye+0bBV5sB1F3wVbCC1guyA=RdsRnYHgrar=AhftGtQA@mail.gmail.com>
 <20190121175842.0f526757@vmware.local.home> <CACT4Y+Y7PJ1=dv6wzDTVRkFJCnrtDYyksmYp6UibW9a8_ob0Nw@mail.gmail.com>
In-Reply-To: <CACT4Y+Y7PJ1=dv6wzDTVRkFJCnrtDYyksmYp6UibW9a8_ob0Nw@mail.gmail.com>
From:   Zenghui Yu <zenghuiyu96@gmail.com>
Date:   Sat, 2 Feb 2019 19:52:24 +0800
Message-ID: <CAKcZhuXfgXvpb2YNVanA_TZHzHWj59_sB2YYwyTsoXKeW2bG2g@mail.gmail.com>
Subject: Re: [RESEND BUG REPORT] System hung! Due to ftrace or KASAN?
To:     Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Linux-MM <linux-mm@kvack.org>,
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

On Tue, Jan 29, 2019 at 9:16 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, Jan 29, 2019 at 1:27 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 21 Jan 2019 10:36:25 +0100 Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > > > Thanks Dmitry! I'll try to test this commit tomorrow.
> > > >
> > > > BTW, I have bisect-ed and tested for this issue today. Finally it turned out
> > > > that
> > > >         bffa986c6f80e39d9903015fc7d0d99a66bbf559 is the first bad commit.
> > > > So I'm wondering if anywhere need to be fixed in commit bffa986c6f80 ("kasan:
> > > > move common generic and tag-based code to common.c").
> > >
> > > Thanks for bisecting. I think we have understanding of what happens
> > > here and it's exactly this that needs to be fixed:
> > > https://groups.google.com/d/msg/kasan-dev/g8A8PLKCyoE/vXnirYEnCAAJ
> > > And this commit already fixes it.
> >
> > Has that been sent in my direction?  I can't find it.
> >
> > If sending it please add
> >
> > Tested-by: Dmitry Vyukov <dvyukov@google.com>
> > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>

Also,

Tested-by: Zenghui Yu <zenghuiyu96@gmail.com>

on x86 machines, if need :)


Thanks!

>
> Yes, it's here (State: New):
> https://lore.kernel.org/patchwork/patch/1024393/
>
> This page says it was mailed to linux-mm mailing list too:
> https://groups.google.com/forum/#!topic/kasan-dev/g8A8PLKCyoE
>
> But I can't find linux-mm archives here:
> http://vger.kernel.org/vger-lists.html
>
> How can I add a tag to an existing change under review? Patchwork does
> not show something like "add Tested-by: me tag" to me on the patch
> page.
>
> Patchwork shows Todo list on the main page with "Your todo list
> contains patches that have been delegated to you". But I don't see an
> option to delegate this patch to you either...
