Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1CDC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 15:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45B1E2054F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 15:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfCLP0z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfCLP0y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 11:26:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E13A82054F;
        Tue, 12 Mar 2019 15:26:51 +0000 (UTC)
Date:   Tue, 12 Mar 2019 11:26:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Daniel Colascione <dancol@google.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190312112650.680e27c4@gandalf.local.home>
In-Reply-To: <20190312014522.jfxg3pdav2piuaqs@ast-mbp>
References: <20190309071648.GE3882@kroah.com>
        <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
        <20190309121141.GA30173@kroah.com>
        <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
        <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
        <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
        <20190311193612.4f09bf11@oasis.local.home>
        <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
        <20190312003912.GA170478@google.com>
        <20190311212823.60684182@oasis.local.home>
        <20190312014522.jfxg3pdav2piuaqs@ast-mbp>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Mar 2019 18:45:24 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> what you're asking for we already have. It's called BTF.

Cool.

> pahole takes vmlinux dwarf and convert it into ~1Mbyte of BTF that includes
> all kernel types.
> With gzip it can be compressed further if necessary.
> We also have a prototype to generate all_vmlinux_types.h from BTF.
> But it's not a substitute for kernel headers.
> We've had a long discussion during last LPC regarding this:
> http://vger.kernel.org/lpc-bpf2018.html#session-2
> tldr: many tracing use cases will be solved with BTF, but kernel headers
> are here to stay.

Is this work a result of that session? (I was only able to attend part
of the BPF sessions due to conflicts). I guess I should watch the
videos.

-- Steve
