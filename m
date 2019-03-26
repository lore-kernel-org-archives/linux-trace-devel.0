Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED844C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F7D20823
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfCZPIP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfCZPIP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:08:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9262070D;
        Tue, 26 Mar 2019 15:08:14 +0000 (UTC)
Date:   Tue, 26 Mar 2019 11:08:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190326110812.66d95306@gandalf.local.home>
In-Reply-To: <20190326085821.394b6de0@gandalf.local.home>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
        <20190326085821.394b6de0@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 08:58:21 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I'm still confused. We shouldn't be looking for any paths at build time.
> This should be done at run time.
> 
> Now, we can check the local directory that kernelshark lives in. That
> is, if we are running from a fresh build, at start up, we can look at
> 
>  `pwd`/../lib | `pwd`/../../plugins
> 
> and see if those directories exist at run time. And if they do, we can
> use them (as we would assume that the exec is running from a local
> source tree).
> 
> I really don't want any build artifacts in the executable. This will
> mean that you need to do special arrangements to build kernelshark and
> then move it to another machine.

Note, I was confused as I was thinking this was about plugins and not
about the dynamic runtime / static libraries.

I see that this is about where to find those libraries. This is about
where to find libtracecmd (soon to be libftrace). Currently that's a
static library, and we want it to be a dynamic one in the future.

OK, I'm fine with this patch as is and will pull it in.


-- Steve
