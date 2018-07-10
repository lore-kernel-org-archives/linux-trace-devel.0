Return-Path: <SRS0=W9vN=J2=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754260AbeGJPdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Jul 2018 11:33:10 -0400
Date: Tue, 10 Jul 2018 11:33:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark-qt: Make helper functions recognize data
 type to improve performance
Message-ID: <20180710113308.1a4d3eaa@gandalf.local.home>
In-Reply-To: <57671316-1391-763c-0a9e-1345d8f0deb8@gmail.com>
References: <20180709123823.695b653a@gandalf.local.home>
        <57671316-1391-763c-0a9e-1345d8f0deb8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 10 Jul 2018 18:23:49 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > +	n_cpus = tracecmd_cpus(kshark_ctx->handle);
> > +
> >   	rows = calloc(total, sizeof(struct kshark_entry *));
> >   	if(!rows)  
> 
> I know it isn't from this patch, but there must be a space after the "if".

Yeah, there's a few places that have that. I'll fix these with a
separate patch.

> 
> Please push this a.s.a.p

Will do. Thanks!

-- Steve
