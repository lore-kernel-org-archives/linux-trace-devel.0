Return-Path: <SRS0=Vqi0=OU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbeLKQwU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Dec 2018 11:52:20 -0500
Date: Tue, 11 Dec 2018 11:52:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/6] tools lib traceevent: Added support for pkg-config
Message-ID: <20181211115218.5e1c1f47@gandalf.local.home>
In-Reply-To: <20181205092134.2214-6-tstoyanov@vmware.com>
References: <20181205092134.2214-1-tstoyanov@vmware.com>
        <20181205092134.2214-6-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 5 Dec 2018 09:21:52 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements integration with pkg-config framework.  pkg-config
> can be used by the library users to determine required CFLAGS and
> LDFLAGS in order to use the library
> 

I applied patches 1-4 in my trace-cmd repo, but I'm not going to apply
this and patch 6. Although trace-cmd may hold a copy of the
libtraceevent source code, I don't want it to install it. The
kernel/tools/lib/traceevent is going to be the official home of the
libtraceevent library, and because of that trace-cmd should not be
installing it as that will lead to conflicts in the future.

I would be OK to have a pkg-config when we start to create a trace-cmd
(libftrace) library. But that's going to be in the future.

Thanks!

-- Steve
