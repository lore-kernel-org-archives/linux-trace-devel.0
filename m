Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05931C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 20:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A1420731
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 20:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ra6NkQtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgAFUrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 15:47:18 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43303 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgAFUrS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 15:47:18 -0500
Received: by mail-qk1-f196.google.com with SMTP id t129so40706672qke.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 12:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DHIwKB1SdWvG9S5/QAvd4TjIognysn5YuV1n6f7gju4=;
        b=Ra6NkQtFY7ijfnuXcAGbxOh84AXs0GWCp722hpltolpulCuDmOLw8xBTEKXWQtdU+h
         2OGkYYMcxBKG2t7aYoNXT7nLc6Ti0my91ZM3b+texHVG5h/wSGkOic3KAWj47Ry08SHn
         R7Dp/dPAv3KbpsRpBkV/2WwjI1BrSDy/eZugBIFEG/6s5dE5gmiqNAkkExzhPnpE3IJI
         jnoj1PE/njE4mZgeMqGQJfCILswzX/1AI4LO9cAS3dpvOPX5nTS6mGoC4lRRGTzVL6nY
         dRkDX701YnWJcV1QYJYEP2mjxIraSqA6JbePQEroGvKRZGaXUwws0WuQSZZRD2tXVRit
         dadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DHIwKB1SdWvG9S5/QAvd4TjIognysn5YuV1n6f7gju4=;
        b=lKG+TDyuPmjgsn63Xvp/emIAIDbOUbji96kG5XMBg9uPTWjx53INLd9v+Y89EqNgUk
         iJXsPF8D/JJqnAQvKMX/ig9fBC/VwXD4bcxc6sWFy7946QfB/fbI3RtSRQ2197kiQXcL
         VFnNquYf3r9ZSCyWROJ+GNNDmi5CKUvWaSd3H686tAt37qZJiAqsUfALyIrAtxs+Y3+f
         D1OM4s9E660ANLxqZqz99aCPnF0Pb7vL5Mkg01WGOvYafHBEH+4FKrsWto1I3uvvYVcJ
         CQgL65veJZCw+wJ/YMSim0kFZoOETDby+ow0HVzuCzJG2E5ZQMRcwPdXsHrMvbFX00cl
         AAoA==
X-Gm-Message-State: APjAAAWfspBammtuDLIrl9HWFyjPu8ZW9oMwIbAZ0tcqce/WFq2DL+c4
        /Ea8HHDQQsDr9JXNn5vSXqfgGA==
X-Google-Smtp-Source: APXvYqzEgsE5n2gRG76eAGoeg63WHVa5P6c8cDUeUTV19BhlgMQXoclCr81eaop/b4Jhnynt+RpN3A==
X-Received: by 2002:a05:620a:143a:: with SMTP id k26mr85511562qkj.450.1578343636899;
        Mon, 06 Jan 2020 12:47:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d184sm13598598qkb.128.2020.01.06.12.47.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Jan 2020 12:47:16 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ioZHP-0007G2-J2; Mon, 06 Jan 2020 16:47:15 -0400
Date:   Mon, 6 Jan 2020 16:47:15 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        users@linux.kernel.org
Subject: Re: [kernel.org users] [RFC] tools lib traceevent: How to do library
 versioning being in the Linux kernel source?
Message-ID: <20200106204715.GA22353@ziepe.ca>
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
 <20200106162623.GA11285@kernel.org>
 <20200106113615.4545e3c5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106113615.4545e3c5@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 06, 2020 at 11:36:15AM -0500, Steven Rostedt wrote:
> On Mon, 6 Jan 2020 13:26:23 -0300
> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> 
> > So, we have:
> > 
> > https://www.kernel.org/pub/linux/kernel/tools/perf/
> > 
> > trying to mimic the kernel sources tree structure, so perhaps we could
> > have:
> > 
> > https://www.kernel.org/pub/linux/kernel/tools/lib/{perf,traceevent}/
> > 
> > To continue that directory tree mirror?
> 
> Wouldn't that become a bit of manual work. Unlike perf, the versions
> will not correspond to the Linux kernel versions. They would need to
> follow library versioning.
> 
> It would at a minimum require new scripting to get this right.

If it is not tightly linked to the kernel and is just a normal
library, you might consider using github. This is what we do for the
rdma user space and it works well. We still take patches from the
mailing list flow, but do use a fair amount of the github stuff too:

https://github.com/linux-rdma/rdma-core

With github actions now able to provide a quite good CI it covers a
lot of required stuff for a library in one place, in a way that
doesn't silo all the build infrastucture.

If you are interested in how we set it up I can write a longer email.

Regards,
Jason
