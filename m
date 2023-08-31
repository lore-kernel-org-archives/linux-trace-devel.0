Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6017FC83F34
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Aug 2023 10:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbjHaKEp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 06:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjHaKEp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 06:04:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08657CF2
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Aug 2023 03:04:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4457DC15;
        Thu, 31 Aug 2023 03:05:22 -0700 (PDT)
Received: from oss-tx204.lab.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 477A13F64C;
        Thu, 31 Aug 2023 03:04:42 -0700 (PDT)
From:   ross.burton@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     nd@arm.com
Subject: [PATCH 3/3] meson: set the default plugindir to make Makefile
Date:   Thu, 31 Aug 2023 11:04:38 +0100
Message-Id: <20230831100438.3946997-3-ross.burton@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230831100438.3946997-1-ross.burton@arm.com>
References: <20230831100438.3946997-1-ross.burton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Ross Burton <ross.burton@arm.com>

The Makefiles install the plugins to $libdir/traceevent/plugins, so make
the Meson build files install to the same location.

Signed-off-by: Ross Burton <ross.burton@arm.com>
---
 meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 506b0e8..4bba4d8 100644
--- a/meson.build
+++ b/meson.build
@@ -25,7 +25,7 @@ htmldir = join_paths(prefixdir, get_option('htmldir'))
 libdir = join_paths(prefixdir, get_option('libdir'))
 plugindir = get_option('plugindir')
 if plugindir == ''
-    plugindir = join_paths(libdir, 'libtraceevent/plugins')
+    plugindir = join_paths(libdir, 'traceevent/plugins')
 endif
 
 add_project_arguments(
-- 
2.34.1

