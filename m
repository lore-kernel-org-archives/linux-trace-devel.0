Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716CAC4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 468A02075C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfCMT3Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfCMTNO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:13:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC552184D;
        Wed, 13 Mar 2019 19:13:13 +0000 (UTC)
Date:   Wed, 13 Mar 2019 15:13:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 27/46] tools/lib/traceevent: Man pages for
 tep_filter_alloc(), tep_filter_free() and tep_filter_reset()
Message-ID: <20190313151312.3dbe537c@gandalf.local.home>
In-Reply-To: <20190313151127.3dbd014b@gandalf.local.home>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-28-tstoyanov@vmware.com>
        <20190313151127.3dbd014b@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 15:11:27 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> We need more description on what a filter is. Hmm, perhaps we should
> make all the filter functions in one man page. This way the one man
> page can show how filters are used.
> 
> That is, combine this patch with the next 4 patches.

Make that the next 5 patches.

-- Steve
