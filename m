Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F40C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C3372147C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfDCNZU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfDCNZU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 09:25:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C3E2084C;
        Wed,  3 Apr 2019 13:25:19 +0000 (UTC)
Date:   Wed, 3 Apr 2019 09:25:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v9 11/11] trace-cmd: Add splice() recording from
 FIFO without additional pipe buffer
Message-ID: <20190403092517.1c999a83@gandalf.local.home>
In-Reply-To: <fe5cbfd1d91e83636d6b32c2522411aed471958d.camel@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
        <20190402134540.32321-12-kaslevs@vmware.com>
        <20190403085515.1652201a@gandalf.local.home>
        <fe5cbfd1d91e83636d6b32c2522411aed471958d.camel@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 3 Apr 2019 13:11:07 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> > 
> > Why the polling code, and not just block on splice?  
> 
> To work around older kernels that don't have the splice(2)
> O_NONBLOCKING fix[1] for pipes.
> 
> An alternative would be to configure SIGINT not to auto restart
> syscalls (which is the default afaik). Then splice(2) will return
> EAGAIN and will can restart it with SPLICE_F_NONBLOCK flag on.

There needs to be a comment explaining its existence then, and perhaps
we can do a check at the beginning (someplace else) to see if the fix is
in, and then skip this part if it is.

-- Steve
