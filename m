Return-Path: <SRS0=z2Pp=2X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E133C3276C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 23:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F06921835
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 23:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgABX64 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 18:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgABX64 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 18:58:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED1F20863;
        Thu,  2 Jan 2020 23:58:55 +0000 (UTC)
Date:   Thu, 2 Jan 2020 18:58:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200102185853.0ed433e4@gandalf.local.home>
In-Reply-To: <20200102234950.GA14768@krava>
References: <20200102122004.216c85da@gandalf.local.home>
        <20200102234950.GA14768@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 3 Jan 2020 00:49:50 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> > Should we move libtraceevent into a stand alone git repo (on
> > kernel.org), that can have tags and branches specifically for it? We
> > can keep a copy in the Linux source tree for perf to use till it  
> 
> so libbpf 'moved' for this reason to github repo,
> but keeping the kernel as the true/first source,
> and updating github repo when release is ready
> 
> libbpf github repo is then source for fedora (and others)
> package

Ah, so perhaps I should follow this? I could keep it a kernel.org repo
(as I rather have it there anyway).

We can have the tools/lib/traceevent be the main source, but then just
copy it to the stand alone for releases.

Sudip, would this work for you too? (and yes, I plan on acking that
patch for the -ldl change, after looking at it a little bit more).

-- Steve
