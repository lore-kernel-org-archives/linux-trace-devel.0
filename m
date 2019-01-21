Return-Path: <SRS0=G/lh=P5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PLING_QUERY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F12C37121
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 22:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DB520861
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 22:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfAUW7A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jan 2019 17:59:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfAUW7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jan 2019 17:59:00 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9485F2085A;
        Mon, 21 Jan 2019 22:58:52 +0000 (UTC)
Date:   Mon, 21 Jan 2019 17:58:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
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
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [RESEND BUG REPORT] System hung! Due to ftrace or KASAN?
Message-ID: <20190121175842.0f526757@vmware.local.home>
In-Reply-To: <CACT4Y+Ye+0bBV5sB1F3wVbCC1guyA=RdsRnYHgrar=AhftGtQA@mail.gmail.com>
References: <CAKcZhuW-ozJp-MVU3gw=uhuSc9+HTMVJza8QRUL3TaRrbqjJew@mail.gmail.com>
        <CACT4Y+aJADsj37Y8jPAV7PASqKm_L-iJ=MDv68yPUO0TFvhdRg@mail.gmail.com>
        <CACT4Y+ZxgzdbCeFquYmKThfiTGg3pZhn90X_Fk3yRXGYfepU4Q@mail.gmail.com>
        <CAKcZhuWE_2+D_AP_U0XZP-bjb=8Eec1Ku3KD8qO8K0zDGo98Ow@mail.gmail.com>
        <CACT4Y+Ye+0bBV5sB1F3wVbCC1guyA=RdsRnYHgrar=AhftGtQA@mail.gmail.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Jan 2019 10:36:25 +0100
Dmitry Vyukov <dvyukov@google.com> wrote:

> > BTW, I have bisect-ed and tested for this issue today. Finally it turned out
> > that
> >         bffa986c6f80e39d9903015fc7d0d99a66bbf559 is the first bad commit.
> > So I'm wondering if anywhere need to be fixed in commit bffa986c6f80 ("kasan:
> > move common generic and tag-based code to common.c").  
> 
> Thanks for bisecting. I think we have understanding of what happens
> here and it's exactly this that needs to be fixed:
> https://groups.google.com/d/msg/kasan-dev/g8A8PLKCyoE/vXnirYEnCAAJ
> And this commit already fixes it.

I just got a chance to look at that commit, and I knew exactly what the
bug was when looking at the broken commit. And yes, the fix is the
correct fix for the issue.

KASAN can be triggered by parts of the function tracer that is outside
of the recursion protection. If that part of KASAN is also traced by
the function tracer, it will cause a infinite recursion and crash the
system.

Seeing that code that was moved out of the "-pg" removal into a file
that is compiled with "-pg" (which is what causes function tracer to
trace functions in that file), was going to cause issues.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
