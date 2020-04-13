Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2996CC2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B03820663
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388622AbgDMUzX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 16:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388526AbgDMUzW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 16:55:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BDCC20644
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 20:55:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jO66z-004Ep9-7T
        for linux-trace-devel@vger.kernel.org; Mon, 13 Apr 2020 16:55:21 -0400
Message-Id: <20200413205346.028742220@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 13 Apr 2020 16:53:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Minor updates to tracecmd_unpair_peer() function
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some minor clean ups of Tzvetomir's code for tracecmd_unpair_peer().

Instead of asking Tzvetomir to send another version, as these were
minor changes, I just decided to do it myself ;-)


Steven Rostedt (VMware) (2):
      trace-cmd: Fix cut and paste header comment of tracecmd_unpair_peer()
      trace-cmd: Make tracecmd_unpair_peer() return void

----
 include/trace-cmd/trace-cmd.h |  2 +-
 lib/trace-cmd/trace-input.c   | 11 ++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)
