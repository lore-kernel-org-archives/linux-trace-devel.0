Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746D2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531D0613E7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhD0Q02 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238912AbhD0QZh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:25:37 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882AC061357
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z5so34182502edr.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktS8d29WmI4vDBg3JU2EubAOGZVHG93P5flV+mY3KXY=;
        b=vf4i5yoT2ebu+BknXlM4nArSjRn1IXtxkvHp5k3uBwshxtbhnfumJ+FT8scfJbjL8P
         RDyc9sZOYHj2IsXqjK9pz21cY/oZbeAb8KSVitoT2xr6awQPs+qfw35e69vGc6U6V/bt
         iOnXsQoNvXGdrupebyb0K2U5DC7jZ1Fu+ZDTLJzm4id+QzuuKCj+CoRCcQ+AHZBBvP4v
         xAzLGiBMlPOwf8vaybIKpW2Px7qP+dOoFxXf+qoZOkpfY9yr+DPCEnrNOcKVF/j9yMSk
         +w++327YwZoWgLQaqKuIqPJYed38kd1oxAUpjz9IXALPp6ikAdogV2ZnBfiWnc9gsXZ1
         akFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktS8d29WmI4vDBg3JU2EubAOGZVHG93P5flV+mY3KXY=;
        b=IOcYkN2kRv7yJXBuBRfDGbA/a3IOACpJy6T6G8989N+UIu0xV4wP/LWJEvJaIR555F
         Ckbg3x5BbmG7Yi6Zf5yqzoE+txtyAPkbkMUXG5Ga6W6bPgcpLBk71RpnqPqYJcBnAwlv
         cfnbDQxDSrO7a3MiXsufXeigrbhAczApu7US9BjYcAXYL3H+suY89win9DOzktkhj0BC
         R+cY0Kqlo/pOq576OwpU/Bp9CW03a+IkUsOU5YAgyBJjBHijRbAKaZfjJYHJr0eBQi7z
         50vMkjoxbRyoa1+KNQ7bAGr/P5YVlVnQwkHM5tiQWytf84ztiKRSLE5MV9R+Nh58f3A/
         +3UA==
X-Gm-Message-State: AOAM532HgOQ+f4ksuqghUqokoo0Vj3X9wLwSZF0+bnOpUSCwpNzw41XD
        +EXWc7yD/lvAmEZW9YNF4N6XD868ueY=
X-Google-Smtp-Source: ABdhPJwYRQgJy3hAAtUMaSMsnljCpM8NH/CmF9J5N43GPJJmLjNAO9JvOn+/PM2mmG8l/pZfLdAgGw==
X-Received: by 2002:aa7:d5c7:: with SMTP id d7mr5505599eds.114.1619540664328;
        Tue, 27 Apr 2021 09:24:24 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Subject: [PATCH 1/7] kernel-shark: Fix the build for 32b systems
Date:   Tue, 27 Apr 2021 19:24:02 +0300
Message-Id: <20210427162408.134001-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
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

