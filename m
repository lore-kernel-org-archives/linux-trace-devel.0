Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92849EB64DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjFORpL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjFORpI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 13:45:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431D1BDB
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 10:45:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A38D31FE58;
        Thu, 15 Jun 2023 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686851105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=t6FARINFGpzw0rRSTTukj7OnGDJGSyPdNGxV3WmXFL0=;
        b=lCaJOHqLID61f/8laQRNsBwhaZwcFSMEmAre5o1h5FjKS38+sux3Wq1ue/SUGCsaV0Zx3t
        mTZNCpNrd2c7WbSpoRkGectNJAH4SVe488UEajxXCpUJM3SIvPh/bXh+iiMkpa1L60XmEZ
        avW25wY1CxT2ClrU7WNifgLczDN4Ro8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686851105;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=t6FARINFGpzw0rRSTTukj7OnGDJGSyPdNGxV3WmXFL0=;
        b=GP8SSwLuxyj+JAVBDW1fZI9zeL/Efb9h6uypClz28WVH4UtEapTgm3Qn3e0cEZENAlJzyM
        Lj5foCNJao5sA+CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9513713467;
        Thu, 15 Jun 2023 17:45:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 87VWJCFOi2QXVQAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 15 Jun 2023 17:45:05 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>, Tony Jones <tonyj@suse.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 1/2] libtracecmd: Add explicit pthread and dl dependency to meson
Date:   Thu, 15 Jun 2023 19:44:59 +0200
Message-Id: <20230615174500.9158-1-dwagner@suse.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Older version of meson do not add automatically the pthread and dl
dependency. Thus add it explicitly to thebuild.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 lib/meson.build           | 3 +++
 lib/trace-cmd/meson.build | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/lib/meson.build b/lib/meson.build
index 52f892fd82d5..389281d3806a 100644
--- a/lib/meson.build
+++ b/lib/meson.build
@@ -29,6 +29,9 @@ conf = configuration_data()
 libtraceevent_dep = dependency('libtraceevent', version: '>= 1.5.0', required: true)
 libtracefs_dep = dependency('libtracefs', version: '>= 1.6.0', required: true)
 
+threads_dep = dependency('threads', required: true)
+dl_dep = cc.find_library('dl', required : false)
+
 zlib_dep = dependency('zlib', required: false)
 conf.set('HAVE_ZLIB', zlib_dep.found(), description: 'Is zlib avialable?')
 
diff --git a/lib/trace-cmd/meson.build b/lib/trace-cmd/meson.build
index 8c00ca8f8ff7..2193e5265b22 100644
--- a/lib/trace-cmd/meson.build
+++ b/lib/trace-cmd/meson.build
@@ -45,6 +45,8 @@ if libtracecmd_standalone_build
         dependencies: [
             libtraceevent_dep,
             libtracefs_dep,
+            threads_dep,
+            dl_dep,
             zlib_dep,
             libzstd_dep,
             audit_dep],
@@ -77,6 +79,8 @@ else
         dependencies: [
             libtraceevent_dep,
             libtracefs_dep,
+            threads_dep,
+            dl_dep,
             zlib_dep,
             libzstd_dep,
             audit_dep],
-- 
2.40.1

