Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83158C4360C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64678222C2
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388726AbfJDNdM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388673AbfJDNdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 09:33:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFAB621D81;
        Fri,  4 Oct 2019 13:33:10 +0000 (UTC)
Date:   Fri, 4 Oct 2019 09:33:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Patrick McLean <patrick.mclean@sony.com>,
        John Kacur <jkacur@redhat.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tony Jones <tonyj@suse.de>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Nivedita Swaminathan <nivedita.swaminathan@intel.com>
Subject: Re: Getting libtraceevent into a packaged library
Message-ID: <20191004093309.24b91048@gandalf.local.home>
In-Reply-To: <CAM9d7ciT2NtY9_m_scxom-POvKJR_LV-JaCxC+B78dc=DezuzQ@mail.gmail.com>
References: <20191003150104.74216a0a@gandalf.local.home>
        <CAM9d7ciT2NtY9_m_scxom-POvKJR_LV-JaCxC+B78dc=DezuzQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 4 Oct 2019 11:51:12 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> On Fri, Oct 4, 2019 at 4:01 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > What's the next step to get this into a package so that perf,
> > trace-cmd, power-top, rasdaemon, uftrace, and whatever does not need to
> > have its own copy of the code, but instead link to it.
> >
> > Note, the interface has changed since other tools copied it, and I'm
> > willing to help anyone out in porting to the package.  
> 
> For uftrace, I think it needs to keep the copy of the code for a while
> since it should support older versions of distros as well.
> I'll add a runtime dependency check for libtraceevent and use
> the new APIs if exists.
> 

What do you mean by support older distros? You mean older distros
not having the library (a user could always just download the source
code and compile it themselves :-) Or handling the trace events,
because libtraceevent should be able to handle older kernels.

-- Steve
