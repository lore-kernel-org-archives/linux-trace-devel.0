Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FEDC10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 214E420868
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfDPVjM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 17:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfDPVjL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 17:39:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06572075B;
        Tue, 16 Apr 2019 21:39:10 +0000 (UTC)
Date:   Tue, 16 Apr 2019 17:39:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v3 0/2] Optimize pid filters and add --no-filter option
Message-ID: <20190416173909.7b1ff01f@gandalf.local.home>
In-Reply-To: <20190416132253.GA17860@pauld.bos.csb>
References: <20190415230016.13932-1-kaslevs@vmware.com>
        <20190416132253.GA17860@pauld.bos.csb>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Apr 2019 09:22:54 -0400
Phil Auld <pauld@redhat.com> wrote:

> This version is also working for my use case.  The logic in the filter
> does show the recording thread pids in the sched switch event, at least 
> when switching to/from a non-excluded process.  But I think that's 
> desired.
> 
> The --no-filter option works as expected.
> 
> 
> Acked-by: Phil Auld <pauld@redhat.com>
> 

Could we get a Tested-by: from you for this series?

Thanks!

-- Steve
