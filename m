Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E346C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E69C5207FF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uadlo5Nc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgAFPTP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 10:19:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbgAFPTP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578323953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J4/neyt/TXLzE3Hq8GePlg8NTgoOn+vvh8Hclptg4Lo=;
        b=Uadlo5Nce/DNTCLzlSoRE0CNAsz7zDrkcUtBhqF64zyFDi9qnsBbgvoE12WcCqw0V7aRnL
        VKQUgLcRVvXk1BdIG8kNHcVswwW8KV/gFZKX6E+7d61JTR2RLtgGKU2XUrujN9scCG0qBt
        6bTvbSy1woHFERot7zWKd230Y1peNOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-EV3NgjLrMbuzgQz_Sv9EWg-1; Mon, 06 Jan 2020 10:19:09 -0500
X-MC-Unique: EV3NgjLrMbuzgQz_Sv9EWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 604D81800D4E;
        Mon,  6 Jan 2020 15:19:06 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 311E27EE6C;
        Mon,  6 Jan 2020 15:19:03 +0000 (UTC)
Date:   Mon, 6 Jan 2020 16:19:02 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        users@linux.kernel.org
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200106151902.GB236146@krava>
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103181614.7aa37f6d@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jan 03, 2020 at 06:16:14PM -0500, Steven Rostedt wrote:
> 
> [ Added Konstantin and kernel.org users mailing list ]
> 
> On Fri, 3 Jan 2020 14:36:40 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Thu, Jan 02, 2020 at 06:58:53PM -0500, Steven Rostedt wrote:
> > > On Fri, 3 Jan 2020 00:49:50 +0100
> > > Jiri Olsa <jolsa@redhat.com> wrote:
> > >   
> > > > > Should we move libtraceevent into a stand alone git repo (on
> > > > > kernel.org), that can have tags and branches specifically for it? We
> > > > > can keep a copy in the Linux source tree for perf to use till it    
> > > > 
> > > > so libbpf 'moved' for this reason to github repo,
> > > > but keeping the kernel as the true/first source,
> > > > and updating github repo when release is ready
> > > > 
> > > > libbpf github repo is then source for fedora (and others)
> > > > package  
> > > 
> > > Ah, so perhaps I should follow this? I could keep it a kernel.org repo
> > > (as I rather have it there anyway).  
> > 
> > sounds good, and if it works out, we'll follow you with libperf :-)
> > 
> > if you want to check on the libbpf:
> >   https://github.com/libbpf/libbpf
> > 
> > there might be some syncs scripts worth checking
> 
> I wonder if there should be a:
> 
>   git://git.kernel.org/pub/scm/utils/lib/
> 
> directory to have:
> 
>   git://git.kernel.org/pub/scm/utils/lib/traceevent/
>   git://git.kernel.org/pub/scm/utils/lib/libbpf/
>   git://git.kernel.org/pub/scm/utils/lib/libperf/

we could loose the 'lib' and just have:

    git://git.kernel.org/pub/scm/utils/lib/perf/

> 
> That could hold the libraries that are tight to the kernel?

I don't think libbpf will change now after they are settled in github,
but we could consider this for libperf

jirka

