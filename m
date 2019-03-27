Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEDEC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 00:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8119120811
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 00:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbfC0AYS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 20:24:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54296 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731159AbfC0AYS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 20:24:18 -0400
Received: from patrickm (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 34106335D1A;
        Wed, 27 Mar 2019 00:24:17 +0000 (UTC)
Date:   Tue, 26 Mar 2019 17:24:13 -0700
From:   Patrick McLean <chutzpah@gentoo.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190326172413.10420e9e@patrickm>
In-Reply-To: <20190326095752.2be10ee5@gandalf.local.home>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
        <20190326085821.394b6de0@gandalf.local.home>
        <c65445d3-6a7a-d414-30d1-cf5a19151cb1@gmail.com>
        <20190326095752.2be10ee5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 09:57:52 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 26 Mar 2019 15:35:28 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> > > I really don't want any build artifacts in the executable. This
> > > will mean that you need to do special arrangements to build
> > > kernelshark and then move it to another machine.    
> > 
> > I am confused. I do not know how we can make possible to build 
> > kernelshark on one machine and then move it to another machine and 
> > guarantee that it will work. Note that trace-cmd is not the only 
> > external dependency. We depend on OpenGL, Qt, ....
> > 
> > Qt itself depends on big number of things.
> > 
> > Is this really doable?  
> 
> Yes, I've done it myself several times.
> 
> One only needs the "-dev" packages to build kernelshark. But if you
> want to run it, you just need the normal packages. I have those
> packages installed on several machines. In fact, I  may only want to
> build kernelshark on one box, and then copy it to other boxes that
> don't have the "-dev" packages.
> 
> There's also a case for cross compiling, where Qt, OpenGL and others
> are already installed on those other boxes.
> 
> Package managers will let you know this is done all the time, right
> Patrick? ;-)

This is pretty much how package managers operate, whenever you "apt-get
install" or "dnf install" the package manager is downloading binaries
built on a random server and installing them on your machine. As long
as the appropriate dependencies are installed (which the package
manager takes care of for you), it should just work.

Finding the libraries at runtime is generally taken care of by your
linker, and there is nothing that really needs to be done in your
package. For plugins (and other things that you dlopen()), you need to
come up with a way to figure out where to look. Most packages do this
with defaults defined at build time (packagers and distro security
teams will not like you very much if you hard code looking for dynamic
libraries at relative paths from the CWD), and overrides in
configuration files.
