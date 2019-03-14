Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16829C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 13:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3BBB2184E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 13:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfCNNjH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfCNNjH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 09:39:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69162085A;
        Thu, 14 Mar 2019 13:39:06 +0000 (UTC)
Date:   Thu, 14 Mar 2019 09:39:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 19/46] tools/lib/traceevent: Man page for
 tep_list_events()
Message-ID: <20190314093905.63790e18@gandalf.local.home>
In-Reply-To: <CACqStoe=hFZ4_bTa0kh=eqsLs8eZKS=9+Ku0EG-sjP3NoHZ6MA@mail.gmail.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-20-tstoyanov@vmware.com>
        <20190313132933.004e49d2@gandalf.local.home>
        <CACqStoe=hFZ4_bTa0kh=eqsLs8eZKS=9+Ku0EG-sjP3NoHZ6MA@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Mar 2019 13:05:15 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> > We should probably include tep_list_events_copy() in this man page.
> > Where one is not to be freed, and the other is.  
> 
> I'll update the man page once we introduce tep_list_events_copy() to
> tools/lib/traceevent, currently this new API is part of trace-cmd only.

Ah, I guess I should go and sort out all the patches that need to go
upstream too ;-)

I'll start by diffing the two trees and then searching for the patches
that make the updates.

-- Steve
