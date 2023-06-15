Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B703AEB64D9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjFORoB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjFORoA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 13:44:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8212D2711
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 10:43:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 17F1C1FE35;
        Thu, 15 Jun 2023 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686851032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=u5Ly8cY3EAD2OuENQlj6svi0EpqxH23+RVRb9ENFg4E=;
        b=yZN5Cy/mu3heLYuMvdZv+sm7/R89QQaT5E0up+gS0jgynX55w8pNSjMx4pdAuxKJh9C3fi
        6G/7BnEirnUMg0DZn4w+rdZerpCXP0wZ+M2R0jCI9y0pddNhAoh+xx0PPKmnVqmTrsBWWI
        xOOzuZWyieT7fnPMMpwdt27GgcEhPQs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686851032;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=u5Ly8cY3EAD2OuENQlj6svi0EpqxH23+RVRb9ENFg4E=;
        b=v3IFp/HQFHPTlwBkChtf/vqUKu4+5fR99l4oNQHioZHv0OeVu3UGtWPA0ijm+SkJqSgHSa
        u2gkgNwn9CUI3QBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09C8D13467;
        Thu, 15 Jun 2023 17:43:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +a1RAthNi2RwVAAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 15 Jun 2023 17:43:52 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>, Tony Jones <tonyj@suse.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] libtracefs: Add explicit pthread dependency to meson
Date:   Thu, 15 Jun 2023 19:43:49 +0200
Message-Id: <20230615174349.8810-1-dwagner@suse.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Older version of meson do not add automatically the pthread dependency.
Thus add it explicitly to the build.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 meson.build         | 1 +
 samples/meson.build | 4 ++--
 src/meson.build     | 4 ++--
 utest/meson.build   | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/meson.build b/meson.build
index d0f0e2dafc8a..9d42d78ad957 100644
--- a/meson.build
+++ b/meson.build
@@ -17,6 +17,7 @@ project(
 library_version = meson.project_version()
 
 libtraceevent_dep = dependency('libtraceevent', version: '>= 1.7.0', required: true)
+threads_dep = dependency('threads', required: true)
 cunit_dep = dependency('cunit', required : false)
 
 prefixdir = get_option('prefix')
diff --git a/samples/meson.build b/samples/meson.build
index 5e8ad270f812..112b12217a04 100644
--- a/samples/meson.build
+++ b/samples/meson.build
@@ -30,7 +30,7 @@ foreach ex : examples
     executable(
         ex.underscorify(),
         src,
-        dependencies: [libtracefs_dep, libtraceevent_dep],
+        dependencies: [libtracefs_dep, libtraceevent_dep, threads_dep],
         include_directories: [incdir])
 endforeach
 
@@ -39,7 +39,7 @@ src = gen.process(meson.current_source_dir() + '/../Documentation/libtracefs-sql
 executable(
    'sqlhist',
    src,
-   dependencies: [libtracefs_dep, libtraceevent_dep],
+   dependencies: [libtracefs_dep, libtraceevent_dep, threads_dep],
    include_directories: [incdir],
    install: true,
    install_dir: bindir)
diff --git a/src/meson.build b/src/meson.build
index 56087e2301bf..5b7655453f50 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -36,14 +36,14 @@ libtracefs = library(
     'tracefs',
     sources, lfiles, pfiles,
     version: library_version,
-    dependencies: [libtraceevent_dep],
+    dependencies: [libtraceevent_dep, threads_dep],
     include_directories: [incdir],
     install: true)
 
 libtracefs_static = static_library(
     'tracefs_static',
     sources, lfiles, pfiles,
-    dependencies: [libtraceevent_dep],
+    dependencies: [libtraceevent_dep, threads_dep],
     include_directories: [incdir],
     install: false)
 
diff --git a/utest/meson.build b/utest/meson.build
index 91a526fca2bf..c79313c7c1fb 100644
--- a/utest/meson.build
+++ b/utest/meson.build
@@ -11,7 +11,7 @@ e = executable(
    'trace-utest',
    source,
    include_directories: [incdir],
-   dependencies: [libtraceevent_dep, cunit_dep],
+   dependencies: [libtraceevent_dep, threads_dep, cunit_dep],
    link_with: libtracefs_static)
 
 test('trace-utest', e)
-- 
2.40.1

