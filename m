Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124F6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiBNICx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 03:02:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbiBNICx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 03:02:53 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346EB5B3CB
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 00:02:46 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id fy20so35484291ejc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 00:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MVaROyjWO19k2VSHBixHG/qbwSKq5TqmRuRy4iG5tZA=;
        b=o72nSsdi2/6SFo7Fw6bOP1DjzAAEMU3Qk62ZXIqch2VbciLYWc1IkKmq8XGMIsWwfF
         qvbbVa4V5GNpg0rJgJQcA0IXrR6L5Iv4Cl2dwIoSbwfYuezCFoLLjQUpx56oAw73KRXH
         USKt0qSr2/Yt6B4RwGaKW3gN3lM0o4p1yylWgtWJt30W6OiRQgbBGiLOzKitQnH/4QRN
         RDiVCDcP9fH8Be6DS2Gx1nGLYRyTIKysx1vQa5p+HYWuJPbHQce/QJPH/YlFf13kjEei
         wewoAXaqn/pKnfFNCfoqkjslrZeWtZp0Tv6/vf40gMRZHcJNP1SG86DHg7spaZfkcD/g
         nZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MVaROyjWO19k2VSHBixHG/qbwSKq5TqmRuRy4iG5tZA=;
        b=JNYamrAItmLKrZ/AnQ8HS3Jif+u+vKZx3SxWdftjjkuWFkllQTABScOptslVDmLCHp
         JaRtJnBM9lu1Riu+PASkgONkJSi/Sk0u0SU1YIJS/ammjr7s8jRsUBW6xb74pf7TeOFl
         0Y5dmf8P+JHFXTnwja0HhjE1oK0h6hcvrSJFvyuqFWMPYV4WuziGaoBn7jYqgn5awySL
         gRWtsFo3CxiTxtrP1vC7aDf/9W5jzUG84aB2F498Y5Jvx6VdZFcVSIZEJec5Z8uTpwZo
         i+sq90kh48V8nG0JLKUsZSn8BTvxE3JxsSItFLAeWW8Pk9bhMXfE1T8E9XUFaxh2Tnwa
         aBZA==
X-Gm-Message-State: AOAM531di4pKHUp4p+utHOU3Z4x/iaYHi3U7Jpe3fmPDwNOvaeewGBOP
        rfwnxpx/MZr90gs+5qBgLNAtevpbrPs=
X-Google-Smtp-Source: ABdhPJytQK0cLaGp9h6ZRc+pPhUaVm3/xLw1UgYmayEy30naM+sARuR9QvQVRhD/rdCLI34UtlXnuw==
X-Received: by 2002:a17:907:7251:: with SMTP id ds17mr10554819ejc.151.1644825764569;
        Mon, 14 Feb 2022 00:02:44 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 9sm2012685ejk.28.2022.02.14.00.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 00:02:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Add define for ALL dynamic events
Date:   Mon, 14 Feb 2022 10:02:41 +0200
Message-Id: <20220214080241.634290-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some of the tracefs APIs for dynamic events accept bitmask of events. If
a caller wants to address all types of events, it should list them in
the bitmask. This logic is fragile. When a new type of dynamic event is
introduced, the API callers should be modified. That's why a new define
is added, part of the library API, to address all types of dynamic
events.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 1848ad0..b3694cb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -261,6 +261,8 @@ enum tracefs_dynevent_type {
 	TRACEFS_DYNEVENT_MAX		= 1 << 6,
 };
 
+#define TRACEFS_DYNEVENT_ALL		0xFFFFFFFF
+
 int tracefs_dynevent_create(struct tracefs_dynevent *devent);
 int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
 int tracefs_dynevent_destroy_all(unsigned int types, bool force);
-- 
2.34.1

