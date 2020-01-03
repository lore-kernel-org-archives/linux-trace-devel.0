Return-Path: <SRS0=b4/L=2Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B99C00523
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 23:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D7BC2464E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 23:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgACXTY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 18:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgACXTY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 18:19:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ADF524649;
        Fri,  3 Jan 2020 23:19:23 +0000 (UTC)
Date:   Fri, 3 Jan 2020 18:19:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200103181921.3858c90a@gandalf.local.home>
In-Reply-To: <CADVatmO8mvhtgZ=CNv8uxhVkh2nqg5bjCLzTxyA9UDerRox8Ug@mail.gmail.com>
References: <20200102122004.216c85da@gandalf.local.home>
        <CADVatmO8mvhtgZ=CNv8uxhVkh2nqg5bjCLzTxyA9UDerRox8Ug@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 2 Jan 2020 22:43:34 +0000
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> On Thu, Jan 2, 2020 at 5:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > First, I hope everyone had a Happy New Year!  
> 
> Happy New Year to you too.
> 
> >
> > Next, Sudip has been working to get the libtraceevent library into
> > Debian. As this has been happening, I've been working at how to get all
> > the projects that use this, to use the library installed on the system
> > if it does exist. I'm hoping that once it's in Debian, the other
> > distros will follow suit.  
> 
> I have sent you another patch for libtraceevent. And, assuming that
> you will not have any objection to that patch libtraceevent has been
> merged in Debian and is now available in Debian Sid releases. Thanks
> to Ben for all his suggestion and help.
> 
> The packages are at:
> https://packages.debian.org/unstable/libtraceevent1
> https://packages.debian.org/unstable/libtraceevent-dev
> https://packages.debian.org/unstable/libtraceevent1-plugin
> 
> 

BTW, while doing some minor fixes, I realized I still have generic
names for "warning", "pr_stat" and "vpr_stat" and thought they should
be changed to "tep_warning", "tep_pr_stat" and "tep_vpr_stat" for
namespace reasons even though they are weak functions. Would this
require a major version change, or perhaps its early enough to get this
in with a minor version change as the libraries are probably not being
used yet?

-- Steve
