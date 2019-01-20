Return-Path: <SRS0=3rps=P4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PLING_QUERY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8920FC26641
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Jan 2019 18:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4538A2084C
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Jan 2019 18:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpYQx2uI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfATS3H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Jan 2019 13:29:07 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33943 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfATS3H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Jan 2019 13:29:07 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so20870394wrw.1;
        Sun, 20 Jan 2019 10:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4lbeObJYjBvma63KYVQBbWpFcmujcQ6nXp4C0mn664=;
        b=kpYQx2uIamDW+PST/83QKVAjqttOv1Ksfw1pAnVvCPHiNgy70F41tEFL/pFCNeNrJJ
         dWyxLtHuwiKjVqwjwLNYu1e7NPhrE1kQwt2BUItbl9p8DBq2hRW9qe4zU7UOfea/EBc1
         LMopOrbZvJbXK/Y3rh6kE3Dh/eQWEgHQZm1Fk4so5J32Ie5CNdvQ824TBKmGjtkhkB8W
         WHWU0YusirIGiJknrk2J/ZXJ7ljf61jWg6IzBM6JH9o8UtPGaHlzYu+xxvKZ+iAT/sKU
         EdtBk9Yp5+HXShan7igWkNKeJiMkuMlbnEoYZ1yXq7auvPRtKxz3pvtMkFTsrrQYXkuw
         oBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4lbeObJYjBvma63KYVQBbWpFcmujcQ6nXp4C0mn664=;
        b=gFXJX+Q2E1AECwbAVyO7coPlKFkveJFGmFeFw2IIa/FH2QG79nurZ7tSK09501Fimz
         ki8abKEjQQdy/ne5S8rtU5KR1X87zVGVeEom2rSLqOskBxUxOQO3D9UBWjUmPyKkCWjJ
         vMRRyCciwGKl8ks8xVuugrihdJP9RzsfvMM1RLiqFFC2/EPo105Q+ONq9b1CAmh+vLfC
         KmET+YyYl0zJ8fZVPO789qrEHPW00SaKJjWVeSag5Ob3OPmHZNMn5l87c8+Fk/MfUvbp
         omcrYxShwFkGPiTDmev3cWMwY22bLY1xYVEml7N3vbSP6oQ+843eDHFKp1FfheVpVUCG
         BCXw==
X-Gm-Message-State: AJcUukdoqIZ8NI0WM1wEBs53ajYgu7sB8MTfQi8YeF1pmEaax55eGcbM
        GinfqN0j8U3jJ6zzYy0GG8i0R556b7J7C1OmwYE=
X-Google-Smtp-Source: ALg8bN4HxlD27jYsmDvjvzjxae2FikMA5chusl1dwI0swxtlLBZxt5eqHijK8fI6cBJxqxyosWuf6wJ6ovFFXEWBiIQ=
X-Received: by 2002:adf:ae1a:: with SMTP id x26mr24130744wrc.0.1548008944985;
 Sun, 20 Jan 2019 10:29:04 -0800 (PST)
MIME-Version: 1.0
References: <CAKcZhuW-ozJp-MVU3gw=uhuSc9+HTMVJza8QRUL3TaRrbqjJew@mail.gmail.com>
 <CACT4Y+aJADsj37Y8jPAV7PASqKm_L-iJ=MDv68yPUO0TFvhdRg@mail.gmail.com> <CACT4Y+ZxgzdbCeFquYmKThfiTGg3pZhn90X_Fk3yRXGYfepU4Q@mail.gmail.com>
In-Reply-To: <CACT4Y+ZxgzdbCeFquYmKThfiTGg3pZhn90X_Fk3yRXGYfepU4Q@mail.gmail.com>
From:   Zenghui Yu <zenghuiyu96@gmail.com>
Date:   Mon, 21 Jan 2019 02:28:53 +0800
Message-ID: <CAKcZhuWE_2+D_AP_U0XZP-bjb=8Eec1Ku3KD8qO8K0zDGo98Ow@mail.gmail.com>
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
        LKML <linux-kernel@vger.kernel.org>, andreyknvl@google.com,
        aryabinin@virtuozzo.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, cl@linux.com, mark.rutland@arm.com,
        will.deacon@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Jan 20, 2019 at 12:45 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sat, Jan 19, 2019 at 5:37 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Fri, Jan 18, 2019 at 6:45 PM Zenghui Yu <zenghuiyu96@gmail.com> wrote:
> > >
> > > Hi, All!
> > >
> > > I compiled the latest kernel and installed it on my old laptop (Hardware name:
> > > Hewlett-Packard HP ProBook 440 G2/2247, BIOS M74 Ver. 01.02 06/17/2014).  But
> > > when I tried to enable function tracer via debugfs, the system went _hung_!
> > > Compared with the last kernel compiling process, the only change I have made
> > > is that I enabled KASAN configuration this time.
> > >
> > > Reproducing this issue is simple as below:
> > >
> > >         0. `uname -a` shows:
> > >                 Linux ubuntuu 5.0.0-rc2+ #9 SMP Fri Jan 18 03:04:01 CST 2019
> > >                 x86_64 x86_64 x86_64 GNU/Linux
> > >
> > >         1. `make menuconfig` to enable KASAN configuration:
> > >                 Kernel hacking ---> Memory Debugging --->
> > >                 KASAN: runtime memory debugger
> > >
> > >            compile, install, reboot, then `dmesg | grep kasan` shows:
> > >                 [    0.342882] kasan: KernelAddressSanitizer initialized
> > >
> > >         2. enable function tracer
> > >                 `echo function > /sys/kernel/debug/tracing/current_tracer`
> > >            (then my poor laptop was locked and didn't respond to me ...)
> > >
> > > What's more, enabling function graph tracer will suffer from the same problem.
> > > I have no idea about what wrong thing had happened inside kernel --
> > > about ftrace,
> > > or about KASAN?  So I report it to you and waiting for your solution!
> > >
> > > I have provided my *.config* file as attachment for those who're interested in
> > > this issue.  But sorry for that I can't provide any useful call trace
> > > because the
> > > system went down so quickly.
> > >
> > > P.S. I'm a newcomer for KASAN. If any mis-configuration or
> > > mis-understand, please
> > > fix me up and let me know :).
> >
> > Hi Zenghui,
> >
> > I've tried to reproduce this, but kernel crashes during boot with this
> > config for me.
> > I am commit 2339e91d0e6609e17943a0ab3c3c8c4044760c05, the config is
> > basically yours but updated for newer compiler and with builtin
> > modules:
> > https://gist.githubusercontent.com/dvyukov/9af234617749aa4eada67ba8c2e4f46c/raw/d0e09ddf255962313a82bb552c3fc0d832fa6844/gistfile1.txt
>
> I've commented out the warning locally for now and can reproduce the
> hang. You need this commit, it fixes the hang:
> https://groups.google.com/forum/#!topic/kasan-dev/g8A8PLKCyoE

Thanks Dmitry! I'll try to test this commit tomorrow.

BTW, I have bisect-ed and tested for this issue today. Finally it turned out
that
        bffa986c6f80e39d9903015fc7d0d99a66bbf559 is the first bad commit.
So I'm wondering if anywhere need to be fixed in commit bffa986c6f80 ("kasan:
move common generic and tag-based code to common.c").


Thanks!
Zenghui

>
> > TITLE: WARNING in note_page
> > MAINTAINERS: [dave.hansen@linux.intel.com luto@kernel.org
> > peterz@infradead.org tglx@linutronix.de mingo@redhat.com bp@alien8.de
> > hpa@zytor.com x86@kernel.org linux-kernel@vger.kernel.org]
> >
> > ------------[ cut here ]------------
> > x86/mm: Found insecure W+X mapping at address native_usergs_sysret64+0x0/0x10
> > WARNING: CPU: 3 PID: 1 at arch/x86/mm/dump_pagetables.c:263 note_wx
> > arch/x86/mm/dump_pagetables.c:262 [inline]
> > WARNING: CPU: 3 PID: 1 at arch/x86/mm/dump_pagetables.c:263
> > note_page+0x800/0xaf0 arch/x86/mm/dump_pagetables.c:302
> > Kernel panic - not syncing: panic_on_warn set ...
> > CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.0.0-rc2+ #16
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x7b/0xb5 lib/dump_stack.c:113
> >  panic+0x18e/0x351 kernel/panic.c:214
> >  __warn+0x13c/0x140 kernel/panic.c:571
> >  report_bug+0xd7/0x140 lib/bug.c:186
> >  fixup_bug.part.11+0x2d/0x60 arch/x86/kernel/traps.c:178
> >  fixup_bug arch/x86/include/asm/paravirt.h:776 [inline]
> >  do_error_trap+0xb6/0xc0 arch/x86/kernel/traps.c:271
> >  do_invalid_op+0x3b/0x50 arch/x86/kernel/traps.c:290
> >  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
> > RIP: 0010:note_wx arch/x86/mm/dump_pagetables.c:262 [inline]
> > RIP: 0010:note_page+0x800/0xaf0 arch/x86/mm/dump_pagetables.c:302
> > Code: 4d 32 00 4c 89 7b 28 48 c7 43 30 00 00 00 00 e9 46 fc ff ff 4c
> > 89 ee 48 c7 c7 a0 35 c5 ae c6 05 02 81 1e 02 01 e8 50 93 01 00 <0f> 0b
> > 48 8b 7d 90 e8 75 4c 32 00 48 8b 43 20 48 89 45 c8 e9 72 f9
> > RSP: 0000:ffff88805d5c7d18 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: ffff88805d5c7e58 RCX: ffffffffae7f11db
> > RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000246
> > RBP: ffff88805d5c7da0 R08: ffffed100bab8f5c R09: ffffed100bab8f5c
> > R10: 0000000000000002 R11: ffffed100bab8f5c R12: 0000000000000000
> > R13: ffffffffae800000 R14: 0000000000000004 R15: 0000000000000000
> >  walk_pmd_level arch/x86/mm/dump_pagetables.c:428 [inline]
> >  walk_pud_level arch/x86/mm/dump_pagetables.c:459 [inline]
> >  walk_p4d_level arch/x86/mm/dump_pagetables.c:484 [inline]
> >  ptdump_walk_pgd_level_core+0x566/0x6e0 arch/x86/mm/dump_pagetables.c:552
> >  ptdump_walk_user_pgd_level_checkwx+0x4e/0x50 arch/x86/mm/dump_pagetables.c:600
> >  pti_finalize+0x27/0xaf arch/x86/mm/pti.c:682
> >  kernel_init+0x3e/0x130 init/main.c:1066
> >  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:352
> > Kernel Offset: 0x2c800000 from 0xffffffff81000000 (relocation range:
> > 0xffffffff80000000-0xffffffffbfffffff)
> > Rebooting in 86400 seconds..
