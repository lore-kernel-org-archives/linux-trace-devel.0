Return-Path: <SRS0=b+cV=4I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB75EC11D0B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 14:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9760207FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 14:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgBTOgY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 09:36:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgBTOgY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 09:36:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1E4207FD
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Feb 2020 14:36:23 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:36:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add output to show "make test"
Message-ID: <20200220093622.6df7dafc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The unit tests are made with "make test". In order to let developers know of
this option, have it displayed when just "make" is used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 60cd1570..a3facaa9 100644
--- a/Makefile
+++ b/Makefile
@@ -364,6 +364,7 @@ $(obj)/lib/traceevent/plugins/trace_python_dir: force
 show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
 	@echo "      to build man pages, type \"make doc\""
+	@echo "      to build unit tests, type \"make test\""
 
 PHONY += show_gui_make
 
-- 
2.20.1

