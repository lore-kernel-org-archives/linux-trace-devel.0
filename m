Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF18CC43461
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C48661178
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhDJAhr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:37:47 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:14812 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235249AbhDJAhr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 20:37:47 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 17:37:25 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id D2BE921458;
        Fri,  9 Apr 2021 17:37:29 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs: Make libtraceevent 1.2 the minimum version
Date:   Fri, 9 Apr 2021 20:37:25 -0400
Message-ID: <20210410003727.2288762-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210410003727.2288762-1-rostedt@goodmis.org>
References: <20210410003727.2288762-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that libtraceevent 1.2 has been released, make it the minimum version
that this library depends on, and be able to use all the APIs in that
library.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index a3ae0b8..bdb3eed 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ export TFS_PATCHLEVEL
 export TFS_EXTRAVERSION
 export TRACEFS_VERSION
 
-LIBTRACEEVENT_MIN_VERSION = 1.1
+LIBTRACEEVENT_MIN_VERSION = 1.2
 
 # taken from trace-cmd
 MAKEFLAGS += --no-print-directory
-- 
2.29.2

