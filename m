Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F296C7EE23
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 12:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbjFGMCK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 08:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbjFGMCJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 08:02:09 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B50C1BC7
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 05:02:06 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-30d181952a2so5207956f8f.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jun 2023 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686139325; x=1688731325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw7nb+LK2sJTJwSLJBwJjeKjKfsUpxL7qUEGss+tscw=;
        b=ZIFRjwcCgwQvmmElFCvlozdQZD4HeRzMwYKJx0xp2LPAjeJdz6ZuGyhGVmC+0l/JkA
         RFUt9DwOOs88GjfcexTyZtlC+oghbB3/9JBRlVZDjcLHPQeakYuK0KOT1QwLL3jEhp91
         HWw7kJ/UKpmyUU+oawLCQdN5uB/v+3lTwe3gBcInpZ3oU4HWOkb+dNs0wbFV9HHWS1Ph
         tbGAnA1n0K75KKs2K2Bm/lJiSHwf2XKhJHIAX0LRDFViZn6tbJvsQ5zWJ9kptRbb27E9
         6+ySoNdbSd/dO+WKmBaVNJcRh1aO9UrwZKCQhj+wpZzOPy6lamJX59HbEP6OSDW/e+K4
         Xlpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686139325; x=1688731325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gw7nb+LK2sJTJwSLJBwJjeKjKfsUpxL7qUEGss+tscw=;
        b=k1vpiKeO5N4eZcAHPDNpjwf9YqUHnSsusAzVrGuEFI67aXdtdxA/f5iOW4LFf/maVf
         sotDxTLH6rj/p90ma3T3aWeeG0NKxpkkiAVlg5qGWzXQtWHcwXP8LkYarWd/LPxKzq43
         Jir/EeFB5PXQTXyEhrT7+dNf0InrtWqKUi433j5I8lbZ0s969nvGrBFAmhjAU/9ajLHY
         5NcyHp1Ce+0RigBfZwGjQzN0oYVeixZMXI9H4g2yO5QoGiP7zLQp9SjW02wWvinKwVzB
         KNXZPG9W0JzhsGc9C0Kc7UAaO6QjoUR8XaPNRCX/HHZa4utnTIqU6fId/+ujTjgVtuPb
         LIcw==
X-Gm-Message-State: AC+VfDw4DMoJcjmWgBEH+RvnbgHEvqDSnazlyyCDkeHat3mB8G/c1FMt
        dmEd6s/BA9vtURhOZ8l2xoK4hfqFTTs=
X-Google-Smtp-Source: ACHHUZ4GUIIqX8Yx+YJP+RPnDyW1H5ux67sK1s2GxlMciAtIkLktXYswTrX3f9z/4rjAofF1eYl6vA==
X-Received: by 2002:a5d:5611:0:b0:30a:dee9:1332 with SMTP id l17-20020a5d5611000000b0030adee91332mr4171785wrv.67.1686139324289;
        Wed, 07 Jun 2023 05:02:04 -0700 (PDT)
Received: from oberon.zico.biz.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id s9-20020a5d5109000000b003063a1cdaf2sm15409042wrt.48.2023.06.07.05.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:02:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add Makefie target for memory test
Date:   Wed,  7 Jun 2023 15:02:02 +0300
Message-Id: <20230607120202.86447-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Having an automated test for memory problems is a useful functionality.
Combined with the trace-cmd unit test, it can be used to detect any
memory issues in the application. New Makefile target is added, which
runs the trace-cmd unit test on valgrind, to check for memory allocation
errors.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile       |  3 +++
 utest/Makefile | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Makefile b/Makefile
index ea83f600..9183ba7a 100644
--- a/Makefile
+++ b/Makefile
@@ -456,6 +456,9 @@ ifneq ($(CUNIT_INSTALLED),1)
 endif
 	$(Q)$(MAKE) -C $(src)/utest $@
 
+test_mem: force test
+	$(Q)$(MAKE) -C $(src)/utest $@
+
 plugins_tracecmd: force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins
 
diff --git a/utest/Makefile b/utest/Makefile
index 337db9bf..480edcd3 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -17,6 +17,8 @@ LIBS += $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS)
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
+VALGRIND = $(shell which valgrind)
+
 $(bdir):
 	@mkdir -p $(bdir)
 
@@ -39,5 +41,18 @@ dep_includes := $(wildcard $(DEPS))
 
 test: $(TARGETS)
 
+test_mem: test
+ifeq (, $(VALGRIND))
+	$(error "No valgrind in $(PATH), cannot run memory test")
+endif
+ifneq ($(shell id -u), 0)
+	$(error "The memory test should be run as root, as it reuqires full access to tracefs")
+endif
+	CK_FORK=no $(VALGRIND) \
+		--show-leak-kinds=all --leak-resolution=high \
+		--leak-check=full --show-possibly-lost=yes \
+		--track-origins=yes -s \
+		$(bdir)/trace-utest
+
 clean:
 	$(RM) $(TARGETS) $(bdir)/*.o $(bdir)/.*.d
-- 
2.40.1

