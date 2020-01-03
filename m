Return-Path: <SRS0=b4/L=2Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34532C2D0C2
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 12:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0529522522
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 12:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578053870;
	bh=RBTBqEBkgPVhoqWth2ahRIQwo5zhyOmpdw0lsjZXfbo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=e8rEhQHRfIYaXUwY9yH8o2S9v7cD0lhFg0OYRsch9jH9/vLvv62gzxdPrQHCfm1Yd
	 7gzTemXSGSWWbDUeYG0YMB1evxkltv5VTC4hi4oz0yxS2BWIQS7mKW4Qxo6V7YXaFD
	 fb3lQKhegExyJ1JMXUBcMGQ499mGo9Sq6Vg3b6qU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgACMRt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 07:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbgACMRt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 07:17:49 -0500
Received: from devnote2 (p3234244-ipngn201014osakachuo.osaka.ocn.ne.jp [220.106.126.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D774A21D7D;
        Fri,  3 Jan 2020 12:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578053868;
        bh=RBTBqEBkgPVhoqWth2ahRIQwo5zhyOmpdw0lsjZXfbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bUkMvMx1AJaqo2auUZut1R6Pf2vwNLTu+Xo6VzCYBhWY3ONfWhVkeRS4H/AqzWbGr
         oOniTKsZ3EjvAUOYbzL3ygAm7aahSWk0ANECUDRy4QxPtvJr3nQG4uLQXVUj/CoEDE
         PYjPgGLnzazP/b67mZtCotM/nQLOpYu95b66SR/k=
Date:   Fri, 3 Jan 2020 21:17:43 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-Id: <20200103211743.b474f74d0a039624d37989bc@kernel.org>
In-Reply-To: <20200102122004.216c85da@gandalf.local.home>
References: <20200102122004.216c85da@gandalf.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 2 Jan 2020 12:20:04 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> First, I hope everyone had a Happy New Year!

Hope you to have a Happy New Year too!

> 
> Next, Sudip has been working to get the libtraceevent library into
> Debian. As this has been happening, I've been working at how to get all
> the projects that use this, to use the library installed on the system
> if it does exist. I'm hoping that once it's in Debian, the other
> distros will follow suit.
> 
> Currently, the home of libtraceevent lives in the Linux kernel source
> tree under tools/lib/traceevent. This was because perf uses it to parse
> the events, and it seemed logical (at the time) to use this location as
> the main source tree for the distributions.
> 
> The problem I'm now having is that I'm looking at fixing and updating
> some of the code in this library, and since library versioning is
> critical for applications that depend on it, we need to have a way to
> update the versions, and this does not correspond with the Linux
> versions.
> 
> For example, we currently have:
> 
>  libtraceevent.so.1.1.0
> 
> If I make some bug fixes, I probably want to change it to:
> 
>  libtraceevent.so.1.1.1 or libtraceevent.so.1.2.0
> 
> But if I change the API, which I plan on doing soon, I would probably
> need to update the major version.
> 
>  libtraceevent.so.2.0.0
> 
> The thing is, we shouldn't be making these changes for every update
> that we send to the main kernel. I would like to have a minimum of tags
> to state what the version should be, and perhaps even branches for
> working on a development version.
> 
> This is a problem with living in the Linux source tree as tags and
> branches in Linus's tree are for only the Linux kernel source itself.
> This may work fine for perf, as it's not a library and there's not
> tools depending on the version of it. But it is a problem when it comes
> to shared libraries.
> 
> Should we move libtraceevent into a stand alone git repo (on
> kernel.org), that can have tags and branches specifically for it? We
> can keep a copy in the Linux source tree for perf to use till it
> becomes something that is reliably in all distributions. It's not like
> perf doesn't depend on other libraries today anyway.

+1. It sounds reasonable to move the main part of libtraceevent out
of kernel tree. BTW, the plugins seems depending on the kernel. Maybe
we can provide it under
/lib/modules/<kversion>/shared/libtraceevent/plugins/ ? :)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
