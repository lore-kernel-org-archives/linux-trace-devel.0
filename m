Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D49C83F33
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Aug 2023 10:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjHaKEp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 06:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjHaKEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 06:04:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41251CEE
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Aug 2023 03:04:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7ADB1FEC;
        Thu, 31 Aug 2023 03:05:21 -0700 (PDT)
Received: from oss-tx204.lab.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7E7D23F64C;
        Thu, 31 Aug 2023 03:04:41 -0700 (PDT)
From:   ross.burton@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     nd@arm.com
Subject: [PATCH 2/3] meson: build plugins as modules
Date:   Thu, 31 Aug 2023 11:04:37 +0100
Message-Id: <20230831100438.3946997-2-ross.burton@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230831100438.3946997-1-ross.burton@arm.com>
References: <20230831100438.3946997-1-ross.burton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Ross Burton <ross.burton@arm.com>

Don't build the plugins with library() as that will install both static
libraries and versioned shared libraries.  Plugins are shared_modules().

Signed-off-by: Ross Burton <ross.burton@arm.com>
---
 plugins/meson.build | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/plugins/meson.build b/plugins/meson.build
index 74ad664..4919be4 100644
--- a/plugins/meson.build
+++ b/plugins/meson.build
@@ -19,11 +19,10 @@ plugins = [
 
 pdeps = []
 foreach plugin : plugins
-    pdeps += library(
+    pdeps += shared_module(
         plugin.replace('.c', ''),
         plugin,
         name_prefix: '',
-        version: library_version,
         dependencies: [libtraceevent_dep],
         include_directories: [incdir],
         install: true,
-- 
2.34.1

