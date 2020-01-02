Return-Path: <SRS0=z2Pp=2X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC70C3276C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 23:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D5F21835
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 23:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgABXqk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 18:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgABXqk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 18:46:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 719322085B;
        Thu,  2 Jan 2020 23:46:38 +0000 (UTC)
Date:   Thu, 2 Jan 2020 18:46:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200102184636.08375a14@gandalf.local.home>
In-Reply-To: <20200102184252.GA8047@kernel.org>
References: <20200102122004.216c85da@gandalf.local.home>
        <20200102184252.GA8047@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


[ Added the BPF folks ]

On Thu, 2 Jan 2020 15:42:52 -0300
Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:

> Em Thu, Jan 02, 2020 at 12:20:04PM -0500, Steven Rostedt escreveu:
> > This is a problem with living in the Linux source tree as tags and
> > branches in Linus's tree are for only the Linux kernel source itself.
> > This may work fine for perf, as it's not a library and there's not  
> 

> 
> libperf adopted the versioning and packaging practices introduced by
> tools/lib/bpf, perhaps you could do the same for tools/lib/traceevent
> and then we would have a standard for these cases?

I don't see libperf in my Debian testing installation, but I did find
libbpf.

> 
> The problem of having libperf, libbpf in distros is already being
> tackled for quite a while, would be interesting to follow what has
> happened in that area as well, Jiri knows more about this, Jiri?

Looking at the libbpf Makefile, it is getting the version from the
libbpf.map file.

What's the standard way for distributions to know when to use the
number? Only from Linux stable trees? That way, we can make fixes to the
library, but still need to remember to update the version number before
the release.

How does libbpf handle the version numbers with bug fixes? Does it get
updated one a kernel release if there are changes?

Obviously, we need to update the major number if the API changes in
anyway that is not compatible for a new application, which includes
adding new functions. Right?

-- Steve
