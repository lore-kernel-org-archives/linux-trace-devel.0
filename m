Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752292AbdLMPvM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 10:51:12 -0500
Date: Wed, 13 Dec 2017 10:51:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH v3 9/9] trace-cmd: Move GUI files in kernel-shark/
Message-ID: <20171213105110.21039649@gandalf.local.home>
In-Reply-To: <1513173046.2565.59.camel@gmail.com>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
        <20171212162534.31144-10-vladislav.valtchev@gmail.com>
        <20171212192911.0cd6aa14@gandalf.local.home>
        <1513173046.2565.59.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 13 Dec 2017 15:50:46 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:

> I meant "keeping this might be a problem".
> What I had in mind was that in the best case, with the hack in case
> the parent Makefile changes (adding config_includes and config flags),
> we'll link useless libraries. In the worst case, different versions of the same
> library might be used and that will cause and kind of strange build failures.
> 
> But, I think keeping the hack in that patch makes sense, since the concept of
> config_includes and config_flags is fading away in the parent Makefile.
> In the next patches of the series also the trace-cmd application will have a separate
> directory and Makefile, so I could remove those variables from the parent Makefile.
> It seems fine to me to assume that only the Makefiles of the specific applications can
> really add config_flags (system libraries). The top-level Makefile should only orchestrate
> the others.
> 
> 
> Makes sense?

Sure.

-- Steve
