Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8651C31E48
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC98821019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbfFLOsS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732557AbfFLOsS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:48:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F103208CA;
        Wed, 12 Jun 2019 14:48:17 +0000 (UTC)
Date:   Wed, 12 Jun 2019 10:48:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>
Subject: Re: [PATCH 1/2] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge() part II
Message-ID: <20190612104815.57ccfb54@gandalf.local.home>
In-Reply-To: <8451f71f-1078-9d64-5abf-3ed6f36403e1@vmware.com>
References: <20190612142053.14439-1-ykaradzhov@vmware.com>
        <20190612102831.15fca926@gandalf.local.home>
        <8451f71f-1078-9d64-5abf-3ed6f36403e1@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Jun 2019 14:34:52 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Hi Steven,
> 
> My idea was to make clear that those two patches are strongly connected 
> to the patch another patch called:
> kernel-shark: Fix a bug in ksmodel_set_next_bin_edge()

It's best to note the connection in the git change log, and also use a
Fixes: tag.

> 
> which was send long time ago.
> 
> Should I resend with another subject?

Yes please.

Thanks!

-- Steve


