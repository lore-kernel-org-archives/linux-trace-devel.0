Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99659C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 13:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B612177E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 13:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfCMNwE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 09:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfCMNwB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 09:52:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 884CB2177E;
        Wed, 13 Mar 2019 13:52:00 +0000 (UTC)
Date:   Wed, 13 Mar 2019 09:51:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] kernel-shark: Fix a bug in ksmodel_zoom
Message-ID: <20190313095159.6b2609b2@gandalf.local.home>
In-Reply-To: <20190307154316.19194-3-ykaradzhov@vmware.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
        <20190307154316.19194-3-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Mar 2019 17:43:14 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> When zooming-in the model is supposed to avoid over-zooming by
> recalculation the Scale factor. The new value of the Scale factor is
> supposed to be such that the size of the bin cannot be smaller than 5
> ns. This patch fixes a naive bug in the way the new scale value is
> calculated.

BTW, what if the resolution of time stamps isn't in ns, and we can have
more than one event in a 5 unit bin. Does that mean we never display
multiple events in that small of a time scale?

-- Steve
