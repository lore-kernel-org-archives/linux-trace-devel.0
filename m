Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01385C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 00:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B874820657
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 00:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="JI0daxOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfCLAjQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 20:39:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34871 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfCLAjQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 20:39:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id h39so763796qte.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 17:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ly3PyJhiRQi4oId3Jp/I4y9kAhs1iw828BmSysRKyZ8=;
        b=JI0daxOZRh0PkhQAbU8+ah7z11OagpX6fwhO38Lk6ozIcUs80I5Au1B/H+ckOkLRfN
         pv0Vr4WfmVRnGaAADux+nuB0lVD4e/ey885zZbAXm25lq5Ax7MRtanG/DDVzyzpxFcZ7
         M7hooDTN5M3QxYhOreCsGfWXjuOpQFimpUSkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ly3PyJhiRQi4oId3Jp/I4y9kAhs1iw828BmSysRKyZ8=;
        b=jr68mcFEhUOHHCzIcx2LBHCy3dnfPztd4CCtfFa4E6XbHR3lY+xnr1yOrxxuWZ+k6J
         m1ljuoLa/PfwicLPWGHccajvgIaxlWGcOWDzZG3zZqlsbPwpY+/XXp/ha+4YqQ0ExV8j
         mOGwMRNifzo8IeusQ2KbgNzBIBQVFuIKR7o/HfyzczFo/bgBmR2BQRMsUQ7uBJFiE8u8
         rzNUYFbvxh8l9RElVV69/BSChILFcp13sMsHXov7unoq0k+Y890hVOu3OCtlXFqpHJ0k
         rZZCEdw1R9qqS5HglvSB9hzNJnIYPi+mf1GWbdL8YDS2G414lICkiov/+OHYUV7chXYX
         t4oQ==
X-Gm-Message-State: APjAAAU1KiUoEifI4ggQmFmc6+9aNyBFeJbNSWFzUWtPxDF4B9sIhuDa
        pL/2JdL16aDCjSMFMI+plScX0A==
X-Google-Smtp-Source: APXvYqz+iHMK77Oj/SvnFoapIG3HmPyK+b4/w/1OkGxjCjN0asdsP9LWAG5l+h/cqvR4h5vbjdEnBg==
X-Received: by 2002:ac8:2527:: with SMTP id 36mr13155134qtm.308.1552351154545;
        Mon, 11 Mar 2019 17:39:14 -0700 (PDT)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id u48sm132343qtu.89.2019.03.11.17.39.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 17:39:13 -0700 (PDT)
Date:   Mon, 11 Mar 2019 20:39:12 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Daniel Colascione <dancol@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20190312003912.GA170478@google.com>
References: <20190308140251.GC25768@kroah.com>
 <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com>
 <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com>
 <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
 <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
 <20190311193612.4f09bf11@oasis.local.home>
 <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 04:58:28PM -0700, Daniel Colascione wrote:
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
> lot about inspecting user state from the kernel and have some weird
> ideas in that area (e.g., why not register eBPF programs to unwind
> user stacks?) --- but I think that Joel's work is independent of all
> that. I'm curious what you think we can do about userspace. I wish we
> could just compile the world with frame pointers, but we can't.

Yeah, most of the usecases for eBPF tracing are all instrumenting the kernel
using kprobes.  There are some usecases that instrument userspace with
uprobes but those don't need headers.

> > What I would love, is a table that has all structures and their fields
> > with information about their types, size and signed types. Like the
> > format fields in the events directory. This way ebpf (and kprobes,
> > internally in the kernel) could access this table and be able to know
> > what the data structures of the kernel is).
> 
> Think of the headers as encoding this information and more and the C
> compiler as a magical decoder ring. :-) I totally get the desire for a
> metadata format a little less messy than C code, but as a practical
> matter, a rich C-compilation pipeline already exists, and the
> debuginfo you're proposing doesn't, except in the form of DWARF, which
> I think would be even more controversial to embed in the kernel memory
> image than headers are. A header blob provides a strict superset of
> the information your scheme provides.

I think even though the kernel-headers can't have information about all data
structures, they do already contain a lot of data structure definitions we
need already. And anything needed can/should arguably be moved to include/ if
they are really needed for kernel extension by something "external" to the
kernel such as kernel modules or eBPF, right?

In any case, such a solution such as what Steve suggested, still cannot do
what we can with headers - such as build kernel modules on the fly using the
C-compiler without any auto-generation of C code from any debug artifiacts.
Think systemtap working with the module-backend without any need for
linux-headers package on the file system. So such a solution would still be a
bit orthogonal in scope to what this proposed solution can solve IMO.

thanks,

 - Joel

