Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E432BC433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DEE2087E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXzYAfug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfHAHuI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:50:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50376 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbfHAHuI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 03:50:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so63550001wml.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Aug 2019 00:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHqZrtGNQYN/qI3hapu35cvs2EXgA/Fjb3EpFIfyXmo=;
        b=oXzYAfugpF8ZqqoIV9syFzYR2os+OXK/ItW7X3EWg7kXpXXqz/IMc6umIivjgzk7E1
         hnzC1zbt8jWA18dGGK3iKnDumlRre8i8FiQovDaTF0/kulcJfojl+N+byJxaijPAfs4t
         HKeZzW7MUJNQYOiTXBxpJ9o3sDxZ4ivyyfFMt2nWgGg2iq4N7/yX3vQ7S1f5HJStBhqz
         zCQKHZDouV6i+fY1f7HTt06ZwgvttfUcJ9aT7yCdt910p25NzTYdT4lWiHxatf+uqXsi
         trPW3bLWPpy/gZmF2xqHfgle+24FbQgJt9RLu3gch45NB6p518X5ajYbz/3Aeq9Qztvn
         fqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHqZrtGNQYN/qI3hapu35cvs2EXgA/Fjb3EpFIfyXmo=;
        b=qtMJPFmVk3tcblssFvm1yqOHK7HmxvGmxU0jx+jlI620wPF7JrtnMggVwf1V3oRSzE
         0+jCEQjn8fzV/ds5RiovEcrNYYcWqFb+ORNMeLPlHvNEDIAqd7rB78I/gvPYLNViutUb
         KZHG/0lFWAu7gqzUtU5PVil5ndftQ0B9HXDjLs0WjRRBJqy5H/8AbPabqsH0Suljlmlk
         QctDhGzXGFKYUuHym1fqltqNKHUqs2X8YEE5m0moxDWbGhgxpiNxJGwJwhLJgaTDhqDn
         lKTe/CsYfoL+s4itDH/ndgBXpLVHkTwm664MplpU8kzsIo9/gimsLMRMe5L6qB9eJjTv
         SKXQ==
X-Gm-Message-State: APjAAAVkVE1LzuwrATTJGzDqloZcMa+/R3/cCcw4LrMBbrIPo86OSIx8
        AJ5CkfTLhkiKGEkgs0ueiCNpLeaYIt4=
X-Google-Smtp-Source: APXvYqx0h5aeORwCd7H6xcxN8sxqJqUQRBfsU/LD6R8pNfcbBFd18Z468mmysFl45k5ImtNOJ+S1oA==
X-Received: by 2002:a1c:e715:: with SMTP id e21mr117893045wmh.16.1564645806324;
        Thu, 01 Aug 2019 00:50:06 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm4033483wmc.3.2019.08.01.00.50.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 00:50:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/3] tools/lib/traceevent: Change user's plugin directory
Date:   Thu,  1 Aug 2019 10:49:59 +0300
Message-Id: <20190801074959.22023-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801074959.22023-1-tz.stoyanov@gmail.com>
References: <20190801074959.22023-1-tz.stoyanov@gmail.com>
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

