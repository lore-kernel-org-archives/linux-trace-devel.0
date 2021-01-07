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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF106C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C8920738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhAGIdH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:06 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34DDC0612F6
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:25 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id i9so4776594wrc.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGarlQPbXfVZDJaxNejSuQzV/l1iYd8V3XQAV3zsbhU=;
        b=rMq+gJ0asV6kJ/02rvCtwBYI+4sdESSSQkI0ni4jeJnJZLS5AuqkkHIqDJnrNfpMVf
         JyhuJVwfBTHYr/eSsL9y1HdDWfzT4nIBeTgN3JVf1DGgJofQbeUAdcTGntoLtqe4q1G3
         9FMGUSgiUz1TAffy1c+ZJNZn30lwpYxI3NzZX5UvmMh76j0QbQNO2V8BhFQmBLWqIJwl
         DRp0fgi/Fhl1C0iPOncZm/A2tD67IwCyidR+c4OifGEIeik/ySA20HQNMpUXzr3fP8Ky
         4CQdUlkttNvJd5vBmS8wiTcJdYPYSL/RS2iYryPkQniUrHJCaGVcSaip1v+pTLacRqwB
         QHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGarlQPbXfVZDJaxNejSuQzV/l1iYd8V3XQAV3zsbhU=;
        b=AKN2UkLVcXzB+R4tVHLKCCOEFcq3SWF5RsM1ToI1GCv5oIjTzEtkQNKucxkfQAPvJB
         7lIsdbzkZ5ZLlIYO9OtYYB0MmzPzbWiBDNoULDMJQPondneJETKuYDzipeu0WvOtU5uX
         9XKMK2cZ0LlefdMLkSoLByqffV4j3tFT5U282Gp7DKnuW5Vmd0qDLYetd41l17Qjy3RD
         QYTJWvsJN5WB7f3fskIBJZoMoLMg9b4QWR2DnsBKMLE13Hr8iu/aXAOZ9bOxbCNgqjx9
         M9W/+KjCUlAhZlKVKIRqtO/houlQDR9GIlSKFPMQo+MmMxcyydlO6fMNYo4hG0ruY7eV
         dApw==
X-Gm-Message-State: AOAM531I4QPz33eoJg5gMdPsIxgJVYRWOhZCw74A0M/rXiuI2GzBNSZ9
        Gncf6IZeaOZ29L/T73egOJJtGcCLuzHRZZ2N
X-Google-Smtp-Source: ABdhPJy2Bx+KLdQaFB1cqrxxmdfp8oHj2nsAR1DftmJ8wQhGQnnQrNaXa9oPu1oxy+la/wx6AMozKA==
X-Received: by 2002:adf:e80d:: with SMTP id o13mr7875606wrm.293.1610008344757;
        Thu, 07 Jan 2021 00:32:24 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j59sm7237525wrj.13.2021.01.07.00.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Set correct library name and version in the documentation
Date:   Thu,  7 Jan 2021 10:32:23 +0200
Message-Id: <20210107083223.16091-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs documentation building structure was gotten from
libtraceevent. Some variables were not updated and the libtracefs
name and version are not passed correctly.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile      | 6 +++---
 Documentation/asciidoc.conf | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 54526e2..badd80e 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -181,7 +181,7 @@ ifdef USE_ASCIIDOCTOR
 $(OUTPUT)%.3 : $(OUTPUT)%.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b manpage -d manpage \
-		$(ASCIIDOC_EXTRA) -alibtraceevent_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtracefs_version=$(TRACEFS_VERSION) -o $@+ $< && \
 	mv $@+ $@
 endif
 
@@ -192,11 +192,11 @@ $(OUTPUT)%.3 : $(OUTPUT)%.xml
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b docbook -d manpage \
-		$(ASCIIDOC_EXTRA) -alibtraceevent_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtracefs_version=$(TRACEFS_VERSION) -o $@+ $< && \
 	mv $@+ $@
 
 $(MAN_HTML): $(OUTPUT)%.html : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
-		$(ASCIIDOC_EXTRA) -aperf_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtracefs_version=$(TRACEFS_VERSION) -o $@+ $< && \
 	mv $@+ $@
diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
index 0759571..c15aa13 100644
--- a/Documentation/asciidoc.conf
+++ b/Documentation/asciidoc.conf
@@ -74,9 +74,9 @@ template::[header-declarations]
 <refmeta>
 <refentrytitle>{mantitle}</refentrytitle>
 <manvolnum>{manvolnum}</manvolnum>
-<refmiscinfo class="source">libtraceevent</refmiscinfo>
-<refmiscinfo class="version">{libtraceevent_version}</refmiscinfo>
-<refmiscinfo class="manual">libtraceevent Manual</refmiscinfo>
+<refmiscinfo class="source">libtracefs</refmiscinfo>
+<refmiscinfo class="version">{libtracefs_version}</refmiscinfo>
+<refmiscinfo class="manual">libtracefs Manual</refmiscinfo>
 </refmeta>
 <refnamediv>
   <refname>{manname1}</refname>
-- 
2.29.2

