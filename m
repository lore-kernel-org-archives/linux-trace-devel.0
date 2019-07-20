Return-Path: <SRS0=TfJx=VR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F4BC76196
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 478FF21874
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390433AbfGTDD4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 23:03:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39660 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390400AbfGTDD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 23:03:56 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 2D0B8348128
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jul 2019 03:03:56 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd: Allow overriding of python installation directory
Date:   Fri, 19 Jul 2019 20:03:41 -0700
Message-Id: <20190720030344.1991393-2-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720030344.1991393-1-chutzpah@gentoo.org>
References: <20190720030344.1991393-1-chutzpah@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

The current Makefile hardcodes the python module install directory, so
packages can't put them in their distro's perferred location. This
allows the directory to be overriden on the command line.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ad74a96..3579f27 100644
--- a/Makefile
+++ b/Makefile
@@ -64,7 +64,7 @@ python_dir = $(HOME)/.trace-cmd/python
 var_dir = $(HOME)/.trace-cmd/
 else
 plugin_dir = $(libdir)/trace-cmd/plugins
-python_dir = $(libdir)/trace-cmd/python
+python_dir ?= $(libdir)/trace-cmd/python
 PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
-- 
2.22.0

