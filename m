Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C1EC25B4E
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 Jan 2023 18:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjAVSLQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 22 Jan 2023 13:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjAVSLP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 22 Jan 2023 13:11:15 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14305C668;
        Sun, 22 Jan 2023 10:11:13 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 7B1D720004;
        Sun, 22 Jan 2023 18:11:09 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-trace-devel@vger.kernel.org (open list:Real-time Linux Analysis
        (RTLA) tools),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Cc:     Diederik de Haas <didi.debian@cknow.org>
Subject: [PATCH] docs: rtla: Fix full name of the GPL
Date:   Sun, 22 Jan 2023 19:10:53 +0100
Message-Id: <20230122181053.53725-1-didi.debian@cknow.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
---
 Documentation/tools/rtla/common_appendix.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/tools/rtla/common_appendix.rst b/Documentation/tools/rtla/common_appendix.rst
index b5cf2dc223df..c631341e914e 100644
--- a/Documentation/tools/rtla/common_appendix.rst
+++ b/Documentation/tools/rtla/common_appendix.rst
@@ -10,4 +10,4 @@ LICENSE
 COPYING
 =======
 Copyright \(C) 2021 Red Hat, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
-- 
2.39.0

