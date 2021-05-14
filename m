Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E9FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA4A6140A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhENUvv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 16:51:51 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:43937 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231865AbhENUvv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 16:51:51 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 14 May 2021 13:50:35 -0700
Received: from vypre.com (unknown [10.21.244.184])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 030DD204C9;
        Fri, 14 May 2021 13:50:38 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtraceevent: Add include of event-parse.h into event-utils.h
Date:   Fri, 14 May 2021 16:50:34 -0400
Message-ID: <20210514205036.1383167-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514205036.1383167-1-rostedt@goodmis.org>
References: <20210514205036.1383167-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The event-parse.h references enum tep_loglevel which is defined in
event-utils.h. If a program includes event-utils.h first, it will get a
warning about using that enum in a parameter before it is declared.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-utils.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/event-utils.h b/src/event-utils.h
index 695905d..da95027 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -10,6 +10,8 @@
 #include <stdarg.h>
 #include <stdbool.h>
 
+#include <event-parse.h>
+
 void tep_warning(const char *fmt, ...);
 void tep_info(const char *fmt, ...);
 /* Can be overridden */
-- 
2.29.2

