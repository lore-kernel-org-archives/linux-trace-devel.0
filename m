Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7B6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 01:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 458BE610F7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 01:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhDIBRv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 21:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhDIBRu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 21:17:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8CCD610C8
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 01:17:38 +0000 (UTC)
Date:   Thu, 8 Apr 2021 21:17:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix make install_libs updating of ldconfig
Message-ID: <20210408211736.0f9cb218@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The ldconfig file /etc/ld.conf.d/trace.conf was being updated when it did
not need to be, and should not be updated if ldconfig is not in the patch
when installing.

Add a check to see if ldconfig can successfully run before testing if conf
file should be updated. Also fix the grep of the conf file that looks for
the path such that the output is not displayed to the console.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index b7f7f76..9de3217 100644
--- a/Makefile
+++ b/Makefile
@@ -226,16 +226,17 @@ ifeq ("$(DESTDIR)", "")
 # and running ldconfig, if the library is visible by ld.so.
 # If not, add the path to /etc/ld.so.conf.d/trace.conf and run ldconfig again.
 define install_ld_config
-	$(LDCONFIG); \
-	if ! grep "^$(libdir)$$" $(LD_SO_CONF_PATH)/* &> /dev/null ; then \
-		$(CC) -o $(objtree)/test $(srctree)/test.c -I $(includedir_SQ) \
-			-L $(libdir_SQ) -ltracefs &> /dev/null; \
-		if ! $(objtree)/test &> /dev/null; then \
-			$(call print_install, trace.conf, $(LD_SO_CONF_PATH)) \
-			echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
-			$(LDCONFIG); \
+	if $(LDCONFIG); then \
+		if ! grep -q "^$(libdir)$$" $(LD_SO_CONF_PATH)/* ; then \
+			$(CC) -o $(objtree)/test $(srctree)/test.c -I $(includedir_SQ) \
+				-L $(libdir_SQ) -ltracefs &> /dev/null; \
+			if ! $(objtree)/test &> /dev/null; then \
+				$(call print_install, trace.conf, $(LD_SO_CONF_PATH)) \
+				echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
+				$(LDCONFIG); \
+			fi; \
+			$(RM) $(objtree)/test; \
 		fi; \
-		$(RM) $(objtree)/test; \
 	fi
 endef
 else
-- 
2.29.2

