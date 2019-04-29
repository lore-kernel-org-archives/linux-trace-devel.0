Return-Path: <SRS0=8Jl/=S7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CA9C43219
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Apr 2019 14:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F49204EC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Apr 2019 14:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Q6PRyhoK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfD2O3p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 10:29:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34766 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbfD2O3p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 10:29:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so4271263pgt.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Apr 2019 07:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WcPAUupWuUJ9uw6w4LNzP0iB9AcsAU9AYb/3oXfMvwA=;
        b=Q6PRyhoKPf031uvtAuys2j2z3C8eSrpz0r0Zd2L9MC7r/78hpJEhnsaWELp08SNA72
         kUtOse5O2XKfQR5CIIwBrm7hqqQk3dy1CcptRkegy7AN5DbP7lBBLOlus3qeilUIEtFI
         D1EYYwqPG3XqCm+DDCx1mCHjq/WteGdHagFNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WcPAUupWuUJ9uw6w4LNzP0iB9AcsAU9AYb/3oXfMvwA=;
        b=hmbb6BYOXtUpXfoIDLfcwE1tShkN/BfiBqN8Q1ToYCKe4bpLWL0O597qOfiK+1f7Hh
         o0LAYxHFCOL++AXal88raLCSlJ7j1NoKws+YkBkFDSdU+ZlB7AYfahOADhMuDrfB6g3g
         4NTSA+RPUgc6KIUOE80kM5D6XHvMaPyzjBn7VAugjvjo7BCnWfKaGFLy6mCGXCfoU3Ep
         ROw+E0X6StmiDKR75WTkQZh8W8wjuqHzqrGQTvP848dkDHJ88fWSN/ocz5wbazBUHM5w
         eadc2MPFPRKvel81aflxM05I8LYOEx/0iQBaIyiqRj36OcHRCfEqCDWVnt6NNfv7wity
         neRw==
X-Gm-Message-State: APjAAAUlnXm8KjK/nY0bCIlDd1ikCNx0NORJRYvkRCR3WHh5x77+oybr
        yk4iBnUs0YwQglRetcINN8oQbA==
X-Google-Smtp-Source: APXvYqySVnFhsh2wUnXudSTRVDD+qJhT0VRlDBoe2i+ArFb+q8ROGEAPEbXuB77beAGieTDopzewtA==
X-Received: by 2002:a63:8149:: with SMTP id t70mr12045527pgd.134.1556548184065;
        Mon, 29 Apr 2019 07:29:44 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id z16sm653529pfa.42.2019.04.29.07.29.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 07:29:43 -0700 (PDT)
Date:   Mon, 29 Apr 2019 10:29:41 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 resend 1/2] Provide in-kernel headers to make
 extending kernel easier
Message-ID: <20190429142941.GA178173@google.com>
References: <20190426190430.172543-1-joel@joelfernandes.org>
 <20190427133844.GA29366@kroah.com>
 <20190429132602.GA165075@google.com>
 <20190429135455.GA2412@kroah.com>
 <CAK7LNARkGLQ_P4LSuC69QN8XPN47W5ujkDE3EauLrwnBgygsSA@mail.gmail.com>
 <20190429142425.GB29007@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429142425.GB29007@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 29, 2019 at 04:24:25PM +0200, Greg KH wrote:
> On Mon, Apr 29, 2019 at 11:14:30PM +0900, Masahiro Yamada wrote:
> > On Mon, Apr 29, 2019 at 10:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Apr 29, 2019 at 09:26:02AM -0400, Joel Fernandes wrote:
> > > > On Sat, Apr 27, 2019 at 03:38:44PM +0200, Greg KH wrote:
> > > > > On Fri, Apr 26, 2019 at 03:04:29PM -0400, Joel Fernandes (Google) wrote:
> > > > > > Introduce in-kernel headers which are made available as an archive
> > > > > > through proc (/proc/kheaders.tar.xz file). This archive makes it
> > > > > > possible to run eBPF and other tracing programs that need to extend the
> > > > > > kernel for tracing purposes without any dependency on the file system
> > > > > > having headers.
> > > > > >
> > > > > > A github PR is sent for the corresponding BCC patch at:
> > > > > > https://github.com/iovisor/bcc/pull/2312
> > > > > >
> > > > > > On Android and embedded systems, it is common to switch kernels but not
> > > > > > have kernel headers available on the file system. Further once a
> > > > > > different kernel is booted, any headers stored on the file system will
> > > > > > no longer be useful. This is an issue even well known to distros.
> > > > > > By storing the headers as a compressed archive within the kernel, we can
> > > > > > avoid these issues that have been a hindrance for a long time.
> > > > > >
> > > > > > The best way to use this feature is by building it in. Several users
> > > > > > have a need for this, when they switch debug kernels, they do not want to
> > > > > > update the filesystem or worry about it where to store the headers on
> > > > > > it. However, the feature is also buildable as a module in case the user
> > > > > > desires it not being part of the kernel image. This makes it possible to
> > > > > > load and unload the headers from memory on demand. A tracing program can
> > > > > > load the module, do its operations, and then unload the module to save
> > > > > > kernel memory. The total memory needed is 3.3MB.
> > > > > >
> > > > > > By having the archive available at a fixed location independent of
> > > > > > filesystem dependencies and conventions, all debugging tools can
> > > > > > directly refer to the fixed location for the archive, without concerning
> > > > > > with where the headers on a typical filesystem which significantly
> > > > > > simplifies tooling that needs kernel headers.
> > > > > >
> > > > > > The code to read the headers is based on /proc/config.gz code and uses
> > > > > > the same technique to embed the headers.
> > > > > >
> > > > > > Other approaches were discussed such as having an in-memory mountable
> > > > > > filesystem, but that has drawbacks such as requiring an in-kernel xz
> > > > > > decompressor which we don't have today, and requiring usage of 42 MB of
> > > > > > kernel memory to host the decompressed headers at anytime. Also this
> > > > > > approach is simpler than such approaches.
> > > > > >
> > > > > > Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > >
> > > > > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > > > Thanks for the Reviewed-by tag. I believe there are still 2 logistical things
> > > > to merge this.
> > > > 1. Location of the header archive:
> > > > Olof and Steve did not like it to be in /proc and instead /sys seemed a better
> > > > choice they are Ok with. Me and Greg were Ok with it being in /sys/kernel/.
> > > > Alexei, Greg and me are Ok with either proc or Sys.
> > >
> > > As you say, either is fine with me.
> > >
> > > > 2. Who is going to pull this patch: This seems a matter of where the header
> > > > archive resides. If it is in /sys/kernel/ then I am assuming Greg will pull
> > > > it.  Masahiro has given his Reviewed-by tag, is he the one to pull it?
> > >
> > > I can take it, but it probably should just go through the kbuild tree,
> > > as that makes more sense to me.
> > 
> > 
> > I do not want to take responsibility for this.
> 
> Hah, ok, I'll be glad to queue this up in my tree.  I'll take it now,
> and if people who really object to this being in /proc/ and want it in
> /sys/, we can add a follow-on patch before 5.2-final is out to move the
> file to that location.

Sounds great to me. thanks!

 - Joel

