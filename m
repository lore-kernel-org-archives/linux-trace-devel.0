Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE343C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 14:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979882186A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 14:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfCTOfg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfCTOfg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 10:35:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3733E2184D;
        Wed, 20 Mar 2019 14:35:35 +0000 (UTC)
Date:   Wed, 20 Mar 2019 10:35:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Message-ID: <20190320103513.40d67e38@gandalf.local.home>
In-Reply-To: <CACqStodWOOPAi0Y36Xp5u=Ny0e+acmys=HUV4qxLB+3sqeAPBw@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
        <20190319155536.19381-6-tstoyanov@vmware.com>
        <0FEA60D5-2542-498E-A494-C15B0B2AE0A4@vmware.com>
        <CACqStodWOOPAi0Y36Xp5u=Ny0e+acmys=HUV4qxLB+3sqeAPBw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 20 Mar 2019 14:14:03 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> > But this rmdir is not moved to tracecmd_remove_instance() — it’s lost. This looks like it’s introducing a bug.  
> 
> Thanks Matt, this one is from v1 of the patchset, I didn't notice it.
> I'll add the rmdir() call in the next version.
> There is some general problem with deleting instances, or (most
> probably) I cannot figure out what it the proper way
> to delete a ftrace instance - even after the call to rmdir() in
> tracecmd_remove_instance(), the instance dir is still there.
> I tried to run "rm -rf path_to_instance_dir" from the shell (at root),
> after the trace-cmd is executed, got a lot of
> "Operation not permitted" errors and the instance dir is not deleted.

Make sure you reset the instance before trying to remove it. There's
some operations that can be started that wont let you remove the
instance until they are cleaned up.

But if you are still having issues with that, let me know. It could be
a bug in the instance removal code in the kernel.

-- Steve
