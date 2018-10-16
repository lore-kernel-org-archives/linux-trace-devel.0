Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbeJPVk4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 17:40:56 -0400
Date: Tue, 16 Oct 2018 09:50:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent: Implement libtraceevent man pages
Message-ID: <20181016095020.5c352745@gandalf.local.home>
In-Reply-To: <20181016130233.26852-1-tstoyanov@vmware.com>
References: <20181016130233.26852-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 13:02:47 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch adds initial support for libtraceevent man pages -
> Documentation directory, templates, configurations, Makefiles.
> The first man page is also part of the patch - summary of the
> library and all its APIs. Building of the documentation is
> integrated into the libtraceevent build process, new targets are
> added to its Makefile:
> make doc
> make doc-clean
> make doc-install
> make doc-uninstall
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Thanks Tzvetomir,

I'll try to get a chance to review this tomorrow, but if you don't hear
from me by Thursday, please send me a ping.

-- Steve
