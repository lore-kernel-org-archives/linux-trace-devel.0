Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDBDC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 00:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15130601FC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 00:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDIAz1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 20:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhDIAz0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 20:55:26 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01B8F601FC
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 00:55:13 +0000 (UTC)
Date:   Thu, 8 Apr 2021 20:55:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add -lpthread to build
Message-ID: <20210408205512.52c385d0@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to use pthread functions, include -lpthread to the linked
libraries to make sure that applications that include -ltracefs do not
require to have -lpthread as well, if the application is not using
pthreads.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ff1a3a6..b7f7f76 100644
--- a/Makefile
+++ b/Makefile
@@ -138,7 +138,7 @@ LIBTRACEFS_SHARED = $(bdir)/libtracefs.so.$(TRACEFS_VERSION)
 PKG_CONFIG_SOURCE_FILE = libtracefs.pc
 PKG_CONFIG_FILE := $(addprefix $(obj)/,$(PKG_CONFIG_SOURCE_FILE))
 
-LIBS = $(LIBTRACEEVENT_LIBS)
+LIBS = $(LIBTRACEEVENT_LIBS) -lpthread
 
 export LIBS
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
-- 
2.29.2

