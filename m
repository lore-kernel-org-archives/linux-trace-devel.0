Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0BDC63697
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 18:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B6BC20657
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 18:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgKWStl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgKWStl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 13:49:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C23420724
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 18:49:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1khGuC-0017Y7-4f
        for linux-trace-devel@vger.kernel.org; Mon, 23 Nov 2020 13:49:40 -0500
Message-ID: <20201123184940.031517790@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 23 Nov 2020 13:48:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracevent: Remove tempfile libtraceevent.pc
References: <20201123184841.548901150@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

"make install" copies libtraceevent.pc.template to libtraceevent.pc and then
modifies it for the installation. This command is usually executed as root,
and when finished, it leaves behind the libtraceevent.pc file owned by root.

Have the "make install" clean up and remove the temporary libtraceevent.pc
file, so that root owned files do not get left behind.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 2a6bfcce814f..775fbd2b3f0e 100644
--- a/Makefile
+++ b/Makefile
@@ -218,6 +218,7 @@ define do_install_pkgconfig_file
 		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
 		sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+		${RM} ${PKG_CONFIG_FILE}; \
 	else 									\
 		(echo Failed to locate pkg-config directory) 1>&2;		\
 	fi
-- 
2.28.0


