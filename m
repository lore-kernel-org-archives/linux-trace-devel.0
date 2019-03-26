Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C77C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B24E2075C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfCZT5o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731755AbfCZT5o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 15:57:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575762075C;
        Tue, 26 Mar 2019 19:57:43 +0000 (UTC)
Date:   Tue, 26 Mar 2019 15:57:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] tools/lib/traceevent: rename input arguments of
 libtraceevent APIs from pevent to tep
Message-ID: <20190326155741.11a72d13@gandalf.local.home>
In-Reply-To: <20190326154328.28718-5-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
        <20190326154328.28718-5-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 17:43:24 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch renames "struct tep_handle *pevent" input arguments of libtraceevent
> APIs to "struct tep_handle *tep". This makes the API consistent with the chosen
> naming convention: tep (trace event parser), instead of the old pevent.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>

I have no problems with this patch, but as I didn't apply some of the
earlier patches, this one doesn't apply, so you will need to send it
again in the next series.

-- Steve
