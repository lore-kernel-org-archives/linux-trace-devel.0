Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03E4C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 12:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AED8921855
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 12:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="kQh7eu4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfCNM1w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 08:27:52 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37327 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfCNM1v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 08:27:51 -0400
Received: by mail-qt1-f194.google.com with SMTP id z17so5751879qtn.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 05:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6flR/SZ3bVyvGpeBMlCe2ZUtI2LHYS6gvOXI4e6BfpI=;
        b=kQh7eu4cXQZsGXIDCyZUWIYrnP4SyHjyEFvqeDX9qwPtnZcuVZwGG+PjPGwiNcoOW4
         K6ThH9dTXFVHXQ8v4C8+VL2bakspMZATm2KkwyVhMgEQB5zCyrrNAkrL1M2cYBGHrKzN
         f+mj5cuB3C4v+kP1Bu40/h0NQwqAOdgzZb3J4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6flR/SZ3bVyvGpeBMlCe2ZUtI2LHYS6gvOXI4e6BfpI=;
        b=hN7tdU/h8DtEGnKubq2zYJIvUEnXYKoyozc9Zg0nzm3gw48MeVa6ZZNnUpFfGjhG/n
         pae/d7H87y0H6ELDHhM9nRoa1hqnVsYOSKstd9kIrfXYnBTSocLs0+ZTLoIB3TVjyDah
         jKEzHf0MEbjS3CCXf9LLlksC2RG04YrvuBI5mx14S6X7ZWpAdrnKWyp7xU1NxgOSGH0K
         zRVu54HvEHDnuC5i5FgOmdHFfMp23T+YmniJDfAnDAJtc/aAn/CjVBeld37fuYV9ZcYT
         +l7tNZ+PZ1Sb2fHjKSRx8JVMxHNu0dNIlpHZT9T3swwdU25B3YtwTTtKIsesvSla87Yw
         fYRg==
X-Gm-Message-State: APjAAAUvlOoVClt8LUVI3JOiemoydVnn8yMlUt5MP5aRfMYDuzcCfqIE
        d4sQA5ziRzGUvJnfaRRQxENlDg==
X-Google-Smtp-Source: APXvYqy2IZqfZEb8pYZbKHCl44Uhexadk5h0/fwVSteoQa1v1VP2dysxz0REKQPzCiHRqC15nDXZfg==
X-Received: by 2002:ac8:2bc1:: with SMTP id n1mr37856804qtn.176.1552566470361;
        Thu, 14 Mar 2019 05:27:50 -0700 (PDT)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id k33sm8837364qte.8.2019.03.14.05.27.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 05:27:48 -0700 (PDT)
Date:   Thu, 14 Mar 2019 08:27:48 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190314122748.GA101545@google.com>
References: <20190309121141.GA30173@kroah.com>
 <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
 <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
 <20190311193612.4f09bf11@oasis.local.home>
 <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
 <20190312003912.GA170478@google.com>
 <20190311212823.60684182@oasis.local.home>
 <CAJWu+oqsD_wHGWfzj6POFowiY2qcu04auVzkA6Lu9R+LR4gkrQ@mail.gmail.com>
 <20190313101843.800dd8d6a9babb635580ebdc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313101843.800dd8d6a9babb635580ebdc@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Masami,
Sorry for late reply as I was traveling.

On Wed, Mar 13, 2019 at 10:18:43AM +0900, Masami Hiramatsu wrote:
> On Mon, 11 Mar 2019 18:38:49 -0700
> Joel Fernandes <joelaf@google.com> wrote:
> 
> > On Mon, Mar 11, 2019 at 6:28 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Mon, 11 Mar 2019 20:39:12 -0400
> > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > > I think even though the kernel-headers can't have information about all data
> > > > structures, they do already contain a lot of data structure definitions we
> > > > need already. And anything needed can/should arguably be moved to include/ if
> > > > they are really needed for kernel extension by something "external" to the
> > > > kernel such as kernel modules or eBPF, right?
> > >
> > > That's not my worry. I would like to be able to easily walk data
> > > structures from within the kernel, without having to do a lot of work
> > > in userspace to get that information. The kprobe_events could then be
> > > passed type casts or such to access data fields of arguments to
> > > functions and such.
> > 
> > Ok.
> > 
> > > > In any case, such a solution such as what Steve suggested, still cannot do
> > > > what we can with headers - such as build kernel modules on the fly using the
> > > > C-compiler without any auto-generation of C code from any debug artifiacts.
> > > > Think systemtap working with the module-backend without any need for
> > > > linux-headers package on the file system. So such a solution would still be a
> > > > bit orthogonal in scope to what this proposed solution can solve IMO.
> > > >
> > >
> > > With the information I would like to have, it would be trivial to read
> > > the data to create the header files needed for modules.
> > 
> > But there are macros and other #define things too. We lose all of them
> > and can't recreate them from just DWARF (AFAIK). Including
> > include/generated/autoconf.h which #defines the CONFIG options. For
> > that we either need headers, or full kernel's sources with build
> > artifacts.
> 
> What kind of macros would you concern?
> 
> > I do see a use case for the debug info you are talking about as you
> > mentioned for the kprobe_events argument list types, and I already
> > thought about it. But it does not seem to work for all the use cases I
> > am referring to here.
> 
> But the eBPF is based on kprobe-events. What kind of usage would you
> expected? (with macros??)

eBPF C programs are compiled with kernel headers. They can execute inline
functions or refer to macros in the kernel headers. They are similar to
kernel modules where you build a C program that then later is executed in
kernel context. It goes through the whole compiler pipeline. This is slightly
different usage from pure kprobe-events.  Also eBPF kprobe programs need
LINUX_VERSION_CODE (or similarly named) macro which it provides to the bpf(2)
syscall when loading kprobe programs. This is because eBPF implementation in
the kernel checks if the eBPF programs that use kprobes are being loaded
against the right kernel.

thanks,

- Joel

