Return-Path: <SRS0=Bo3z=VA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66FDC0650E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E938218A0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lClQTxZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGCMK4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:10:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55329 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfGCMK4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:10:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so1947373wmj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5ZRJmg77q7N98WC6D3Hsfc8vLwkGBQa9KzHHLrFwCE=;
        b=lClQTxZFdhD3DXhiA3dh+7r50uRxHIoJD52LIPDh788s08eYQHbFewFR+LmwGhhwtY
         3Hcuch1TTk45q40bDyqLGwOp8GocnSV68WxXkzFXCcs2gl0HvhO/jtL8hTZ+gtxcYE2e
         KFqCew9ajeilik2FVn5QRjJrv+mNgj6D6xEes3WaJcCg2nogT3mIs393zybb9pNo3Ol4
         o7kguSbTe3Kuo7oPLdSkRT/vvXCElm85AWZaSFW0hbnJErt1AFUUOfdYrm1dfBkqE83x
         DqVpmo3ks6UATjeC81+DpKxQFfobWpaohKYJUlbZYNf2D0AICZPnnXITK0TOZPKZx+sK
         sO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5ZRJmg77q7N98WC6D3Hsfc8vLwkGBQa9KzHHLrFwCE=;
        b=fereZLccZYNowg9RMG9AQsm7FhZ6/qnT1gfgmsZAPptfxGx6jELgdwXfkl03y8CjfA
         ppMDUMgveBiLREz9CZWN/VWehmc4eS5CrAyUC8M7TZZUTT4+DjPzMM4lbx7pLYeILy4U
         rx0upIadfOggJmYXS/2q5EiAekf7FtKm3/fZzecQOsCQNBxkNDcUDrqDZ2Gfrc01JkRB
         HhW8osYifcFxBrdpW4SuYx52/0rW3g3wQSnBbYsCl9xq3CFjKzHQgx4CFI4IC3FI0x+R
         9zEtCIlgL5xVVC2pWl7o3qKWYVmDNtT+O+jODvg+wtWeSepnX2KnP8rpaUFhCGn0ufNg
         QsjQ==
X-Gm-Message-State: APjAAAW1nprSw9M3yc2meKLg8A9d1/QbuqzA95EwUcNqWoMgeEZ80Y3B
        Tfcpf5QYvUmRY4e1TOG1FHhp+mRar0E=
X-Google-Smtp-Source: APXvYqz/ivMIY3kbs/2koWLV1StvtAB/QLTPdLr1BBB4W34d9jQBvLqFB/FqkyT1iaxgM8oMFXltNg==
X-Received: by 2002:a1c:b757:: with SMTP id h84mr8287638wmf.127.1562155854098;
        Wed, 03 Jul 2019 05:10:54 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u18sm2321587wmd.19.2019.07.03.05.10.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:10:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH v2 4/5] kernel-shark: Add hello_kernel plugin
Date:   Wed,  3 Jul 2019 15:10:22 +0300
Message-Id: <20190703121023.16655-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703121023.16655-1-y.karadz@gmail.com>
References: <20190703121023.16655-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This plugin is meant to be used for demonstration purposes only,
or as part of a tutorial describing how to write a new plugin.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/examples/CMakeLists.txt |  4 ++
 kernel-shark/examples/hello_kernel.c | 67 ++++++++++++++++++++++++++++
 kernel-shark/src/libkshark-plugin.h  |  3 ++
 3 files changed, 74 insertions(+)
 create mode 100644 kernel-shark/examples/hello_kernel.c

diff --git a/kernel-shark/examples/CMakeLists.txt b/kernel-shark/examples/CMakeLists.txt
index e16216e..824b21c 100644
--- a/kernel-shark/examples/CMakeLists.txt
+++ b/kernel-shark/examples/CMakeLists.txt
@@ -23,3 +23,7 @@ target_link_libraries(dplot   kshark-plot)
 message(STATUS "widgetdemo")
 add_executable(widgetdemo          widgetdemo.cpp)
 target_link_libraries(widgetdemo   kshark-gui)
+
+add_library(hello             SHARED  hello_kernel.c)
+set_target_properties(hello   PROPERTIES PREFIX "plugin-")
+target_link_libraries(hello   kshark-plot)
diff --git a/kernel-shark/examples/hello_kernel.c b/kernel-shark/examples/hello_kernel.c
new file mode 100644
index 0000000..6c78411
--- /dev/null
+++ b/kernel-shark/examples/hello_kernel.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    hello_kernel.c
+ *  @brief   Example plugin.
+ */
+
+// C
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif
+#include <stdio.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plot.h"
+#include "libkshark-plugin.h"
+
+char *font_file;
+struct ksplot_font mono_oblique_16;
+
+static void nop_action(struct kshark_context *kshark_ctx,
+		       struct tep_record *record,
+		       struct kshark_entry *entry)
+{}
+
+static void draw_hello(struct kshark_cpp_argv *argv_c,
+		       int val, int draw_action)
+{
+	if (!ksplot_font_is_loaded(&mono_oblique_16))
+		ksplot_init_font(&mono_oblique_16, 16, font_file);
+
+	ksplot_print_text(&mono_oblique_16, NULL, 100, 30, "hello kernel!");
+}
+
+/** Load this plugin. */
+int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
+{
+	font_file = ksplot_find_font_file("FreeMono", "FreeMonoOblique");
+	if (!font_file)
+		return 0;
+
+	kshark_register_event_handler(&kshark_ctx->event_handlers,
+				      KS_PLUGIN_NO_EVENT,
+				      nop_action,
+				      draw_hello);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
+{
+	kshark_unregister_event_handler(&kshark_ctx->event_handlers,
+					KS_PLUGIN_NO_EVENT,
+					nop_action,
+					draw_hello);
+
+	free(font_file);
+
+	return 1;
+}
diff --git a/kernel-shark/src/libkshark-plugin.h b/kernel-shark/src/libkshark-plugin.h
index b3cf1c6..b182d79 100644
--- a/kernel-shark/src/libkshark-plugin.h
+++ b/kernel-shark/src/libkshark-plugin.h
@@ -103,6 +103,9 @@ enum kshark_plugin_actions {
 	KSHARK_PLUGIN_CPU_DRAW,
 };
 
+/** No event identifier associated with the plugin. */
+#define KS_PLUGIN_NO_EVENT (-ENODEV)
+
 /**
  * Plugin Event handler structure, defining the properties of the required
  * kshark_entry.
-- 
2.20.1

