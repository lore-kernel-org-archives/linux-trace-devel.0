Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F1EC2BBCD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 736E323770
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgLPUMQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbgLPUMP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E99C23609
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd94-000vu3-BB
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:34 -0500
Message-ID: <20201216201134.148017704@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/8] libtracefs: Use $(objtree) instead of $(OUTPUT) for ld.so test
References: <20201216201106.170659791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Use the variable $(objtree) to build the test program in the O=path
directory, as there is no $(OUTPUT) variable defined.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index a7d58081bf4b..f675d5e60db1 100644
--- a/Makefile
+++ b/Makefile
@@ -224,14 +224,14 @@ ifeq ("$(DESTDIR)", "")
 define install_ld_config
 	$(LDCONFIG); \
 	if ! grep "^$(libdir)$$" $(LD_SO_CONF_PATH)/* &> /dev/null ; then \
-		$(CC) -o $(OUTPUT)test $(srctree)/test.c -I $(includedir_SQ) \
+		$(CC) -o $(objtree)/test $(srctree)/test.c -I $(includedir_SQ) \
 			-L $(libdir_SQ) -ltracefs &> /dev/null; \
-		if ! $(OUTPUT)test &> /dev/null; then \
+		if ! $(objtree)/test &> /dev/null; then \
 			$(call print_install, trace.conf, $(LD_SO_CONF_PATH)) \
 			echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
 			$(LDCONFIG); \
 		fi; \
-		$(RM) $(OUTPUT)test; \
+		$(RM) $(objtree)/test; \
 	fi
 endef
 else
-- 
2.29.2


