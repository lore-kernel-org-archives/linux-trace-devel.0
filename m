Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F45C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 19:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE3420661
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 19:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfBVTd6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfBVTd6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 14:33:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276AC2070B;
        Fri, 22 Feb 2019 19:33:57 +0000 (UTC)
Date:   Fri, 22 Feb 2019 14:33:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge()
Message-ID: <20190222143355.2370f919@gandalf.local.home>
In-Reply-To: <20190221161530.GA16009@box>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
        <20190221124205.21115-4-ykaradzhov@vmware.com>
        <20190221161530.GA16009@box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Feb 2019 18:15:32 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Patches 1, 2 and 3 look good to me.
> 
> Acked-by: Slavomir Kaslev <kaslevs@vmware.com>

Slavomir, is it OK that I put "Reviewed-by" instead of "Acked-by". A
reviewed-by caries a bit more weight and states that you did a review.
An ack is more of "yeah, I looked it over and I'm OK with the idea",
but doesn't actually mean you reviewed it.

-- Steve
