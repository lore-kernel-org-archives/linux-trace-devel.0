Return-Path: <SRS0=jW1X=PT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDAEC43387
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jan 2019 22:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7908221783
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jan 2019 22:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfAKWMN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jan 2019 17:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfAKWMN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jan 2019 17:12:13 -0500
Received: from gandalf.local.home (cpe-66-24-56-78.stny.res.rr.com [66.24.56.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08B2B2084C;
        Fri, 11 Jan 2019 22:12:11 +0000 (UTC)
Date:   Fri, 11 Jan 2019 17:12:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Matt Helsley <mhelsley@vmware.com>
Subject: Patchwork is live for linux-trace-devel!
Message-ID: <20190111171210.13e83e4b@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

FYI, we now have patchwork working for linux-trace-devel, and it's
also archived. Now I don't need to use my INBOX to figure out what I
need to handle for trace-cmd and KernelShark.

 https://patchwork.kernel.org/project/linux-trace-devel/list/

And the lists are archived here:

  https://lore.kernel.org/linux-trace-devel/
  https://lore.kernel.org/linux-trace-users/

-- Steve
