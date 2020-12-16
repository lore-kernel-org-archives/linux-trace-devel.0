Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBDFC2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F389E236F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgLPUUo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgLPUUo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:20:44 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2775B2360D;
        Wed, 16 Dec 2020 20:20:04 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpdHH-000w5O-49; Wed, 16 Dec 2020 15:20:03 -0500
Message-ID: <20201216202002.933559836@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:19:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/2] libtracecmd: Add -rpath to libtracecmd.so
References: <20201216201938.008772358@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Pass in "-rpath=$ORIGIN" to the linker when building libtracecmd.so, such
that the path for libtraceevent.so and libtracefs.so might be found if it is
installed in the same location as libtracecmd.

Suggested-by: Yordan Karadzhov <ykaradzhov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/utils.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index c06888795ddf..8ac38cc983b1 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -64,7 +64,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ $(LIBS) -Wl,-soname,$(@F) -o $@)
+	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LIBS))
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
-- 
2.29.2


