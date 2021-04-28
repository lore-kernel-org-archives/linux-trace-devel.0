Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3397C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C2261158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbhD1Nsc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239909AbhD1Ns1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEAEC06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id n25so2207300edr.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktS8d29WmI4vDBg3JU2EubAOGZVHG93P5flV+mY3KXY=;
        b=amwgvvXEewVVgFDZoPWt7LJExDMLnwW3qfFb2eaOUT5Lu8rZq3VXbfmhc49qVGH88l
         cPYvp/zbzFYUzdoNWIBiPngcmCCm0AzTaZfhauSh9mlr0foBV/xBTOhHfAsjg3lw3O6s
         52oBRHpZmoHTz/Rz5cRmcBend4KxYDlio0GOQzR2Xqcrpi9HFawHDB5UX9gbphhEAyFb
         loyClkkbh51vRG5jzacS6hy50kuy6OSpsmgnrbJAAckJEF1hGQ5Pji7mRX2JJJ4aMwko
         0BvT6TJC4CuYOqtWYDlmH5o1+BeoZFhKfOumsjXNV4jwEfDuPBNjkpIKx+HZbF2n/Xaf
         0pRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktS8d29WmI4vDBg3JU2EubAOGZVHG93P5flV+mY3KXY=;
        b=L8HaVIyt6pfstVc5KxqP4xNNuXVxOrLwVDD+BYMvA5P1GlgGa7L92yXSbrOz3spva7
         jnhUhdToQ2Jzt3L3Ij/fVvTa/r/O0iDagZcPTIpdXG3S41rArT0UOyVEEhmO062T2rbN
         ha6vSY6kutyIVNHbLyMJPpctGVcV61TEy+Bj0cworyra1wD/q2dHrbxkajniie4zuQS2
         S9jrMVjOQ0lhEjWjijGUjtKz0+OmqWSDVoK7zpN3gwWIdF00y1NVoDYIQRe9OtpMzLvv
         KpHo2TjUxvWPzakrJMpMh2kUm939NBstu+IpJV+iTjJvQTtf7VLgKz6O63mFIrkeEwfe
         yQQg==
X-Gm-Message-State: AOAM532fc5xOKRkK7Nl8NeRseWa0qu5SRXFF2XqWOapIwpnO3tk0NFPd
        ifMxqot75HER80v0zmZKvvnV1g5fbsI=
X-Google-Smtp-Source: ABdhPJzZfseIjZ1By32k9O5u3NfuQJaTEoB0k0GZ3pVGWSoWMIdKjX3jDXomODJy1lifCEqN6mepLQ==
X-Received: by 2002:aa7:cc15:: with SMTP id q21mr11711833edt.140.1619617661396;
        Wed, 28 Apr 2021 06:47:41 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Subject: [PATCH v2 1/9] kernel-shark: Fix the build for 32b systems
Date:   Wed, 28 Apr 2021 16:47:22 +0300
Message-Id: <20210428134730.187533-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All warnings and errors when building on 32bit Linux systems are fixed.

Reported-by: Alan Mikhak <amikhak@wirelessfabric.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsSession.cpp        | 2 +-
 src/libkshark-configio.c | 2 +-
 src/libkshark-tepdata.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/KsSession.cpp b/src/KsSession.cpp
index 8d489f7..1e19a5f 100644
--- a/src/KsSession.cpp
+++ b/src/KsSession.cpp
@@ -587,7 +587,7 @@ void KsSession::saveDualMarker(KsDualMarkerSM *dm)
  */
 void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *graphs)
 {
-	uint64_t pos;
+	size_t pos;
 
 	dm->reset();
 	dm->setState(DualMarkerState::A);
diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index 98098da..9a1ba60 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -567,7 +567,7 @@ static bool kshark_trace_file_from_json(const char **file, const char **name,
 	}
 
 	if (st.st_mtime != time) {
-		fprintf(stderr, "Timestamp mismatch! (%li!=%li)\nFile %s\n",
+		fprintf(stderr, "Timestamp mismatch! (%" PRIu64 "!=%li)\nFile %s\n",
 				time, st.st_mtime, file_str);
 		return false;
 	}
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 4e76ef2..bc5babb 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1025,7 +1025,7 @@ static char *tepdata_dump_entry(struct kshark_data_stream *stream,
 			free(info);
 		} else {
 			n = asprintf(&entry_str,
-				     "%i; %li; [UNKNOWN TASK]-%i; CPU %i; ; [UNKNOWN EVENT]; [NO INFO]; 0x%x",
+				     "%i; %" PRIu64 "; [UNKNOWN TASK]-%i; CPU %i; ; [UNKNOWN EVENT]; [NO INFO]; 0x%x",
 				     entry->stream_id,
 				     entry->ts,
 				     interface->get_pid(stream, entry),
-- 
2.27.0

