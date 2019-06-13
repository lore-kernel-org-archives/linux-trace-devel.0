Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6852FC31E49
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48348206BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfFMPg5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35800 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfFMKPJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:15:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so9511954wml.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 03:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3muP3yVjIm4OumoaDuLXtpn9+sqIyPwH8egQJCJgSfw=;
        b=jvz+f9KRjrJB0yaTFzjnUqHHedH99S8wu97dw+d7Ioj1IE9bBH+S6HsBUxZ8b3+pMR
         BE164d+ZvKTufot+LMFB4YdN1KAph+KHoEZXbopftAb+e31mo5q3pkl/vrrrD/zMOWVP
         nziuSxZ4xJakZMKBdHkBwBkSBETNpZqzgLfPlyJdj1bDC3zR0QZbjQ+hU56jRiGInBpf
         bhlXmHmTLZDmX5kqsprU4Chfq1tELGYIeCfRuwBRdB8YogsOmzKNML/tJVJIW20fNMSv
         /mEnpdEObvagviuHLMj/vdLMD3Kyin4soDoAsyRo0lyNSeTXmpS87sdmSP7Gy+uK0eaO
         m9XA==
X-Gm-Message-State: APjAAAVtOWH0Rk/T3r2p8gW1se8BFqqL9GG9DMeF8xpYijzhObysHkvR
        /8Ez9ps7y8OOLYFokI2l3tQ=
X-Google-Smtp-Source: APXvYqwjRQKJbnKvoGRraGKK+uddQbhZSDSsyMoT0QUmY17GYeg/rfKWhAjfQGNBQBellTNpJtUxNw==
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr3008886wmc.21.1560420907263;
        Thu, 13 Jun 2019 03:15:07 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t63sm3106418wmt.6.2019.06.13.03.15.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:15:06 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] tools/lib/traceevent: Change user's plugin directory
Date:   Thu, 13 Jun 2019 13:15:03 +0300
Message-Id: <20190613101503.22105-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613101503.22105-1-tstoyanov@vmware.com>
References: <20190613101503.22105-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To be compliant with XDG user directory layout,
the user's plugin directory is changed from
~/.traceevent/plugins to ~/.config/traceevent/plugins/

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile       | 6 +++---
 tools/lib/traceevent/event-plugin.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3292c290654f..fad5e5c2ad52 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -62,15 +62,15 @@ set_plugin_dir := 1
 
 # Set plugin_dir to preffered global plugin location
 # If we install under $HOME directory we go under
-# $(HOME)/.traceevent/plugins
+# $(HOME)/.config/traceevent/plugins
 #
 # We dont set PLUGIN_DIR in case we install under $HOME
 # directory, because by default the code looks under:
-# $(HOME)/.traceevent/plugins by default.
+# $(HOME)/.config/traceevent/plugins by default.
 #
 ifeq ($(plugin_dir),)
 ifeq ($(prefix),$(HOME))
-override plugin_dir = $(HOME)/.traceevent/plugins
+override plugin_dir = $(HOME)/.config/traceevent/plugins
 set_plugin_dir := 0
 else
 override plugin_dir = $(libdir)/traceevent/plugins
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 8ca28de9337a..82065881458a 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -18,7 +18,7 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
-#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+#define LOCAL_PLUGIN_DIR ".config/traceevent/plugins/"
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
-- 
2.21.0

