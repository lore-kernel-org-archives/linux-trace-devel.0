Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4DAC43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 13:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA4F2082F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 13:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390822AbgDCNZ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 09:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgDCNZ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 09:25:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D917B2078C;
        Fri,  3 Apr 2020 13:25:56 +0000 (UTC)
Date:   Fri, 3 Apr 2020 09:25:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open
 guest tracing file
Message-ID: <20200403092555.7a787af5@gandalf.local.home>
In-Reply-To: <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
References: <20200401164509.191494-1-tz.stoyanov@gmail.com>
        <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com>
        <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 3 Apr 2020 15:26:49 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> >
> > Also do we consider a case when we will need to load more than one
> > "primary" stream?  
> 
> In the host - guest tracing, there is no use case with more than one
> primary stream,
> but may be there could be other use cases where more than one primary
> stream will
> be needed ?
> 
> Is it possible to append more than one secondary files, using the
> current KernelShark 2 ?
> I tried appending two files, specifying "-a" option twice, but only
> the first "-a" file was appended.

We should start thinking about nested VMs. What happens if we have a host,
a guest-host and a guest? That is, the guest is a VM on top of the
guest-host, which is a VM on top of the host.

And there could be a guest on top of that guest as well!

-- Steve
