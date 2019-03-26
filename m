Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9A0C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD8A2084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfCZN5y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZN5y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:57:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BA820823;
        Tue, 26 Mar 2019 13:57:53 +0000 (UTC)
Date:   Tue, 26 Mar 2019 09:57:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190326095752.2be10ee5@gandalf.local.home>
In-Reply-To: <c65445d3-6a7a-d414-30d1-cf5a19151cb1@gmail.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
        <20190326085821.394b6de0@gandalf.local.home>
        <c65445d3-6a7a-d414-30d1-cf5a19151cb1@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 15:35:28 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > I really don't want any build artifacts in the executable. This will
> > mean that you need to do special arrangements to build kernelshark and
> > then move it to another machine.  
> 
> I am confused. I do not know how we can make possible to build 
> kernelshark on one machine and then move it to another machine and 
> guarantee that it will work. Note that trace-cmd is not the only 
> external dependency. We depend on OpenGL, Qt, ....
> 
> Qt itself depends on big number of things.
> 
> Is this really doable?

Yes, I've done it myself several times.

One only needs the "-dev" packages to build kernelshark. But if you
want to run it, you just need the normal packages. I have those
packages installed on several machines. In fact, I  may only want to
build kernelshark on one box, and then copy it to other boxes that
don't have the "-dev" packages.

There's also a case for cross compiling, where Qt, OpenGL and others
are already installed on those other boxes.

Package managers will let you know this is done all the time, right
Patrick? ;-)

-- Steve
