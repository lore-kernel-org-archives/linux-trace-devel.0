Return-Path: <SRS0=Mdk7=XS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFD5C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 15:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25FFA207FD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 15:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfIWPM7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 11:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbfIWPM6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 11:12:58 -0400
Received: from oasis.local.home (unknown [65.39.69.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F298120673;
        Mon, 23 Sep 2019 15:12:53 +0000 (UTC)
Date:   Mon, 23 Sep 2019 11:12:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] tools/lib/traceevent: Man page updates and some
 file movement
Message-ID: <20190923111248.5ebdbfd5@oasis.local.home>
In-Reply-To: <20190923145249.GF16544@kernel.org>
References: <20190919212335.400961206@goodmis.org>
        <20190923142839.GD16544@kernel.org>
        <20190923143927.GE16544@kernel.org>
        <20190923145249.GF16544@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 23 Sep 2019 11:52:49 -0300
Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:

> Em Mon, Sep 23, 2019 at 11:39:27AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, Sep 23, 2019 at 11:28:39AM -0300, Arnaldo Carvalho de Melo escreveu:  
> > > Em Thu, Sep 19, 2019 at 05:23:35PM -0400, Steven Rostedt escreveu:  
> > > > Hi Arnaldo,
> > > > 
> > > > This is a series of man page updates to the libtraceevent code, as
> > > > well as a fix to one missing prototype and some movement of the location
> > > > of the plugins (to have the plugins in their own directory).  
> >    
> > > Thanks, applied.  
> > 
> > Its breaking the build on Ubuntu 19.04 cross building to aarch64, I'll
> > see if I can fix it:  
> 
> Makefiles really suck, so I'm removing this one till we get this sorted
> out:
> 
> "Move traceevent plugins in its own subdirectory"
> 
> Ok?

Yeah. Let's not apply this one yet till we figure out what broke. I'll
take a look at it too.

Thanks!

-- Steve
