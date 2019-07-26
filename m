Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1030BC7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 14:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E301D218D3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 14:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387559AbfGZOwG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 10:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbfGZOwG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 10:52:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC082082E;
        Fri, 26 Jul 2019 14:52:04 +0000 (UTC)
Date:   Fri, 26 Jul 2019 10:52:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [ANNOUNCE] KernelShark 1.0
Message-ID: <20190726105203.13c7f0e7@gandalf.local.home>
In-Reply-To: <20190726144938.GA3078@ArchLinux>
References: <20190726095730.0674d81d@gandalf.local.home>
        <20190726144938.GA3078@ArchLinux>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Jul 2019 20:19:38 +0530
Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> Kudos to everyone...time to play with it. :)
> 

Thanks,

Although we're preparing for a ton of bug reports. Nothing is better
testing to flush out bugs than giving it to users.

-- Steve
