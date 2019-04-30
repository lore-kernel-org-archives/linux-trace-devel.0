Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E76EC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F22B21743
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfD3WLR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 18:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WLQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 18:11:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1602920835;
        Tue, 30 Apr 2019 22:11:16 +0000 (UTC)
Date:   Tue, 30 Apr 2019 18:11:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 16/30] tools/lib/traceevent: Man page for list events
 APIs
Message-ID: <20190430181114.68903548@gandalf.local.home>
In-Reply-To: <20190412133811.15878-17-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-17-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:57 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +
> +The _tep_list_events_copy()_ is a thread safe version of _tep_list_events()_.
> +It has the same behavior, but the returned array is allocated internally and
> +must be freed by the caller.
> +

Probably should specify that the array should be freed but not the
contents of the array (See EXAMPLE below).

That being your example ;-)

-- Steve
