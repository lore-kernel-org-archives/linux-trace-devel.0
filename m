Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCBEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6B264F41
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhCQQuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:50:51 -0400
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:40725 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhCQQuW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:50:22 -0400
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id B9FB042611;
        Wed, 17 Mar 2021 17:50:20 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id vB1S2nbVAhUM; Wed, 17 Mar 2021 17:50:18 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id 15281423AA;
        Wed, 17 Mar 2021 17:41:22 +0100 (CET)
Received: (nullmailer pid 30936 invoked by uid 1000);
        Wed, 17 Mar 2021 16:41:21 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 2/4] kernel-shark: Allow specifying TT_FONT_FILE on cmake command line
Date:   Wed, 17 Mar 2021 17:40:59 +0100
Message-Id: <20210317164101.30848-3-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317164101.30848-1-michal.sojka@cvut.cz>
References: <20210317164101.30848-1-michal.sojka@cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On distributions like NixOS, which build packages in a sandbox,
fontconfig configuration files may not be available at build time,
which leads to the following cmake warnings even if the font itself is
available:

    Fontconfig error: Cannot load default config file
    CMake Warning at CMakeLists.txt:62 (message):

      Could not find font FreeSans!

This commit allows to specify exact font location on cmake commandline
via -DTT_FONT_FILE=... When specified, automatic font look up via
fc-list is skipped.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 CMakeLists.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index efcccb1..c4731c1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -50,8 +50,10 @@ find_package(OpenGL)
 find_package(GLUT)
 
 set(KS_FONT FreeSans)
-execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep ${KS_FONT}.ttf | cut -d':' -f 1 -z"
-                OUTPUT_VARIABLE TT_FONT_FILE)
+if (NOT TT_FONT_FILE)
+    execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep ${KS_FONT}.ttf | cut -d':' -f 1 -z"
+                    OUTPUT_VARIABLE TT_FONT_FILE)
+endif (NOT TT_FONT_FILE)
 
 if (TT_FONT_FILE)
 
-- 
2.30.1

