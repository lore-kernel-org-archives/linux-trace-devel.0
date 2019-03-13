Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D281DC10F03
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1E7213A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfCMTGI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfCMTGE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:06:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B632075C;
        Wed, 13 Mar 2019 19:06:03 +0000 (UTC)
Date:   Wed, 13 Mar 2019 15:06:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Patrick McLean <chutzpah@gentoo.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190313150602.0bed3d1f@gandalf.local.home>
In-Reply-To: <20190313114235.7fc6ce3b@patrickm>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
        <20190313114235.7fc6ce3b@patrickm>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 11:42:35 -0700
Patrick McLean <chutzpah@gentoo.org> wrote:

> (especially when trace-cmd and trace-cmd are
> separate packages)

That should be a fun stunt. ;-)

But yeah, we are looking into separating KernelShark out of trace-cmd
in the future, but depending on libftrace.so (the guts of trace-cmd)
when that is ready. First we need to finish libtraceevent.so, which
will live in the Linux kernel git repo under tools/lib/traceeevent.
Would that be an issue in packaging libtraceevent?

-- Steve
