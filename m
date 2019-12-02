Return-Path: <SRS0=ia4w=ZY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D23BC432C0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1764420718
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfLBWxJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbfLBWxJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 17:53:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DFC52070A;
        Mon,  2 Dec 2019 22:53:08 +0000 (UTC)
Date:   Mon, 2 Dec 2019 17:53:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] libtraceevent: fix lib installation
Message-ID: <20191202175307.40d5a3df@gandalf.local.home>
In-Reply-To: <CADVatmMVcDDys62U31D4zOo4pZ58-YP6O25hAZxNObTTEPpfSg@mail.gmail.com>
References: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
        <CADVatmMVcDDys62U31D4zOo4pZ58-YP6O25hAZxNObTTEPpfSg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2 Dec 2019 12:40:49 +0000
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> Hi Steve,
> 
> On Fri, Nov 15, 2019 at 11:36 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > When we use 'O=' with make to build libtraceevent in a separate folder
> > it fails to install libtraceevent.a and libtraceevent.so.1.1.0 with the
> > error:
> >   INSTALL  /home/sudip/linux/obj-trace/libtraceevent.a
> >   INSTALL  /home/sudip/linux/obj-trace/libtraceevent.so.1.1.0
> > cp: cannot stat 'libtraceevent.a': No such file or directory
> > Makefile:225: recipe for target 'install_lib' failed
> > make: *** [install_lib] Error 1
> >
> > I used the command:
> > make O=../../../obj-trace DESTDIR=~/test prefix==/usr  install
> >
> > It turns out libtraceevent Makefile, even though it builds in a separate
> > folder, searches for libtraceevent.a and libtraceevent.so.1.1.0 in its
> > source folder.
> > So, add the 'OUTPUT' prefix to the source path so that 'make' looks for
> > the files in the correct place.
> >
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > ---
> >  tools/lib/traceevent/Makefile | 1 +  
> 
> A gentle ping.
> I know its the merge window now. But your ack for these two patches will allow
> me to start with the debian workflow.
> 

Thanks for the reminder. Yeah, these look fine, and I just tested them
out.

Arnaldo, can you take these in, and possibly get them into this merge
window?

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
