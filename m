Return-Path: <SRS0=m1iZ=VT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA4BC7618F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jul 2019 19:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E4FB218B0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jul 2019 19:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfGVTEC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 15:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfGVTEC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 15:04:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A21218B0;
        Mon, 22 Jul 2019 19:04:00 +0000 (UTC)
Date:   Mon, 22 Jul 2019 15:03:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Troy Engel <troyengel@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Update home url for trace-cmd and kernelshark
Message-ID: <20190722150359.79e66a77@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Troy,

While looking at the BZ 204259, I followed a link to:

 https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=trace-cmd-git&id=d0913fea414ed795fdcc1c5c86a00fb030ec024d

And noticed that the trace-cmd url is set to this:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

My repo is no longer the home to trace-cmd and kernelshark (although it
works because I mirror the new home for now). But the official home is
now:

 git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git

Can you update your spec files to use that instead?

Thanks!

-- Steve
