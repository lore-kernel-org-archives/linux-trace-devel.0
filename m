Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A86AC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 01:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1695214D8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 01:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfCLBWS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 21:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfCLBWS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 21:22:18 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C181214AF;
        Tue, 12 Mar 2019 01:22:12 +0000 (UTC)
Date:   Mon, 11 Mar 2019 21:22:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Colascione <dancol@google.com>
Cc:     Karim Yaghmour <karim.yaghmour@opersys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
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
Message-ID: <20190311211952.129c5821@oasis.local.home>
In-Reply-To: <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
        <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
        <20190307150343.GB258852@google.com>
        <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
        <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
        <20190308140251.GC25768@kroah.com>
        <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
        <20190309071648.GE3882@kroah.com>
        <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
        <20190309121141.GA30173@kroah.com>
        <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
        <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
        <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
        <20190311193612.4f09bf11@oasis.local.home>
        <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Mar 2019 16:58:28 -0700
Daniel Colascione <dancol@google.com> wrote:

> On Mon, Mar 11, 2019 at 4:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Sat, 9 Mar 2019 16:44:31 -0500
> > Karim Yaghmour <karim.yaghmour@opersys.com> wrote:
> >
> >  
> > > Sorry, I should've been clearer. I'm including eBPF/BCC into the
> > > "user-space tools" here. That was in fact my prime motivation in
> > > encouraging Joel at the last LPC to look at this. I've been integrating
> > > the teaching of eBPF into my AOSP debugging and performance analysis
> > > class (see CC courseware here:
> > > http://www.opersys.com/training/android-debug-and-performance), and it
> > > was pretty messy trying to show people how to benefit from such tools
> > > under Android. Joel's present set of patches would obviate this problem.  
> >
> > I've been reading this thread and staying out for the most part. But I
> > was thinking about how I could use kernel headers for things like
> > kprobes, and I want to mention the pony that I would like to have :-)
> >
> > Are headers really needed, and more importantly, are they enough? What
> > if userspace is 32bit and the kernel is 64bit. Can ebpf scripts handle
> > that?  
> 
> Why would eBPF care about the bit width of userspace? I've thought a

How do you know the difference between long if you are running on a
64bit kernel in 32bit userspace? I haven't compiled into ebpf byte
code, so I'm clueless here, but I know other tools (PowerTop) got burnt
when it assumed "long" was 4 bytes when digging into the kernel via
trace events, when the kernel was 64bit and user was 32bit.

> lot about inspecting user state from the kernel and have some weird
> ideas in that area (e.g., why not register eBPF programs to unwind
> user stacks?) --- but I think that Joel's work is independent of all
> that. I'm curious what you think we can do about userspace. I wish we
> could just compile the world with frame pointers, but we can't.

I don't care about user space here. I'm talking about the tools that
need to dig into the kernel, but the tools are 32bit and the kernel is
64bit. Of course, if the tools know the kernel is 64bit regardless,
then it doesn't matter.

> 
> > What I would love, is a table that has all structures and their
> > fields with information about their types, size and signed types.
> > Like the format fields in the events directory. This way ebpf (and
> > kprobes, internally in the kernel) could access this table and be
> > able to know what the data structures of the kernel is).  
> 
> Think of the headers as encoding this information and more and the C
> compiler as a magical decoder ring. :-) I totally get the desire for a
> metadata format a little less messy than C code, but as a practical
> matter, a rich C-compilation pipeline already exists, and the
> debuginfo you're proposing doesn't, except in the form of DWARF, which
> I think would be even more controversial to embed in the kernel memory
> image than headers are. A header blob provides a strict superset of
> the information your scheme provides.

We already embed dwarf like information in the kernel. It's called ORC,
and is used by bpf (as well as perf, ftrace and stack dumps) when we
need to read functions. A very small subset of dwarf like data would be
used. Just the data structures, nothing else.

-- Steve
