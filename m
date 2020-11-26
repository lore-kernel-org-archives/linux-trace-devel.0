Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F977C64E75
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C9121D91
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILTuPLd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgKZH12 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388417AbgKZH11 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 02:27:27 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBF5C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:26 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 23so994135wrc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=155eFbvzNIo2NYG0tjZKkODYhe6FhrAiAaeJ2PeBkIE=;
        b=ILTuPLd9BQUT5mw7C9moJqKd5RVvfHR5sJ9ELT1ctBhXooYamarTCncsLaYtHkous7
         CLLMfZOiI4SU51IMbJCgONYbVbG+25W5S1S9cDy60OrPosKgVRtpeVr9GqaX5OuSxMBQ
         q99b7HX+9JOLbhZIE9KToOoooc6XWooFGHetD2rLddGKv0N7uGNOL7tqxyFxfR2d614Z
         +a5btvexkYaMC5Ehz4WoiVDMYy4YASeH1EAtsd43aq+/mffm8N0vWK4URzkLAP1FxBB0
         Tm818KtyMWwh47O1lK2XQD6v23aN0xvQYknkMkB6KtXbomsxqTRPEQu8Ny39Kn9qQkCA
         oqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=155eFbvzNIo2NYG0tjZKkODYhe6FhrAiAaeJ2PeBkIE=;
        b=LkwiH3ySM6x6XunmNtzHh5578RmNhM7ypg4J8+IN7ZYaFvu7oQfT8lQLHLvi5gEKe7
         yp1tPCjTt5ggaJC85qA83moB+TA55wGU8HWlVgRwGvVgCaNTrxZ2a0kc0FEu+c75UKiC
         cKvyqCyArlEx3w9bSR91OWKViMW9gx03e/kUzIwBQhIQI2gCV6ClnqiGm4dgt/cL1UIn
         7XcxX3Hp7o/jwSlxPM32u8FeM1SvDFA85Xi4PbnMjHZSs37rP2RWrltyp61dkc3a1Dbq
         CclmB8RUUs9Q5UZaU2O7ImsGmUqSXjMwOYrTe4gOjjRcNS0BxvNqbGrU2F+uNgEXE8VU
         vS3w==
X-Gm-Message-State: AOAM532VGWYbBhEg9IX8+STGPt4SQKCYgWIKKZnDA9lcR8QILKKpfu7S
        PDGHaTac4kGamTSKOHK5XQE=
X-Google-Smtp-Source: ABdhPJwk2kfoM7uUfjiOS4vsGlQBPwvU/E6tL+k/IQIDdmPjj0umr6kd4Pi27X1J3HjxeUCRdQDsBw==
X-Received: by 2002:a5d:5183:: with SMTP id k3mr2150969wrv.62.1606375644864;
        Wed, 25 Nov 2020 23:27:24 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n4sm7269659wmc.30.2020.11.25.23.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 23:27:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] libtracefs: Do not install library in a subfolder
Date:   Thu, 26 Nov 2020 09:27:19 +0200
Message-Id: <20201126072719.906443-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201126072719.906443-1-tz.stoyanov@gmail.com>
References: <20201126072719.906443-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

Make the installation consistent with libtraceevent:
 - Install tracefs.h in $(prefix)/include/tracefs/
 - Install libtracefs* in $(prefix)/lib or $(prefix)/lib64

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 Makefile | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index b464401..3158698 100644
--- a/Makefile
+++ b/Makefile
@@ -38,14 +38,22 @@ INSTALL = install
 DESTDIR ?=
 DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
+LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+ifeq ($(LP64), 1)
+  libdir_relative_temp = lib64
+else
+  libdir_relative_temp = lib
+endif
+
+libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
-libdir ?= $(prefix)/lib
+libdir = $(prefix)/$(libdir_relative)
 libdir_SQ = '$(subst ','\'',$(libdir))'
-includedir = $(prefix)/include
+includedir = $(prefix)/include/tracefs
 includedir_SQ = '$(subst ','\'',$(includedir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
@@ -212,10 +220,10 @@ cscope: force
 	$(call find_tag_files) | cscope -b -q
 
 install_libs: libs install_pkgconfig
-	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs); \
-		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)/tracefs
-	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ)/tracefs)
-	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/tracefs)
+	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)); \
+		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
+	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ))
+	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ))
 
 install: install_libs
 
-- 
2.28.0

