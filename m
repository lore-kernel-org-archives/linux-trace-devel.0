Return-Path: <SRS0=G/lh=P5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFE2C282DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92092214DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfAUJJ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbfAUJJ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jan 2019 04:09:27 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA4D2085A;
        Mon, 21 Jan 2019 09:09:25 +0000 (UTC)
Date:   Mon, 21 Jan 2019 04:09:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/7] trace-cmd: Fixed logic in
 tracecmd_read_page_record()
Message-ID: <20190121040916.164116aa@vmware.local.home>
In-Reply-To: <20190116191838.32127-4-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
        <20190116191838.32127-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Jan 2019 21:18:34 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Fixed the logic in tracecmd_read_page_record() when
> searching for the next event in the event from the
> ring buffer.

Please explain what you are fixing. In other words, what was wrong with
the current logic?

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
