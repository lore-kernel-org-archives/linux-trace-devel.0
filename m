Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D982C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B78E213A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfCMR3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfCMR3f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 13:29:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E8DD2070D;
        Wed, 13 Mar 2019 17:29:34 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:29:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 19/46] tools/lib/traceevent: Man page for
 tep_list_events()
Message-ID: <20190313132933.004e49d2@gandalf.local.home>
In-Reply-To: <20190308133654.21264-20-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-20-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:27 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man page for tep_list_events() as part of the libtraceevent APIs.
> 

We should probably include tep_list_events_copy() in this man page.
Where one is not to be freed, and the other is.

-- Steve

> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-event_list.txt              | 94 +++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
> 
