Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBDFC76191
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A673206DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfGYRlz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:41:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50582 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbfGYRlz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 13:41:55 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 7C67D348A57
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 17:41:54 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: In the ctracecmdgui use PyLong on Python 3
Date:   Thu, 25 Jul 2019 10:41:38 -0700
Message-Id: <20190725174138.3724131-4-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725174138.3724131-1-chutzpah@gentoo.org>
References: <20190725174138.3724131-1-chutzpah@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

Python 3 does not have PyInt anymore, so use the PyLong_* functions when
building on Python 3.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 python/ctracecmdgui.i | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/python/ctracecmdgui.i b/python/ctracecmdgui.i
index 032f3ff..4a7c6ac 100644
--- a/python/ctracecmdgui.i
+++ b/python/ctracecmdgui.i
@@ -37,12 +37,21 @@ pytype_from_gtype(GType gtype)
 }
 
 /* help swig cope with g* types */
+#if PY_MAJOR_VERSION >= 3
+%typemap(in) gint {
+    $1 = PyLong_AsLong($input);
+}
+%typemap(out) gint {
+    $result = PyLong_FromLong($1);
+}
+#else
 %typemap(in) gint {
     $1 = PyInt_AsLong($input);
 }
 %typemap(out) gint {
     $result = PyInt_FromLong($1);
 }
+#endif
 %typemap(in) guint {
     $1 = PyLong_AsUnsignedLong($input);
 }
-- 
2.22.0

