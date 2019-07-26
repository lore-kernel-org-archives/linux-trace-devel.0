Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0522C41514
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 13:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA3B020449
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 13:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfGZN5e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbfGZN5d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 09:57:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C40C22D37;
        Fri, 26 Jul 2019 13:57:31 +0000 (UTC)
Date:   Fri, 26 Jul 2019 09:57:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        troyengel@gmail.com, amikhak@wirelessfabric.com,
        valentin.schneider@arm.com, Patrick McLean <chutzpah@gentoo.org>,
        John Kacur <jkacur@redhat.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>, howaboutsynergy@pm.me,
        Bas van Dijk <v.dijk.bas@gmail.com>
Subject: [ANNOUNCE] KernelShark 1.0
Message-ID: <20190726095730.0674d81d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Folks,

It is finally official. We have finished and released KernelShark 1.0.

 http://www.kernelshark.org

It's a completely new rewrite in Qt from the older KernelShark that was
written in GTK. It's faster, it's more extensible, and easier to use.

For how to use KernelShark please read:

  http://www.kernelshark.org/Documentation.html

I would like to thank my team that worked tirelessly on this, and
especially Yordan Karadzhov who did the majority of the work, and even
came up with several algorithms to speed up the handling. I will be
transitioning maintainership off to Yordan. We will currently be
co-maintainers, but eventually we will be splitting KernelShark out of
the trace-cmd.git repo and into its own. At that time, Yordan will be
the main maintainer of the project.

Download it and try it out.

Now we can finally start working on KernelShark 2.0 that's going to be
another huge improvement!

Enjoy!

-- Steve
