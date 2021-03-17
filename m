Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3A4C433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E5664F69
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhCQQuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:50:52 -0400
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:37863 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhCQQuW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:50:22 -0400
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id BB32942612;
        Wed, 17 Mar 2021 17:50:20 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id 9OWUpSVBTtU5; Wed, 17 Mar 2021 17:50:18 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id 7FF0F42435;
        Wed, 17 Mar 2021 17:41:21 +0100 (CET)
Received: (nullmailer pid 30934 invoked by uid 1000);
        Wed, 17 Mar 2021 16:41:20 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 1/4] kernel-shark: Allow specifying PKG_CONFIG_DIR on cmake command line
Date:   Wed, 17 Mar 2021 17:40:58 +0100
Message-Id: <20210317164101.30848-2-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317164101.30848-1-michal.sojka@cvut.cz>
References: <20210317164101.30848-1-michal.sojka@cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On some distributions (e.g. NixOS), it is not possible to write files
to directories owned by different packages. For this reason, we cannot
always install libkshark.pc file to the directory reported by
pkg-config.

This commit allows to specify where to install the .pc file on cmake
commandline via -DPKG_CONGIG_DIR=... When specified, automatic
detection of .pc install directory is skipped.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 src/CMakeLists.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 1e86e9c..b81d7d9 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -134,8 +134,10 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
             DESTINATION ${_INSTALL_PREFIX}/bin/
                 COMPONENT                 kernelshark)
 
-    execute_process(COMMAND  bash "-c" "pkg-config --variable pc_path pkg-config | cut -f 1 -d: -z"
-                    OUTPUT_VARIABLE PKG_CONGIG_DIR)
+    if (NOT PKG_CONGIG_DIR)
+        execute_process(COMMAND  bash "-c" "pkg-config --variable pc_path pkg-config | cut -f 1 -d: -z"
+          OUTPUT_VARIABLE PKG_CONGIG_DIR)
+    endif (NOT PKG_CONGIG_DIR)
     install(FILES "${KS_DIR}/libkshark.pc"
             DESTINATION ${PKG_CONGIG_DIR}
                 COMPONENT                 libkshark-devel)
-- 
2.30.1

