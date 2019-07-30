Return-Path: <SRS0=vd9q=V3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC15AC0650F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92CEE20693
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hrn7V9/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbfG3Muh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:50:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38195 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730011AbfG3Muh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:50:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so35177201wmj.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2019 05:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHqZrtGNQYN/qI3hapu35cvs2EXgA/Fjb3EpFIfyXmo=;
        b=Hrn7V9/Z6bbiGWPMDA3xLjW0c6VBsAfT9LshrqvAdfqIK96TvkHpxxwsJA6S0cn8Mw
         SHPCGu+4LN90JTwID1cKRKm/lNyuFxdKkH7+QfhMWVO4m1VT+RJKyNEieSWeicphyV4Z
         ALwfOcYz37LP/ZCUkmV/3sgEmnZa9K2KWcV4GZLARGe6N3EF5URNJPaF353Mhe59rpG+
         kLJIQTKAYxiYT4wewL8d3DekEmYRd0jjPIgSt+heMDETymoXEIqcxH0p/7K5ZUCH2rpZ
         lc28qdkEaXWeSWfq9GrwtwLfrMXngIQfBy5VFIBU4noBb+nliYZnSwnCO1bzmJAVV2Wu
         grnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHqZrtGNQYN/qI3hapu35cvs2EXgA/Fjb3EpFIfyXmo=;
        b=GMRBbLk1w++GjjqMJN3IlzVU/gvoxT9sNguhEU0gOvBBkWR7lT3rEvbPCjUnI7bXNE
         Fel3kdV4w4sLhT6BStChAVSjLhXb4zXKrDYdbcKR7aneYGeIJ0L4Gnk0z6F3hlUiz8tM
         wIWT1Xmex0xdQJrn5yo+Y0TWczsEGQOlO3zcmg7NN3Ksc8JSeRNhq/YRLik6xCsxVrC8
         cTA9Ey44ab1sGn2qtRocOxOYNsYegu2gOmMyKicbcgZtsJsMJgaZ+BJnUa5AMqLg4D0D
         Wj5fdl2bBcBnuh7KhqOC0wMaGfaJz17VLuNWbCdhl/Vt8EpF1eBXDqY3zICkVJnvITO0
         W8Nw==
X-Gm-Message-State: APjAAAW9YQve+LsZWCpPt+PleXoAuuHE2PNeAKvHw5kzpXE78pqxo4dd
        oxZyiJxMl3Qdv4fA1j7i0qk=
X-Google-Smtp-Source: APXvYqwQ3ALcL73cJswbXZRLwO48PTl3FyoUuXiRPEZBo9GwLHt6W3PE9Nf2GtRgUJkWxdvNrGh4dA==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr60928123wmm.62.1564491035056;
        Tue, 30 Jul 2019 05:50:35 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n12sm67577012wmc.24.2019.07.30.05.50.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:50:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] tools/lib/traceevent: Change user's plugin directory
Date:   Tue, 30 Jul 2019 15:50:28 +0300
Message-Id: <20190730125028.24789-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730125028.24789-1-tz.stoyanov@gmail.com>
References: <20190730125028.24789-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

To be compliant with XDG user directory layout,
the user's plugin directory is changed from
~/.traceevent/plugins to ~/.local/lib/traceevent/plugins/
Thanks to Patrick McLean:
https://lore.kernel.org/linux-trace-devel/20190313144206.41e75cf8@patrickm/

Suggested-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile       | 6 +++---
 tools/lib/traceevent/event-plugin.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3292c290654f..86ce17a1f7fb 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -62,15 +62,15 @@ set_plugin_dir := 1
 
 # Set plugin_dir to preffered global plugin location
 # If we install under $HOME directory we go under
-# $(HOME)/.traceevent/plugins
+# $(HOME)/.local/lib/traceevent/plugins
 #
 # We dont set PLUGIN_DIR in case we install under $HOME
 # directory, because by default the code looks under:
-# $(HOME)/.traceevent/plugins by default.
+# $(HOME)/.local/lib/traceevent/plugins by default.
 #
 ifeq ($(plugin_dir),)
 ifeq ($(prefix),$(HOME))
-override plugin_dir = $(HOME)/.traceevent/plugins
+override plugin_dir = $(HOME)/.local/lib/traceevent/plugins
 set_plugin_dir := 0
 else
 override plugin_dir = $(libdir)/traceevent/plugins
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 8ca28de9337a..e1f7ddd5a6cf 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -18,7 +18,7 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
-#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+#define LOCAL_PLUGIN_DIR ".local/lib/traceevent/plugins/"
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
-- 
2.21.0

