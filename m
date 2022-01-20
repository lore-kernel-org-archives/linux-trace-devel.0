Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F28C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Jan 2022 11:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiATLeW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 06:34:22 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:40806 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiATLeW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 06:34:22 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 37D07218D9;
        Thu, 20 Jan 2022 11:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642678461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eCqPo8wEljdRWIUHFPbc1bLU00MoAIWaEwtdp4cvV4=;
        b=VxhnWO+tZ5xZdTzryywqYaMgUwHFbZLG+YCp0o6AjB0PtP0usewpB28THu7m6UZlnDLouB
        A/TwStNkOmOsnrSgu+IVxrceVkaHBMXjhIiYnkUiOjdzMlYrDWn/gdCIlcXyHFxq2ANtMY
        gCFP2hBwOi6rbHT1v/JsohY9E8PQtAM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 095B713E46;
        Thu, 20 Jan 2022 11:34:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bsBzO7xI6WGRRgAAMHmgww
        (envelope-from <dfaggioli@suse.com>); Thu, 20 Jan 2022 11:34:20 +0000
Subject: [PATCH 2/2] libtracecmd: use major version as SONAME
From:   Dario Faggioli <dfaggioli@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date:   Thu, 20 Jan 2022 12:34:20 +0100
Message-ID: <164267846050.9929.8644383666340215448.stgit@work>
In-Reply-To: <164267787600.9929.14996075092071019143.stgit@work>
References: <164267787600.9929.14996075092071019143.stgit@work>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, the SONAME of libtracecmd is libtracecmd.so.0.0.1, which
is legit and overall fine, but slightly inconvenient for packaging.

For other libreries, like libtraceevent and libtracefs, it is set to
libtraceevent.so.1 and libtracefs.so.1. Do the same here

Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
---
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile |    2 +-
 scripts/utils.mk       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 1760031..c9d36d1 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -55,7 +55,7 @@ $(LIBTRACECMD_SHARED_SO): $(LIBTRACECMD_SHARED_VERSION)
 libtracecmd.so: force $(LIBTRACECMD_SHARED_SO)
 
 $(LIBTRACECMD_SHARED): $(OBJS)
-	$(Q)$(call do_compile_shared_library)
+	$(Q)$(call do_compile_shared_library,$(notdir $(LIBTRACECMD_SHARED_VERSION)))
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 53b2b07..3fc2d74 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -72,7 +72,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
+	$(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\


