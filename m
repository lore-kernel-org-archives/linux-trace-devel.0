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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEAEC7618B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A023C206B8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pR8vFzbw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfGXPlC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 11:41:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35013 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfGXPlC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 11:41:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so42042732wmg.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAyL3MWEZNKJtev3DFSSTOy/cq19gunvIHzpfuWlMyY=;
        b=pR8vFzbwzcnGxkEHu//Uw4xL8pkrrjxZqQpbdI2g7qolA9yhuMx9s53g4Ag4uzof9q
         7OTHn0EmektghMv8RTVTGL31ikj5BeDpDfKm5sj3g6egJeJ71ju/M9GGKUDYQ38+HOpM
         ovuYKZ84+F7rHa7giW66aROPHVMzN81ysdOvtdvTgWIo602jZ6JNYaaOCGyQIKam2+eF
         SSfwNvzvqNcF7bGgfR+s1lgOzpZdTi7F468Nsh/ndXVPbj/YaUQ3I675I03uNTt68E+C
         3UMxJKV2/fMCMDrJzVlAmTN25uXq36kArk3RUrLddrLu/WfdGlOkA9oRxUgnGiZKCan7
         /4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAyL3MWEZNKJtev3DFSSTOy/cq19gunvIHzpfuWlMyY=;
        b=VMUKTW7uvtclK2pWqXVj1ualYtm0o/0ZQ1w57aAe5U0q2Pes43bj9exUL+sB7YRRxd
         jf24ueIerC0EAIPWU8U/DB8qIBd219tMU6cFzp0+hsX9Kno+ZbpV1Fv0wXmkBzbmQder
         Sjq/gh7QEQuluhYxav+8Nd/3+VFjT811AXJAEZUWGwV+Q9li0CUcLK/jOkDDDycVADxm
         hl+GroalFwNRrydCoEv1BevVQoTJMWoAqFGWQI6xt53me3FBm7Yo34VTHEJHnnV14TFu
         xq7Y7AEpNkXtm6nX4kTHPRYa94Bxrf16g0he1cOAiHxpZrlN2ElZY+TcegZudBHtKFY9
         k+Tw==
X-Gm-Message-State: APjAAAUfHB9SIUia9hrL8YNplou4CzwkRx9bq+mK+9jEPng6U8P6wwGw
        wCOC7cEXisaNeeaJr4I0uqVxSNxb
X-Google-Smtp-Source: APXvYqyOXm80uIrxYf9RB6q6NieDfKWon6yqoU8bWxmIF1V1UUD4TMgK2OMRtDkoSzRv0VwmphoYhQ==
X-Received: by 2002:a1c:3587:: with SMTP id c129mr77503124wma.90.1563982860466;
        Wed, 24 Jul 2019 08:41:00 -0700 (PDT)
Received: from localhost.localdomain ([95.87.223.238])
        by smtp.gmail.com with ESMTPSA id a64sm45510570wmf.1.2019.07.24.08.40.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 08:41:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Handle errors when loading Capture configurations
Date:   Wed, 24 Jul 2019 18:40:38 +0300
Message-Id: <20190724154039.23705-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724154039.23705-1-y.karadz@gmail.com>
References: <20190724154039.23705-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A configuration file (Json) for the Capture dialog can contain
non-existing tracer plugin or events. This can happen if the
configuration was exported on one machine and then imported on
another. In such a case the non-existing plugin/events will be
ignored and a warning message will be printed to the console-like
widget.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 6e526ff..02bbbbc 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -194,7 +194,7 @@ QStringList KsCaptureControl::_getPlugins()
 
 void KsCaptureControl::_importSettings()
 {
-	int nEvts = tep_get_events_count(_localTEP);
+	int nEvts = tep_get_events_count(_localTEP), nIds;
 	kshark_config_doc *conf, *jevents, *temp;
 	QVector<bool> v(nEvts, false);
 	tracecmd_filter_id *eventHash;
@@ -227,7 +227,14 @@ void KsCaptureControl::_importSettings()
 		return;
 
 	eventHash = tracecmd_filter_id_hash_alloc();
-	kshark_import_event_filter(_localTEP, eventHash, "Events", jevents);
+	nIds = kshark_import_event_filter(_localTEP, eventHash, "Events", jevents);
+	if (nIds < 0) {
+		QString err("WARNING: ");
+		err += "Some of the imported events are not available on this system.\n";
+		err += "All missing events are ignored.\n";
+		emit print(err);
+	}
+
 	for (int i = 0; i < nEvts; ++i) {
 		if (tracecmd_filter_id_find(eventHash, events[i]->id))
 			v[i] = true;
@@ -239,8 +246,19 @@ void KsCaptureControl::_importSettings()
 	/** Get all available plugins. */
 	temp = kshark_string_config_alloc();
 
-	if (kshark_config_doc_get(conf, "Plugin", temp))
-		_pluginsComboBox.setCurrentText(KS_C_STR_CAST(temp->conf_doc));
+	if (kshark_config_doc_get(conf, "Plugin", temp)) {
+		const char *plugin = KS_C_STR_CAST(temp->conf_doc);
+		int pluginIndex = _pluginsComboBox.findText(plugin);
+
+		if (pluginIndex >= 0) {
+			_pluginsComboBox.setCurrentText(KS_C_STR_CAST(temp->conf_doc));
+		} else {
+			QString err("WARNING: The traceer plugin \"");
+			err += plugin;
+			err += "\" is not available on this machine\n";
+			emit print(err);
+		}
+	}
 
 	if (kshark_config_doc_get(conf, "Output", temp))
 		_outputLineEdit.setText(KS_C_STR_CAST(temp->conf_doc));
-- 
2.20.1

