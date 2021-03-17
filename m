Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E825CC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2FD764F4F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhCQQuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:50:52 -0400
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:58375 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhCQQuW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:50:22 -0400
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id BB22B423B0;
        Wed, 17 Mar 2021 17:50:20 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id HaVXFRA8OPmp; Wed, 17 Mar 2021 17:50:18 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id A36FF42436;
        Wed, 17 Mar 2021 17:41:22 +0100 (CET)
Received: (nullmailer pid 30942 invoked by uid 1000);
        Wed, 17 Mar 2021 16:41:21 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 4/4] kernel-shark: Do not use sudo in install_gui.sh + update README
Date:   Wed, 17 Mar 2021 17:41:01 +0100
Message-Id: <20210317164101.30848-5-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317164101.30848-1-michal.sojka@cvut.cz>
References: <20210317164101.30848-1-michal.sojka@cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using `make install` to install kernelshark can lead to errors
described in the previous commit. Therefore, we instruct users to use
the provided script install_gui.sh. We update the script not to use
sudo, because it's preferable if users give root privileges explicitly
via command line.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 README               | 2 +-
 build/install_gui.sh | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/README b/README
index a7e66df..f5035f9 100644
--- a/README
+++ b/README
@@ -51,7 +51,7 @@ Building:
     cd kernel-shark/build
     cmake ../
     make
-    sudo make install
+    sudo ./install_gui.sh
 
 2.1 In order to create a Doxygen documentation add -D_DOXYGEN_DOC=1
 as a CMake Command-Line option.
diff --git a/build/install_gui.sh b/build/install_gui.sh
index d262f79..c42f4da 100755
--- a/build/install_gui.sh
+++ b/build/install_gui.sh
@@ -1,9 +1,9 @@
-if sudo cmake -DCOMPONENT=kernelshark -P cmake_install.cmake; then
+if cmake -DCOMPONENT=kernelshark -P cmake_install.cmake; then
     echo "Kernelshark installed correctly"
 else
     exit 1
 fi
 
-if ! sudo cmake -DCOMPONENT=polkit-policy -P cmake_install.cmake; then
+if ! cmake -DCOMPONENT=polkit-policy -P cmake_install.cmake; then
     echo >&2 "Warning: polkit policy not installed"
 fi
-- 
2.30.1

