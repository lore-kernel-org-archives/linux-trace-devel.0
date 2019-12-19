Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CEDC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 21:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B100D24672
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 21:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfLSVs7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 16:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSVs7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 16:48:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F363C24672
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 21:48:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ii3fG-000Upi-3D
        for linux-trace-devel@vger.kernel.org; Thu, 19 Dec 2019 16:48:58 -0500
Message-Id: <20191219214805.821145530@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Dec 2019 16:48:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: A couple of fixes
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here's a couple of fixes to bugs that I found while playing with
the p2p code.


Steven Rostedt (VMware) (2):
      trace-cmd: Duplicate trace_clock in tracecmd_input handle
      tools lib traceevent: Add builtin handler for trace_marker_raw

----
 lib/trace-cmd/trace-input.c              |  7 ++++++
 lib/traceevent/plugins/plugin_function.c | 41 ++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)
