Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5311C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 13:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbhLPN3z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLPN3z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 08:29:55 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24BAC06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 05:29:54 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a18so44247671wrn.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 05:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hde3NihipFRCRqBjpMSzAR7jR2grbVl4uek6zfQHXvA=;
        b=cgugtJ5E/22t+Y4NEjDHaswj8hUqnTBBkXUyx7jat1+V8SH6p2Ud802GmN4Qv+SpZw
         Bvi4vnqpoDKjxsCj6yMNl0Ky2tWgXbcTrsIhky7VP0pfHKEFEGDsxQ9suluKfGmY1H0T
         tAtR6a38iKEjYRgukgfgkWP7R/oCuFRzUCq7ryGYOkmyPMEZ2z3ZIlf5FFz4BTWPG7xe
         ETEyxfRRmSqt3VBPsGXrtKAHHPD4NxFeDkgUNNkBpJrXHZrsKiQFiESUvGTrAsPL5+Yz
         1avtrGlMJzmJ/BoKi+buSnFXoPMTIg7fDHGa3WQAyS3ZUQCnTDLYnowNpbtb1LuOo6kb
         hJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hde3NihipFRCRqBjpMSzAR7jR2grbVl4uek6zfQHXvA=;
        b=W/JjzITfIj/Ifr0vxWnKswSbY+8u4Qp2dQBzoBn7kG2PrdnXhYs+3RKDtCSAnJpQKY
         pJ9yWylA6++CONX6MJYXO4C1nWfNOoAwaqdRROZz42QpC5/rQAf11wpVVWffy2Bfbs32
         UhHBYbgHkYOHOl3eHuXLl9hUGpQjEYA51iRxF42xpx4bw+9e1ucy2rGBnt8pYMJDQoQZ
         FWLKVafuZH+OJlP43W2hkt3fxA7XmIeybZ2nSCFsAxBWZYkCU7hD+lpfN3fy3uYYiqMT
         Bs7FtX4fe8gXB6rVLQ4dde6XA8fUCHMsJ+OOPzZfwIgUS3r9W/Ebd6KkRxxyjLASurE+
         um1g==
X-Gm-Message-State: AOAM533cKEbJB7XQLBEuQlYnCvbLQxaRzXOU/EI5YJ5R8X8RglB3eGQw
        SOEXTCSDFPpmBRJpKKhZJM0gc7uDmv4=
X-Google-Smtp-Source: ABdhPJwTtU+n+HaVWFkDDWcsI4Qi3L4jBSbh0oKERbs4QEzyeU/Daok/0kGFZRCxG7siV+yqa1oa9Q==
X-Received: by 2002:a5d:4d4f:: with SMTP id a15mr3600566wru.268.1639661393231;
        Thu, 16 Dec 2021 05:29:53 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l5sm5608931wrs.59.2021.12.16.05.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 05:29:52 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Fix segfault in PyTraceHist_read()
Date:   Thu, 16 Dec 2021 15:29:20 +0200
Message-Id: <20211216132921.239628-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A NULL pointer can be returned when reading from the 'hist' file
of the event. This may happen if the histogram is not initialized.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index a735d88..1b1f350 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -978,6 +978,9 @@ PyObject *PyTraceHist_read(PyTraceHist *self, PyObject *args,
 					      PyObject *kwargs)
 {
 	char *data = hist_read(self, args, kwargs);
+	if (!data)
+		return NULL;
+
 	PyObject *ret = PyUnicode_FromString(data);
 
 	free(data);
-- 
2.32.0

