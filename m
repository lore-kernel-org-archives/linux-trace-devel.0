Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B83C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E527A64ECD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhCKNUR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:20:17 -0500
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:55391 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhCKNUH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:20:07 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2021 08:20:07 EST
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id 2376F16CC9;
        Thu, 11 Mar 2021 14:12:35 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id vrGfykyssNEg; Thu, 11 Mar 2021 14:12:33 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id 9F58116E13;
        Thu, 11 Mar 2021 14:12:33 +0100 (CET)
Received: (nullmailer pid 13656 invoked by uid 1000);
        Thu, 11 Mar 2021 13:12:33 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     linux-trace-devel@vger.kernel.org
Cc:     Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH] kernel-shark: Do not hardcode /usr prefix for polkit policies
Date:   Thu, 11 Mar 2021 14:12:21 +0100
Message-Id: <20210311131221.13600-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

---
 kernel-shark/src/CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 457c100..687e150 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -92,7 +92,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
             DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-            DESTINATION /usr/share/polkit-1/actions/)
+            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
             DESTINATION ${_INSTALL_PREFIX}/bin/)
-- 
2.30.1

