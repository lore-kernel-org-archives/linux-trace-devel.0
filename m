Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93869C41514
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BB3F2084C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfGYRlz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:41:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50580 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfGYRlz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 13:41:55 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 3B7C5348AAE
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 17:41:54 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Add missing headers to Python template
Date:   Thu, 25 Jul 2019 10:41:37 -0700
Message-Id: <20190725174138.3724131-3-chutzpah@gentoo.org>
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

The templates that generate Python bindings are missing some headers
that result in compile-time warnings. This adds the missing headers
where needed.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 python/ctracecmd.i    | 1 +
 python/ctracecmdgui.i | 1 +
 2 files changed, 2 insertions(+)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 2601d39..01cd0d5 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -16,6 +16,7 @@
 %{
 #include "trace-cmd.h"
 #include "event-utils.h"
+#include <Python.h>
 %}
 
 
diff --git a/python/ctracecmdgui.i b/python/ctracecmdgui.i
index 1dcdab0..032f3ff 100644
--- a/python/ctracecmdgui.i
+++ b/python/ctracecmdgui.i
@@ -7,6 +7,7 @@
 #include <pygobject.h>
 #include <pyglib.h>
 #include <Python.h>
+#include <memoryobject.h>
 
 extern GtkTreeModel *trace_view_store_as_gtk_tree_model(struct trace_view_store *store);
 
-- 
2.22.0

