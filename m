Return-Path: <SRS0=27yZ=PX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85C3C43387
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 14:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8CF120866
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 14:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbfAOOoy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfAOOoy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 09:44:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E0720657;
        Tue, 15 Jan 2019 14:44:53 +0000 (UTC)
Date:   Tue, 15 Jan 2019 09:44:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: trace-cmd python
Message-ID: <20190115094451.119784d5@gandalf.local.home>
In-Reply-To: <b8e933bd8fc5f6a1aac94beced2ee75b8729975b.camel@sipsolutions.net>
References: <1524143246.3024.21.camel@sipsolutions.net>
        <20190103224300.418e002b@vmware.local.home>
        <20190109153650.0261951b@gandalf.local.home>
        <b8e933bd8fc5f6a1aac94beced2ee75b8729975b.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Jan 2019 14:09:30 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:


> Seems to work more or less.
> 
> Not sure how I managed to install it into a custom subdirectory of my
> $HOME before, and make it load plugins - I can't seem to figure out the
> right combination of prefix= and DESTDIR= anymore.

DESTDIR is where you want to install it for moving it to another
machine. If you plan on running trace-cmd on the same machine, but
having it look elsewhere, then just using prefix should be enough.

> 
> If I symlink it to a place where trace-cmd actually looks for it then I
> get errors in python saying pevent_record_data_get() is not defined, but

Looks to be an old object that it's linking with, as we replaced all
"pevent_" with "tep_".

> could be that I'm not importing something right ...
> 
> What's a good way to install it into a custom directory without
> affecting the whole machine?

The prefix tells the build to have the executables search that path.
The DESTDIR is for installing in a particular location that you will
move that code to another machine.

e.g.

  make prefix=/usr/local DESTDIR=/tmp/tracecmd install

Will install the executables in /tmp/tracecmd, but when you run those
executables, they will want to look in the /usr/local path.

It should also always search your home directory in ".trace-cmd/plugins"

-- Steve
