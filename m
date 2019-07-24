Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D8CC7618B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF675206B8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EgjqJISs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfGXPlD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 11:41:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41168 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfGXPlD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 11:41:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so44293992wrm.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 08:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3/2koJsAEbjHIuBnamymnthhFIJO79KbyPc3HmVywUc=;
        b=EgjqJISsJt7qGgBefLI6r2OpFTNIq+1I5w8cspIabIDP8DJVJcXslL7ptUiTSLlEsh
         NIxCi9kn4KV58yXgjQXXd7G2F8oigG/lsemJTTeNxIOaTrYj9x8Xkdj3Wzj6LLdpKFrs
         rVNBCgj9D7f9CNiEQK7jH1nSv+AMdIh+XkxNI5WB+QRbNH05cNZp5TMhKYz+MdAHBB66
         kRinDS055ZDccDkixNtTtDASPya4MKa6863naHOrEHnFftftr8HZqCaH2ADGRtpZqgR4
         ul8GvTlyVstTwk/J4lkd0yYphgRkC2KpNm/aatno2b2domV6TcY4IcVAfdbOsYXKK+va
         FOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3/2koJsAEbjHIuBnamymnthhFIJO79KbyPc3HmVywUc=;
        b=nr/vr+w0J4jFcOAVOVXMVcrqZoudG0HFW06rR2vqrJ3W7/330ZQrpmQmQES9tW/EG3
         wvqcIoxNfUTMzmLeen41XbxZLW1+FXQk41DFpVPg84qwYCTEgGMQlR/9wHWnqQmoG+G0
         V+3ZIXd+CT7QEOJNgmIlbX5eMNIfZMRhe1qkSJgfp+g+dWrWQ97Q33S9mbP1qJAtISDC
         CiMD5zHro3N2zUwWykq19jnUGU6nZI1IlEqWlzRIyFfI1eDAZzKiC7Obufk66sZZoO0x
         aAcK45yEPjoMDxSHqco+gX0kHazHR1SCD85bUej65M7vj3X8RSc8dSlklpL1Zmi0mMYC
         TN7A==
X-Gm-Message-State: APjAAAXid+lqRFpFcBd4Azq/6b6CrYSUOBmYhtgsTjdXwbVDP1aiACSi
        reCERFfHrdKWXs+k+f+AsXg=
X-Google-Smtp-Source: APXvYqwd/YYbJ7xcFuBYIwDClWz0b1PQ3RzxXX81JbsHWK1wlxLeeK8P8LqIqMYfriTYh7N5Y1WKlw==
X-Received: by 2002:adf:f046:: with SMTP id t6mr3188786wro.307.1563982861826;
        Wed, 24 Jul 2019 08:41:01 -0700 (PDT)
Received: from localhost.localdomain ([95.87.223.238])
        by smtp.gmail.com with ESMTPSA id a64sm45510570wmf.1.2019.07.24.08.41.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 08:41:01 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] kernel-shark: Handle corrupted configuration file for the Capture dialog
Date:   Wed, 24 Jul 2019 18:40:39 +0300
Message-Id: <20190724154039.23705-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724154039.23705-1-y.karadz@gmail.com>
References: <20190724154039.23705-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Error message will be printed to the console-like widget.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 02bbbbc..addd41d 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -201,6 +201,9 @@ void KsCaptureControl::_importSettings()
 	tep_event **events;
 	QString fileName;
 
+	auto lamImportError = [this] () {
+		emit print("ERROR: Unable to load the configuration file.\n");
+	};
 
 	/** Get all available events. */
 	events = tep_list_events(_localTEP, TEP_EVENT_SORT_SYSTEM);
@@ -210,21 +213,27 @@ void KsCaptureControl::_importSettings()
 				    "Kernel Shark Config files (*.json);;",
 				    _lastFilePath);
 
-	if (fileName.isEmpty())
+	if (fileName.isEmpty()) {
+		lamImportError();
 		return;
+	}
 
 	conf = kshark_open_config_file(fileName.toStdString().c_str(),
 				       "kshark.config.record");
-	if (!conf)
+	if (!conf) {
+		lamImportError();
 		return;
+	}
 
 	/*
 	 * Load the hash table of selected events from the configuration
 	 * document.
 	 */
 	jevents = kshark_config_alloc(KS_CONFIG_JSON);
-	if (!kshark_config_doc_get(conf, "Events", jevents))
+	if (!kshark_config_doc_get(conf, "Events", jevents)) {
+		lamImportError();
 		return;
+	}
 
 	eventHash = tracecmd_filter_id_hash_alloc();
 	nIds = kshark_import_event_filter(_localTEP, eventHash, "Events", jevents);
-- 
2.20.1

