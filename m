Return-Path: <SRS0=xFsM=X4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B49C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFFFA215EA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfJCTBH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbfJCTBH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:01:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2697207FF;
        Thu,  3 Oct 2019 19:01:05 +0000 (UTC)
Date:   Thu, 3 Oct 2019 15:01:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Patrick McLean <patrick.mclean@sony.com>,
        John Kacur <jkacur@redhat.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tony Jones <tonyj@suse.de>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Nivedita Swaminathan <nivedita.swaminathan@intel.com>
Subject: Getting libtraceevent into a packaged library
Message-ID: <20191003150104.74216a0a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello folks,

I've Cc'd everyone that might be interested in helping package
libtraceveent. It is basically ready to become a full library package.
I only have a couple of patches to deal with SPDX headers and such, but
other than that, I think we are good to go.

My question is now, how to we go about having distributions package it.
Like perf, the main source code lives in the Linux kernel source tree
under:

 tools/lib/traceevent

I'd like to install the following headers in /usr/include

  event-parse.h
  kbuffer.h
  trace-seq.h

And the following libraries:

  libtraceevent.so (with all its versions)

Documentation man pages are in the Documentation directory.

And we should have plugins installed as well.

If we had done everything correctly, a "make install" in that directory
will move all the files to their proper location.

make doc will create the man pages.

make doc-install will install the man pages.

What's the next step to get this into a package so that perf,
trace-cmd, power-top, rasdaemon, uftrace, and whatever does not need to
have its own copy of the code, but instead link to it.

Note, the interface has changed since other tools copied it, and I'm
willing to help anyone out in porting to the package.

Let me know of anyone else that can help in getting this packaged for a
Linux distribution.

-- Steve
