Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA72C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8B6613C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhENUvw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 16:51:52 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:56566 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231865AbhENUvw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 16:51:52 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 14 May 2021 13:50:36 -0700
Received: from vypre.com (unknown [10.21.244.184])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id B11FE204C5;
        Fri, 14 May 2021 13:50:39 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtraceevent: Have the header protection be more name space safe
Date:   Fri, 14 May 2021 16:50:35 -0400
Message-ID: <20210514205036.1383167-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514205036.1383167-1-rostedt@goodmis.org>
References: <20210514205036.1383167-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The header protection for event-utils.h is just _UTIL_H which is not very
name space safe and if another header were to use that, it could cause
this header not to be included (or this header could cause the other
header not to be included). Also update event-parse.h as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.h | 4 ++--
 src/event-utils.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.h b/src/event-parse.h
index 77be2b9..d4a876f 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -3,8 +3,8 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#ifndef _PARSE_EVENTS_H
-#define _PARSE_EVENTS_H
+#ifndef __TEP_PARSE_EVENTS_H
+#define __TEP_PARSE_EVENTS_H
 
 #include <stdbool.h>
 #include <stdarg.h>
diff --git a/src/event-utils.h b/src/event-utils.h
index da95027..607be0c 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -3,8 +3,8 @@
  * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#ifndef __UTIL_H
-#define __UTIL_H
+#ifndef __TEP_EVENT_UTIL_H
+#define __TEP_EVENT_UTIL_H
 
 #include <ctype.h>
 #include <stdarg.h>
-- 
2.29.2

