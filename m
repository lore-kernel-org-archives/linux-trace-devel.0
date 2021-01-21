Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EB7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA52233EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbhAUKhK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbhAUKg4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 05:36:56 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B71C061793
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:12 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l12so1220209wry.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=45zabsS/ucuivpVh2hX1/UprI4Hh21/Ixb2hCzME/38=;
        b=XQ1t9nuDWKulTPV72OKkdias0upBg4A/zouj8lNopHt4xjFsYVHqvnX7q2pC1oBhhb
         SSL3trUNPnMOEd4LNlYk3gUT5u5RG96CCKL/uD/YIlUAom85edRYUxCCT+Rjkp/wDvQp
         iXkBxbu7wPGBxS9aVYOyDh/dTlgr6rL5UnlO46yQ1CBTZvtBYJtLJ3iheq6EpahNYh5u
         RKBZRidFq7goB70mwDx7TV6irctI0rOi0HH5Oknru/WB27JBxfnAHaqEtJTNa+9gcyK6
         osAGasZ+T4uyw5MRsUt/82QHm/hqxvpYqy7nsL/ygz3nMTYVWA8Lh1LohT9WZ2HNQ8XA
         7r/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=45zabsS/ucuivpVh2hX1/UprI4Hh21/Ixb2hCzME/38=;
        b=lXSTZ0YF+FzHknk9fZKrxrkEWzwSEuKaVnypUeJt/VW81lJ9xRrZuEngRgGZDRqMEw
         N+1YIX8Az5B8FALLZ5O1sLB50rpjNva7gyt37Bt/3P1uPNbzhBjjAyXIYmp4mAjTOIVM
         nPd1LX+buMM7SX8q6LofJuEcQFXcC3jmKhn/ZTV4l0LEGn4XI0gLSE8O//lr4sWZa5yD
         5pewFS/08U64NxuA6XU4gSlCDsEjmrfssWPlG5MytPNtcN+u+q7R3202Nx9UjuV/mQvy
         4iEpkb+JX6YDdaRqB0eCfgqfpz/ql7DmvOyFjaBwKrS+nUfptT7Yhkaw2ZUfaI0XgY0k
         htoQ==
X-Gm-Message-State: AOAM533jIHYRvESwlu+7UHhDWTdhkdJhqWPcYA5YpEhAso+xQbuI7UF/
        +rWHjeFLEWadHDyuohsrPvQ=
X-Google-Smtp-Source: ABdhPJxYLTtPYBWA/b7qqQ95RbyA3nUyg+xxVn7fh1rnyx2W+cf4F5l8fbBNwGVhb8gI+s5nwED9Xg==
X-Received: by 2002:adf:f512:: with SMTP id q18mr2178393wro.55.1611225371693;
        Thu, 21 Jan 2021 02:36:11 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm7294123wme.37.2021.01.21.02.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 02:36:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd library man pages: Extend the examples of reading host-guest trace data
Date:   Thu, 21 Jan 2021 12:36:05 +0200
Message-Id: <20210121103605.224108-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121103605.224108-1-tz.stoyanov@gmail.com>
References: <20210121103605.224108-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd library supports reading trace data from a host and
multiple guest machines as a single trace session, if they are recorded
at the same time. Added more relevant example in the man page, showing
that use case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-peer.3.txt        | 56 ++++++++++++-------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-peer.3.txt b/Documentation/libtracecmd/libtracecmd-peer.3.txt
index 5cb0c4fa..6cf34f9b 100644
--- a/Documentation/libtracecmd/libtracecmd-peer.3.txt
+++ b/Documentation/libtracecmd/libtracecmd-peer.3.txt
@@ -74,36 +74,54 @@ EXAMPLE
 --
 #include <trace-cmd.h>
 ...
-struct tracecmd_input *host = tracecmd_open_head("trace.dat");
+struct tracecmd_input *host = tracecmd_open("trace.dat");
 	if (!host) {
 		/* Failed to open host trace file */
 	}
-	tracecmd_init_data(host);
 
-struct tracecmd_input *guest = tracecmd_open_head("trace-Guest.dat");
-	if (!guest) {
-		/* Failed to open guest trace file */
+struct tracecmd_input *guest1 = tracecmd_open_head("trace-Guest1.dat");
+	if (!guest1) {
+		/* Failed to open guest1 trace file */
+	}
+struct tracecmd_input *guest2 = tracecmd_open_head("trace-Guest2.dat");
+	if (!guest2) {
+		/* Failed to open guest2 trace file */
 	}
 
-unsigned long long guest_id = tracecmd_get_traceid(guest);
-int *cpu_pid;
-char *name;
-int vcount;
+unsigned long long guest_id_1 = tracecmd_get_traceid(guest1);
+unsigned long long guest_id_2 = tracecmd_get_traceid(guest2);
+bool g1 = false, g2 = false;
+int *cpu_pid_1, *cpu_pid_2;
+int vcount_1, vcount_2;
+char *name_1, *name_2;
 
-	if (!tracecmd_get_guest_cpumap(host, guest_id, &name, &vcount, &cpu_pid)) {
-		/* The Host and a guest with name was part of the same trace session.
-		 * Got guest VCPU to host PID mapping.
+	if (!tracecmd_get_guest_cpumap(host, guest_id_1, &name_1, &vcount_1, &cpu_pid_1)) {
+		/* The Host and a guest1 with name_1 are part of the same trace session.
+		 * Got guest1 VCPU to host PID mapping.
 		 */
-		if (!tracecmd_pair_peer(guest, host)) {
-			/* Successfully paired host to the guest handler */
-			tracecmd_init_data(guest);
-			...
-			tracecmd_unpair_peer(guest);
+		if (!tracecmd_pair_peer(guest1, host)) {
+			/* Successfully paired guest1 to the host handler */
+			tracecmd_init_data(guest1);
+			g1 = true;
+		}
+	}
+	if (!tracecmd_get_guest_cpumap(host, guest_id_2, &name_2, &vcount_2, &cpu_pid_2)) {
+		/* The Host and a guest2 with name_2 are part of the same trace session.
+		 * Got guest2 VCPU to host PID mapping.
+		 */
+		if (!tracecmd_pair_peer(guest2, host)) {
+			/* Successfully paired guest2 to the host handler */
+			tracecmd_init_data(guest2);
+			g2 = true;
 		}
 	}
-
 ...
-	tracecmd_close(guest);
+	if (g1)
+		tracecmd_unpair_peer(guest1);
+	if (g2)
+		tracecmd_unpair_peer(guest2);
+	tracecmd_close(guest1);
+	tracecmd_close(guest2);
 	tracecmd_close(handle);
 
 --
-- 
2.29.2

