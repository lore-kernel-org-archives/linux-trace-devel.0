Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96D0C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3C361A6F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353423AbhJANfn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353560AbhJANfm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:35:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F6DC06177C
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:33:58 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bd28so34784733edb.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4EjK5wzb7SYrY+vgWTVbp0U5AJvVCk4AwWIopyVM5II=;
        b=QyMl0QpNIWgL3hKhoiQ+7q+SNzftiqB68WMKBsgAboSB9hknYYSAbqq5mjSrlT4q9i
         g6+gcZyjwiZd8omXgt1bF2dBNbjmFgnRSAfEMjSreQTRpaWiFDKMqhZ89ElhPt/dblAg
         QCUO4RE6gX3vhatbTMspR/95QCiEGb6X1UO7mbP/BNNI1BDRJDQTrhhv7y71DB7Qn/pm
         hJEUvjzzC4TInTUPvQDrr9hIn5hKuFukie9/sX4BgS/AeNVOPNfpmJv7l3AlPcHV9Xta
         1kYYHLOb63Lkqj5Ru2rdVFLX3p5c01F+rl700CC/QmrhyYw/0qq7KuUtXbCTQn8TFqxj
         tHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4EjK5wzb7SYrY+vgWTVbp0U5AJvVCk4AwWIopyVM5II=;
        b=izZbBgLSzH/rU+sqFjZqDQodxgJ0T9mmBHw04UldooOFe47TV/tnFWLsZjxkmJ3yMq
         d83TbehpIIh01dTu/iZWPm5UtMH2SkiMIAR+1qrP4x+MtvUtpn3kiBpQXXjtJRPaZBF1
         SbYpLI9gqziZWUB0YPJ6Ad7udQDw2Y0/HAKqKTBWlQ2PFyKYlLGkaEew8k2I9EAPPaJg
         0E/37MNZyFGU9U+KNueRnMqLXCNhEwZiCRVVyixQHACE8edCEy6P5ywxSIbIcpfT63Cb
         6F/fi+qHW5JRt7n6a3VphBepEoVTOiznoyv/+5sozU8y6nNn8+GLn9zEtbwuVG5S6tNb
         XvCQ==
X-Gm-Message-State: AOAM530cq3GHaUPMuVCYvyd8WjtNVr0q5lDukml84cKMxGgyW4bnm/UH
        hQTHV7VHeTGp/jiWMbcEwBz+8p33cL8=
X-Google-Smtp-Source: ABdhPJxWLmo06iCtXUjGZe0innDwg+gcRfESJvMqo1cFLZfyOvJoTxXLxQ3PfXZNeKPErdzkIRayVg==
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr14846965edw.337.1633095236021;
        Fri, 01 Oct 2021 06:33:56 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id ne24sm2993250ejc.46.2021.10.01.06.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:33:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/5] trace-cruncher: Error on fail to destroy
Date:   Fri,  1 Oct 2021 16:33:42 +0300
Message-Id: <20211001133346.8217-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001133346.8217-1-y.karadz@gmail.com>
References: <20211001133346.8217-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Always print an error message in the case when the C object,
being wrapped by the Python type failed to destroy.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h         | 7 +++++--
 src/ftracepy-utils.c | 4 ++--
 src/ftracepy-utils.h | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/src/common.h b/src/common.h
index abfda1f..697b327 100644
--- a/src/common.h
+++ b/src/common.h
@@ -54,8 +54,9 @@ static inline void no_free(void *ptr)
 
 #define NO_FREE		no_free
 
-static inline void no_destroy(void *ptr)
+static inline int no_destroy(void *ptr)
 {
+	return 0;
 }
 
 #define NO_DESTROY	no_destroy
@@ -101,7 +102,9 @@ static int py_type##_init(py_type *self, PyObject *args, PyObject *kwargs)	\
 static void py_type##_dealloc(py_type *self)					\
 {										\
 	if (self->destroy)							\
-		obj_destroy(self->ptrObj);					\
+		if (obj_destroy(self->ptrObj) < 0)				\
+			printf("fracepy_error: object '%s' failed to destroy\n",\
+			       c_type);						\
 	ptr_free(self->ptrObj);							\
 	Py_TYPE(self)->tp_free(self);						\
 }										\
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index ca7f914..e49132d 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1757,9 +1757,9 @@ PyObject *PyKprobe_probe(PyKprobe *self)
 	return PyUnicode_FromString(self->ptrObj->probe);
 }
 
-void ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp)
+int ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp)
 {
-	unregister_kprobe(kp->event);
+	return tracefs_kprobe_clear_probe(TC_SYS, kp-> event, true);
 }
 
 void ftracepy_kprobe_free(struct ftracepy_kprobe *kp)
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 9f4c4ba..a6133cf 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -26,7 +26,7 @@ C_OBJECT_WRAPPER_DECLARE(tracefs_instance, PyTfsInstance)
 
 struct ftracepy_kprobe;
 
-void ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp);
+int ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp);
 
 void ftracepy_kprobe_free(struct ftracepy_kprobe *kp);
 
-- 
2.30.2

