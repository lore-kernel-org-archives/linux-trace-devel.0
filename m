Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8EAC3A5A5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EE7F23431
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dalcjEJz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfICNex (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35811 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729097AbfICNex (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id n10so7620092wmj.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 06:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KlyJC//4t9uyXIA+1WUyo21KizWqqhloWOCnki7piOA=;
        b=dalcjEJz5v0eKvS6CTNmbBlIw37O1lJv9+Qmj3PccdYukR+JhRyE5bnoVPm5muyQOn
         uYiDBnt60xhGAvvRoWQwgY+DuQ3XvG67rdvqEgGdOovFQ8SIBtEkMm4hxkuxPIRfJM3o
         EPgPo/MRWUfl59LfWLFadhBF/I7EocOtmQXL6ImzMKgtXoqQg5LI7ObbFqRI6p+BvHMu
         uJolVImjBMFPcwUajXzbCBgXM/PjZqI8eroVs8g13NcRJ3KJfhaDsXjwikN7oUHhYxOU
         nmn6AmemOcSPmS/MnOWEHZVW0hCqDYM38zF+crzUWqf+62hZ3EuqJfywfSADhSH+7NZZ
         vybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KlyJC//4t9uyXIA+1WUyo21KizWqqhloWOCnki7piOA=;
        b=KjqgUW3qaSfKWIP+TnW8qv6/sk43Rv1paAe1C7qmVEDqBA+uJbhHgYPh8UV89u3cQK
         mBiffbrhl01vstaRjRf89F36X1Do5cA5Gs5/68TFxGGeP5el1dssVCOddD874QogfaQZ
         WkC/FOOhAJCk62kVAut4/0ceVNvtxHDCNYEzTNwrk7MpD/SmTfdGesLH6VIZh9VCHonL
         vNb1dZurY+AU/iGuZfFG4dWIjZDWvR4q9hzQlSw4fNfW4G9bB2lQ0LLhtp/PCiVrysPj
         ELrxMMuTDXq3fjekcjMtdO1LjaBt7pJ4h+O52Aa+g+awo7lQm7Wz9ydE5Rt1BSPm4L6M
         kjRA==
X-Gm-Message-State: APjAAAXneKbdUXaq0kYMBHUDxffsrB4GOfqIE7X6xFblF5SBVsN/FQl6
        KUUYc/px4Y7iU7XNGfK0GwymVls7
X-Google-Smtp-Source: APXvYqxg45ga8MVNwAcXiiJs1cEtkXNCpvcGeHgCWAceZyEGFI7Iw+3cuNkIc8XX9GXuVE8bQML91g==
X-Received: by 2002:a7b:c761:: with SMTP id x1mr67347wmk.100.1567517690960;
        Tue, 03 Sep 2019 06:34:50 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r16sm33509833wrc.81.2019.09.03.06.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:34:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/4] trace-cmd: Update descriptions of "debug" libtracecmd APIs
Date:   Tue,  3 Sep 2019 16:34:45 +0300
Message-Id: <20190903133445.30486-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903133445.30486-1-tz.stoyanov@gmail.com>
References: <20190903133445.30486-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The description of "debug" libtracecmd APIs:
 tracecmd_set_debug()
 tracecmd_get_debug()
does not match the functions. There was a copy leftover from
"quiet" APIs.
The name of the local static variable is changed form tracecmd_debug to
debug, as it is not visible outside of the library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 +-
 lib/trace-cmd/trace-util.c    | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index de3183d..3c5e827 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -49,7 +49,7 @@ enum {
 void tracecmd_record_ref(struct tep_record *record);
 void free_record(struct tep_record *record);
 
-void tracecmd_set_debug(bool debug);
+void tracecmd_set_debug(bool set_debug);
 bool tracecmd_get_debug(void);
 
 struct tracecmd_input;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 6e2a352..6a53004 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -29,7 +29,7 @@
 
 int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
-static bool tracecmd_debug;
+static bool debug;
 
 static FILE *logfp;
 
@@ -101,23 +101,23 @@ char **trace_util_list_plugin_options(void)
 }
 
 /**
- * tracecmd_set_quiet - Set if to print output to the screen
- * @quiet: If non zero, print no output to the screen
- *
+ * tracecmd_set_debug - Set debug mode of the tracecmd library
+ * @set_debug: The new "debug" mode. If true, the tracecmd library is
+ * in "debug" mode
  */
-void tracecmd_set_debug(bool debug)
+void tracecmd_set_debug(bool set_debug)
 {
-	tracecmd_debug = debug;
+	debug = set_debug;
 }
 
 /**
- * tracecmd_get_quiet - Get if to print output to the screen
- * Returns non zero, if no output to the screen should be printed
+ * tracecmd_get_debug - Get debug mode of tracecmd library
+ * Returns true, if the tracecmd library is in debug mode.
  *
  */
 bool tracecmd_get_debug(void)
 {
-	return tracecmd_debug;
+	return debug;
 }
 
 void trace_util_free_plugin_options_list(char **list)
-- 
2.21.0

