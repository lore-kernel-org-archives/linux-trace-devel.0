Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87128C83F32
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Aug 2023 10:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjHaKEp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 06:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjHaKEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 06:04:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99565CED
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Aug 2023 03:04:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2C50C15;
        Thu, 31 Aug 2023 03:05:20 -0700 (PDT)
Received: from oss-tx204.lab.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BDF6D3F64C;
        Thu, 31 Aug 2023 03:04:40 -0700 (PDT)
From:   ross.burton@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     nd@arm.com
Subject: [PATCH 1/3] meson: add option to disable documentation
Date:   Thu, 31 Aug 2023 11:04:36 +0100
Message-Id: <20230831100438.3946997-1-ross.burton@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Ross Burton <ross.burton@arm.com>

Building the documentation shouldn't be mandatory, as it needs asciidoc
and xmlto.  Add a "docs" option, defaulting to true, to control whether
the documentation should be built.

Signed-off-by: Ross Burton <ross.burton@arm.com>
---
 meson.build       | 15 +++++++++------
 meson_options.txt |  4 ++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/meson.build b/meson.build
index b61c873..506b0e8 100644
--- a/meson.build
+++ b/meson.build
@@ -45,10 +45,13 @@ if cunit_dep.found()
     subdir('utest')
 endif
 subdir('samples')
-subdir('Documentation')
 
-custom_target(
-    'docs',
-    output: 'docs',
-    depends: [html, man],
-    command: ['echo'])
+if get_option('docs')
+    subdir('Documentation')
+
+    custom_target(
+        'docs',
+        output: 'docs',
+        depends: [html, man],
+        command: ['echo'])
+endif
diff --git a/meson_options.txt b/meson_options.txt
index b2294f6..0611216 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -4,6 +4,10 @@
 
 option('plugindir', type : 'string',
        description : 'set the plugin dir')
+
+option('docs', type : 'boolean', value: true,
+       description : 'build documentation')
+
 option('htmldir', type : 'string', value : 'share/doc/libtraceevent-doc',
        description : 'directory for HTML documentation')
 option('asciidoctor', type : 'boolean', value: false,
-- 
2.34.1

