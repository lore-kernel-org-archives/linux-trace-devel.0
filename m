Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A0AC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 205BB60C41
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhFVNdb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 09:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFVNdb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 09:33:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5640E60C41;
        Tue, 22 Jun 2021 13:31:15 +0000 (UTC)
Date:   Tue, 22 Jun 2021 09:31:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v6 17/45] trace-cmd library: Add support for zlib
 compression library
Message-ID: <20210622093113.0e5c0384@gandalf.local.home>
In-Reply-To: <CAPpZLN5oB30ZUKkbeFuLhPuigMPzi4AT7P7mPTYd1AuHXXVuhw@mail.gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
        <20210614075029.598048-18-tz.stoyanov@gmail.com>
        <20210621212633.455fb125@oasis.local.home>
        <CAPpZLN5oB30ZUKkbeFuLhPuigMPzi4AT7P7mPTYd1AuHXXVuhw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Jun 2021 13:29:36 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Tue, Jun 22, 2021 at 4:26 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 14 Jun 2021 10:50:01 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > If libz is available, use that library to provide trace file compression
> > > support. The library is detected runtime.  
> >
> > Why have the library detected at runtime?
> >
> > If it is detected, we can then have the library flags include -lz.
> >
> > Why use dlopen to load zlib? And not just include it?
> >
> > This seems rather fragile to try to get right.  
> 
> The idea of this design is not to bring additional mandatory
> dependencies. I do not know if libz is available by default, but even
> if we assume it is - each additional compression library that is added
> will be a mandatory dependency. The compression is not a mandatory
> functionality, trace-cmd can work without it. Why do you think it is
> fragile, I think dlopen() uses the same core linker logic to find and
> load the library. The only difference I see is that using "-lz" leads
> to a mandatory dependency, trace-cmd will not run without it.
> 

The dependency is determined at compile time, just like we do for the
python libraries, and dwarf, and anything else that might add a new
feature.

Let me explain a scenario of why I called it fragile. Let's say that
trace-cmd has no package dependency on zlib, but the system has some other
package that does have a dependency. Thus the package manager pulls in zlib
to satisfy this other package.

The user does a recording, and trace-cmd detects zlib, and compresses the
data.

Later, the user decides they do not need this other package and uninstalls
it. The package manager sees there's nothing that depends on zlib anymore,
and uninstalls zlib as well.

Then the user goes to read their trace.dat file, and suddenly trace-cmd
can't read it!

THAT is what I call fragile. And if something like that ever happened to
me, I would stop using whatever did that to me.

Manually pulling in system dynamic libraries with dlopen is something I
never heard of. The way to do this is make it a build time dependency. If
zlib exists, then define HAVE_ZLIB and allow compressions and everything
else. If it does not, then we don't support compression. Simple as that.

Making it a runtime dependency has a lot of issues, *especially* since one
run of trace-cmd (the reporting) depends on a previous run of trace-cmd
(the recording), and if the environment changes between the two, the user
will rightfully say WTF!

-- Steve
