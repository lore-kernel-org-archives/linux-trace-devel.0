Return-Path: <SRS0=R/5S=OM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbeLCPW6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Dec 2018 10:22:58 -0500
Date: Mon, 3 Dec 2018 10:22:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: trace libraries install path
Message-ID: <20181203102254.68f7b0e2@vmware.local.home>
In-Reply-To: <CACqStofXszX3wvg4X8YKCoANx_WbEmoJ5v_zV=f=OJd_ZO225A@mail.gmail.com>
References: <CACqStofXszX3wvg4X8YKCoANx_WbEmoJ5v_zV=f=OJd_ZO225A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 3 Dec 2018 14:22:01 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Hi Steven,
> While porting those two patches from linux to trace-cmd tree:
>     [PATCH 3/9] tools/lib/traceevent: Install trace-seq.h API header file
>     [PATCH 2/9] tools/lib/traceevent: Added support for pkg-config
> I noticed a mismatch between linux and trace-cmd in logic installing
> library header files, in main Makefile:
>   linux code installs library headers in  "$(prefix)/include/traceevent"
>   trace-cmd code nstalls library headers in "$(prefix)/include/trace-cmd"
> This is the destination install path of traceevent library header files:
>    event-parse.h, event-utils.h, trace-seq.h, kbuffer.h
> 
> We should make it consistent, what install folder to choose for those files ?

Actually they should just follow the paths in trace-cmd.git. That is,
those in include/traceevent/* go into $(prefix)/include/traceevent and
those in include/trace-cmd/* go into $(prefix)/include/trace-cmd

Make sense?

-- Steve
