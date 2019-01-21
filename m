Return-Path: <SRS0=G/lh=P5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DATE_IN_PAST_06_12,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PLING_QUERY,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2991FC31D63
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 07:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30E120823
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 07:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUKS9ULT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfAUHTG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:19:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33688 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfAUHTF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jan 2019 02:19:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so22029945wrr.0;
        Sun, 20 Jan 2019 23:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mk/j+BSGz6dVS/plPYQdwoqk6n0f8DCpTutXyR8+Se8=;
        b=PUKS9ULTj9Cn+GS5fK3qe9ldH0HCraiycg3dkxWAWculsLrZM7TwO8EmFZTlSp9UaM
         GvP98Vb0cWSSlnWhgBxY7SUo/n+xedChEGgC5Po29jh05/jD+Y/x7+3L9A9aKShP1i7O
         54IloxpunpCWj5Q1luj3wx0OeZZOZ7lYWKyJFyGiXytLFiA3mTnarPQFoaCdhb5nhigp
         /6dbhM4dDnENIrF5KtXAJDRL0DJMYDcMAVWV/Sm6XROC5prEiQrw/QR2sQQDvWhEl2L0
         Yl0id3K0helfI47eRBC9dHmEjs+HNt2/f7Ypz+ZTBwBMwxyBBGcnKb5KFrUgVxM4hbsj
         rK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mk/j+BSGz6dVS/plPYQdwoqk6n0f8DCpTutXyR8+Se8=;
        b=Nh8/AXTRkaXnHxlvxlkupBkHIFiLBH8p5+SA5VxeC7Jt12UvYIk6sX8mgy4NmtxfC/
         qpburC/X6rd9xveG4kdZ0R/WPXn3q5EchR3an4pi/v2AYXxRiJ1+aC+ns7gxjxzi4oMo
         5/Sf816cFx4HyOjyNkmrGwwpIQAqSgSnIRkP3fTTW/Ozn+QQ16bZNMRrqWWMYF+XWTfX
         oTKwOiRhARLCJmkyPBM/XpLSUXv+fmGsp4P5gfugFn4dJ3xUCoT4zRZm18HmWgiiNddX
         UuSX5YuRE9TlTEiSAIESEYZMYG4alRPYwK58vfA67ZDOFxGbP/9zllf6BZ4/fp6EE+uF
         TXaQ==
X-Gm-Message-State: AJcUukdM5A9ItKHvyDyA/AVz3wU7WK5E/BPM4G2N7osLpsbRWNiJre07
        CDRn6zsATLSC+W/ychaOeSriTPoaqufLguSOKSsZHE7P9Ow=
X-Google-Smtp-Source: ALg8bN6PdBwtacBzoDQdeuTqywBEpzdAjrcVZeexxXSqiwvArC5mELXxPORIN/mZumWwPYMUmEgwRqGVDThaXr2Q0bQ=
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr24395580wrv.308.1548030204348;
 Sun, 20 Jan 2019 16:23:24 -0800 (PST)
MIME-Version: 1.0
References: <CAKcZhuW-ozJp-MVU3gw=uhuSc9+HTMVJza8QRUL3TaRrbqjJew@mail.gmail.com>
 <CACT4Y+aJADsj37Y8jPAV7PASqKm_L-iJ=MDv68yPUO0TFvhdRg@mail.gmail.com>
 <CACT4Y+ZxgzdbCeFquYmKThfiTGg3pZhn90X_Fk3yRXGYfepU4Q@mail.gmail.com> <CAKcZhuWE_2+D_AP_U0XZP-bjb=8Eec1Ku3KD8qO8K0zDGo98Ow@mail.gmail.com>
In-Reply-To: <CAKcZhuWE_2+D_AP_U0XZP-bjb=8Eec1Ku3KD8qO8K0zDGo98Ow@mail.gmail.com>
From:   Zenghui Yu <zenghuiyu96@gmail.com>
Date:   Mon, 21 Jan 2019 08:23:12 +0800
Message-ID: <CAKcZhuUh7jqLnRwfROcryEGHvUNqGhz751uPP54yg3WcwYCWwQ@mail.gmail.com>
Subject: Re: [RESEND BUG REPORT] System hung! Due to ftrace or KASAN?
To:     Dmitry Vyukov <dvyukov@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        aryabinin@virtuozzo.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, cl@linux.com, mark.rutland@arm.com,
        will.deacon@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 21, 2019 at 2:28 AM Zenghui Yu <zenghuiyu96@gmail.com> wrote:
>
> On Sun, Jan 20, 2019 at 12:45 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Sat, Jan 19, 2019 at 5:37 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Fri, Jan 18, 2019 at 6:45 PM Zenghui Yu <zenghuiyu96@gmail.com> wrote:
> > > >
> > > > Hi, All!
> > > >
> > > > I compiled the latest kernel and installed it on my old laptop (Hardware name:
> > > > Hewlett-Packard HP ProBook 440 G2/2247, BIOS M74 Ver. 01.02 06/17/2014).  But
> > > > when I tried to enable function tracer via debugfs, the system went _hung_!
> > > > Compared with the last kernel compiling process, the only change I have made
> > > > is that I enabled KASAN configuration this time.
> > > >
> > > > Reproducing this issue is simple as below:
> > > >
> > > >         0. `uname -a` shows:
> > > >                 Linux ubuntuu 5.0.0-rc2+ #9 SMP Fri Jan 18 03:04:01 CST 2019
> > > >                 x86_64 x86_64 x86_64 GNU/Linux
> > > >
> > > >         1. `make menuconfig` to enable KASAN configuration:
> > > >                 Kernel hacking ---> Memory Debugging --->
> > > >                 KASAN: runtime memory debugger
> > > >
> > > >            compile, install, reboot, then `dmesg | grep kasan` shows:
> > > >                 [    0.342882] kasan: KernelAddressSanitizer initialized
> > > >
> > > >         2. enable function tracer
> > > >                 `echo function > /sys/kernel/debug/tracing/current_tracer`
> > > >            (then my poor laptop was locked and didn't respond to me ...)
> > > >
> > > > What's more, enabling function graph tracer will suffer from the same problem.
> > > > I have no idea about what wrong thing had happened inside kernel --
> > > > about ftrace,
> > > > or about KASAN?  So I report it to you and waiting for your solution!
> > > >
> > > > I have provided my *.config* file as attachment for those who're interested in
> > > > this issue.  But sorry for that I can't provide any useful call trace
> > > > because the
> > > > system went down so quickly.
> > > >
> > > > P.S. I'm a newcomer for KASAN. If any mis-configuration or
> > > > mis-understand, please
> > > > fix me up and let me know :).
> > >
> > > Hi Zenghui,
> > >
> > > I've tried to reproduce this, but kernel crashes during boot with this
> > > config for me.
> > > I am commit 2339e91d0e6609e17943a0ab3c3c8c4044760c05, the config is
> > > basically yours but updated for newer compiler and with builtin
> > > modules:
> > > https://gist.githubusercontent.com/dvyukov/9af234617749aa4eada67ba8c2e4f46c/raw/d0e09ddf255962313a82bb552c3fc0d832fa6844/gistfile1.txt
> >
> > I've commented out the warning locally for now and can reproduce the
> > hang. You need this commit, it fixes the hang:
> > https://groups.google.com/forum/#!topic/kasan-dev/g8A8PLKCyoE
>
> Thanks Dmitry! I'll try to test this commit tomorrow.

And this commit really works fine to me! Thanks Dmitry again!


Zenghui

>
> BTW, I have bisect-ed and tested for this issue today. Finally it turned out
> that
>         bffa986c6f80e39d9903015fc7d0d99a66bbf559 is the first bad commit.
> So I'm wondering if anywhere need to be fixed in commit bffa986c6f80 ("kasan:
> move common generic and tag-based code to common.c").
>
>
> Thanks!
> Zenghui
>
> >
> > > TITLE: WARNING in note_page
> > > MAINTAINERS: [dave.hansen@linux.intel.com luto@kernel.org
> > > peterz@infradead.org tglx@linutronix.de mingo@redhat.com bp@alien8.de
> > > hpa@zytor.com x86@kernel.org linux-kernel@vger.kernel.org]
> > >
> > > ------------[ cut here ]------------
> > > x86/mm: Found insecure W+X mapping at address native_usergs_sysret64+0x0/0x10
> > > WARNING: CPU: 3 PID: 1 at arch/x86/mm/dump_pagetables.c:263 note_wx
> > > arch/x86/mm/dump_pagetables.c:262 [inline]
> > > WARNING: CPU: 3 PID: 1 at arch/x86/mm/dump_pagetables.c:263
> > > note_page+0x800/0xaf0 arch/x86/mm/dump_pagetables.c:302
> > > Kernel panic - not syncing: panic_on_warn set ...
> > > CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.0.0-rc2+ #16
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x7b/0xb5 lib/dump_stack.c:113
> > >  panic+0x18e/0x351 kernel/panic.c:214
> > >  __warn+0x13c/0x140 kernel/panic.c:571
> > >  report_bug+0xd7/0x140 lib/bug.c:186
> > >  fixup_bug.part.11+0x2d/0x60 arch/x86/kernel/traps.c:178
> > >  fixup_bug arch/x86/include/asm/paravirt.h:776 [inline]
> > >  do_error_trap+0xb6/0xc0 arch/x86/kernel/traps.c:271
> > >  do_invalid_op+0x3b/0x50 arch/x86/kernel/traps.c:290
> > >  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
> > > RIP: 0010:note_wx arch/x86/mm/dump_pagetables.c:262 [inline]
> > > RIP: 0010:note_page+0x800/0xaf0 arch/x86/mm/dump_pagetables.c:302
> > > Code: 4d 32 00 4c 89 7b 28 48 c7 43 30 00 00 00 00 e9 46 fc ff ff 4c
> > > 89 ee 48 c7 c7 a0 35 c5 ae c6 05 02 81 1e 02 01 e8 50 93 01 00 <0f> 0b
> > > 48 8b 7d 90 e8 75 4c 32 00 48 8b 43 20 48 89 45 c8 e9 72 f9
> > > RSP: 0000:ffff88805d5c7d18 EFLAGS: 00010286
> > > RAX: 0000000000000000 RBX: ffff88805d5c7e58 RCX: ffffffffae7f11db
> > > RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000246
> > > RBP: ffff88805d5c7da0 R08: ffffed100bab8f5c R09: ffffed100bab8f5c
> > > R10: 0000000000000002 R11: ffffed100bab8f5c R12: 0000000000000000
> > > R13: ffffffffae800000 R14: 0000000000000004 R15: 0000000000000000
> > >  walk_pmd_level arch/x86/mm/dump_pagetables.c:428 [inline]
> > >  walk_pud_level arch/x86/mm/dump_pagetables.c:459 [inline]
> > >  walk_p4d_level arch/x86/mm/dump_pagetables.c:484 [inline]
> > >  ptdump_walk_pgd_level_core+0x566/0x6e0 arch/x86/mm/dump_pagetables.c:552
> > >  ptdump_walk_user_pgd_level_checkwx+0x4e/0x50 arch/x86/mm/dump_pagetables.c:600
> > >  pti_finalize+0x27/0xaf arch/x86/mm/pti.c:682
> > >  kernel_init+0x3e/0x130 init/main.c:1066
> > >  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:352
> > > Kernel Offset: 0x2c800000 from 0xffffffff81000000 (relocation range:
> > > 0xffffffff80000000-0xffffffffbfffffff)
> > > Rebooting in 86400 seconds..
