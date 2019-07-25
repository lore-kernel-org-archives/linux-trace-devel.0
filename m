Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B524C76194
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D702084C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbfGYRly (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:41:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50578 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbfGYRly (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 13:41:54 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 05F1C34882D
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 17:41:53 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: in python plugin, use PyUnicode_FromString on Python 3
Date:   Thu, 25 Jul 2019 10:41:36 -0700
Message-Id: <20190725174138.3724131-2-chutzpah@gentoo.org>
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

All strings are unicode in Python 3, so PyString_* is no longer
reccommended. This uses PyUnicode_* instead.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 plugins/plugin_python.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/plugins/plugin_python.c b/plugins/plugin_python.c
index e725ad8..dc7932e 100644
--- a/plugins/plugin_python.c
+++ b/plugins/plugin_python.c
@@ -81,7 +81,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	} else
 		Py_DECREF(res);
 
+#if PY_MAJOR_VERSION >= 3
+	str = PyUnicode_FromString("pevent");
+#else
 	str = PyString_FromString("pevent");
+#endif
 	if (!str)
 		return -ENOMEM;
 
-- 
2.22.0

