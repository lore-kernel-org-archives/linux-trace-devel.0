Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87039C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Apr 2022 00:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbiDIAYH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 20:24:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49906 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiDIAYC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 20:24:02 -0400
Received: from usagi.middle.earth (not.afront.org [50.126.75.182])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 74A1C8418213;
        Fri,  8 Apr 2022 17:21:57 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id 3804E3C36D6B;
        Fri,  8 Apr 2022 17:21:55 -0700 (PDT)
From:   "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] setup.py: fix string <-> int comparison
Date:   Fri,  8 Apr 2022 17:21:55 -0700
Message-Id: <20220409002155.1346141-1-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Apr 2022 17:21:57 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Slightly older (read: python 3.6ish) seem to treat the language_level
object as an integer all the time.  If you end up passing the version
in as a string (with the 's) it ends up doing a string to int comparison
and throws an error.  Newer python will deal with the non-matching
typing fine and this isn't an issue there.

So minor fix to be slightly more correct with relation to older python

Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
---
 setup.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/setup.py b/setup.py
index 21c627f..58561cf 100644
--- a/setup.py
+++ b/setup.py
@@ -74,7 +74,7 @@ def main():
                           sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
                           libraries=['traceevent', 'tracefs'])
 
-    cythonize('src/npdatawrapper.pyx', language_level = '3')
+    cythonize('src/npdatawrapper.pyx', language_level = 3)
     module_data = extension(name='tracecruncher.npdatawrapper',
                             sources=['src/npdatawrapper.c'],
                             libraries=['kshark'])
-- 
2.35.1

