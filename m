Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF536C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 11:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC9320897
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 11:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NnVSAfyn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgKQLWP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 06:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbgKQLWO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 06:22:14 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B71C0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Nov 2020 03:22:14 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id c17so22754593wrc.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Nov 2020 03:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oj8GD4JHTokTDBPRIIw2CyYmE5C0SGoO94kFGDeJDPg=;
        b=NnVSAfynLM8qj0i4o2qgwR82YAUuZPoUd/IVfWmDPgNGOjfw/jUAHIZd0goUCSfRIW
         lcLE6754x+ERbFDqWIgfAjbwR0Obj3/+K3StjfJAL6jolSYBqHIPtymexZlMrzV99MdO
         IqaLpYVFrldM/3Rkw0OnfzscStf54626Ra8B/3PnATAQBDLeYuCeV2ExA5GcIjo6fJB5
         TTqJDiMaJhg9FjuU0Tml0NOAKz2vQpRSUUWautTsOriDOjttd9B1A7l5WuUMyF94C/2q
         xZoKEE3dMvYguZpLvPrqR5FYonxVkLvlXcC81sHTYCqWuhslTLYbwlRuzpHppic0N7/r
         lGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oj8GD4JHTokTDBPRIIw2CyYmE5C0SGoO94kFGDeJDPg=;
        b=h1Udvn6lCkdNAwUwggoFGsajVmHvXoUrQRC5BZbz5mfXTCnNJhADBMWVVV6LUhmRNx
         /EceJLyshDJ6ZQkARh+gGsv/y6SW3QYa6S1HxvXdFbsnhEUy+4ojew4Qot3Pm7qFiGG1
         fkz6N/Zy3Ptt8VkqT8U2Wq0mlZItHtozOd4OKkkWanTnlwr3t2QkCJ7Kgm9HDd55xnnF
         zpz4lTfWC9Ul4Vc1FsiAD5Dl3rru0LXL+fEjtN9mavE4x0ZV+sVRA27NVVLkSOCsG4T2
         3v5Kw4VYj1NOccgnKSe4W5RzMMgCqb+rkkgG+Qq4DFc/PsJhrpW0pfTrzRrEOemjE2gk
         WiLw==
X-Gm-Message-State: AOAM532ARkYb0sS8d8kHaXhrXq4dg6d6U4VQXTcF0ebftY3WzZDtYOHj
        0hhscFjgZ3htIWoi8isUftv342b5/tum1MdH
X-Google-Smtp-Source: ABdhPJzGq/Wb0lwK/y9agnzHITBaHNMtG/3ANJHvrKRK5hT+SmoATUB0LdwQnXYVO2eUnRK8SSs9BQ==
X-Received: by 2002:a5d:414e:: with SMTP id c14mr19190331wrq.256.1605612133011;
        Tue, 17 Nov 2020 03:22:13 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q17sm31271790wro.36.2020.11.17.03.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 03:22:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, douglas.raillard@arm.com
Subject: [PATCH] trace-cmd: Parse command lines with spaces
Date:   Tue, 17 Nov 2020 13:22:10 +0200
Message-Id: <20201117112210.207985-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If a command line, saved in the trace.dat file, has spaces - it is not
parsed correctly by trace-cmd. Parsing is improved, so command lines
with spaces are displayed correctly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210193
Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 0ead96ea..bd09882b 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -63,7 +63,7 @@ void tracecmd_parse_cmdlines(struct tep_handle *pevent,
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
-		sscanf(line, "%d %ms", &pid, &comm);
+		sscanf(line, "%d %m[^\n]s", &pid, &comm);
 		tep_register_comm(pevent, comm, pid);
 		free(comm);
 		line = strtok_r(NULL, "\n", &next);
-- 
2.28.0

