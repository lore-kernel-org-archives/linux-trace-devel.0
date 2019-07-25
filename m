Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5D5C76194
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F95222BE8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfGYTrl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfGYTrl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 15:47:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2E122BE8;
        Thu, 25 Jul 2019 19:47:40 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hqjiF-0002JC-8B; Thu, 25 Jul 2019 15:47:39 -0400
Message-Id: <20190725194739.140392211@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 25 Jul 2019 15:45:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Revert adding relative path to policy installation
References: <20190725194537.884800321@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

This reverts the change in a45ab5a44 ("kernel-shark: Remove hard-coded
install paths") that removed the full path of installing
org.freedesktop.kshark-record.policy to a relative path. This means if we
installed in /usr/local/bin the policy still needs to go into
/usr/share/polkit-1/actions/

This does not affect DESTDIR, as installing still goes in the relative path
from DESTDIR for package maintainers.

Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index d91c3650f0dd..21494cccaf55 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -93,7 +93,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
             DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
+            DESTINATION /usr/share/polkit-1/actions/)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
             DESTINATION ${_INSTALL_PREFIX}/bin/)
-- 
2.20.1


