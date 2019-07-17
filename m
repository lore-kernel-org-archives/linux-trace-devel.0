Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60219C76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 08:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B3A217F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 08:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7O5vrYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfGQIxl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 04:53:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55424 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfGQIxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 04:53:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so21271462wmj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2019 01:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hZsbXSzkaL5uC/+rz+3t2VLv0xFcqNvTyg6Ul4E7X/U=;
        b=I7O5vrYfnkB5rH8/DwtWi1x+dEj05AhmHU3jZskzZFHYI7LAZXpivXtbegQIU6WW3r
         mw4QlfQlhUKMYA+GzQOdQaIRWd1eIRTtyu/UNGNV/Nixo1k1l6f/hnUu3PdJP6zHuukn
         Ys918kY/olpDWwXq8VvAC00AJt3M0R0KEcwWh1bF5tUpXOukhq+VOyiEGHRrh+aYcQae
         wxuqRESyY2T9hlwMSz13SDLdiEad1cBXASQMQCtyod+UCOYR7HhVAk4hZfi4A7XzQ+31
         gOes4dcrh0Furq2acTtNiTArpIy1BGQ4l9mX4KIRrz/4TrgLaHT6aopV6M6TRahUY8TG
         9e2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZsbXSzkaL5uC/+rz+3t2VLv0xFcqNvTyg6Ul4E7X/U=;
        b=awgXF3WCr7MljcSCps1ZYihVGa4Um5KC2UwAIu0kunHFefU3hP+nPQTYwPaKUkHxTY
         kov6QFRDS0etEJTnYWdYQAeE2tYNgkoMMno9R01iXpEP7b+f5PYaImT7mn67a1XgJrp9
         7fuB5dBoXlWQ4QJKAY1psJ/tHrGKn/lxQby7iQq94Wewm4r7DoYKj3P8d4+Nz3l+o96e
         /f8bAiSQcYerxwEinNyAMm8oaRw1UxA+EPqwufiDFQqwPVSf6lPSTaZjhg0LDbDswiUE
         Gi26GyDPcSBGK6xqlPxGCauKK9nh0+JTU6dbNae2WvLlQmP9cs2ZOAGUVw46y8Sxs2Yi
         Ps+w==
X-Gm-Message-State: APjAAAXqXTJf37N/Z3OIsJMd9vHEs/bC87jsZBU/BZOrfcQDBIceRhJg
        SDtpreopL3hvS2olUjWcXIc=
X-Google-Smtp-Source: APXvYqwOfVJm+bAF+TZOXKeO/mz9lLbc4rVm9W6CCkJmKBMlQURnswAA/yVEYsK6FuM5c1xzlbgKtg==
X-Received: by 2002:a1c:343:: with SMTP id 64mr30565890wmd.116.1563353620060;
        Wed, 17 Jul 2019 01:53:40 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w23sm24102127wmi.45.2019.07.17.01.53.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 01:53:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Initialize the data-related fields of the model
Date:   Wed, 17 Jul 2019 11:53:05 +0300
Message-Id: <20190717085306.12393-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190717085306.12393-1-y.karadz@gmail.com>
References: <20190717085306.12393-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It is particularly important to initialize to zero the "data_size" field
because its value is used when doing operations like scroll or zoom to
check if data has been loaded or not. Not having "data_size" set to zero
can cause segfault (as reported by Steven).

Reported-By: Steven Rostedt (VMware) <rostedt@goodmis.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204195
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-model.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 18f9c69..fd4d876 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -36,6 +36,9 @@ void ksmodel_init(struct kshark_trace_histo *histo)
 	 * Initialize an empty histo. The histo will have no bins and will
 	 * contain no data.
 	 */
+	histo->data_size = 0;
+	histo->data = NULL;
+
 	histo->bin_size = 0;
 	histo->min = 0;
 	histo->max = 0;
-- 
2.20.1

