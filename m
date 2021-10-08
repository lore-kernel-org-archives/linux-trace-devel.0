Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46F2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9326A610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhJHE3C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhJHE3C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FD8C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r18so31329760edv.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yh40ZYgMwbP81n6hFixo15LEQgbd5DixHArPEoYRm6A=;
        b=MLQUcjINejjRvhlCDzpPJNmBCOE7O6shbNMQ2nSbYl3oTFZtOFlk1d8TLSRQ/S/Z3S
         JHaTktLlmw3XAYxcsw5lviK7aN5pFamPYOBYP370mhRo96eGN+2rW5FbMYShZjzMFuPs
         IRkTo/8aEZPUyHd2hDBv3feId/IIV7f/JpEg2QXslicWjSdIkNwt6jEwmb2GAnGD0lyU
         JopODW+yB1CutwlS9dFPUKsS/H1wLiZPOdC0y9l+oI2dvoLdY1sCKOFln7bWWrk4B0Y/
         yP+e0ytuAagUaKQ9YoZT2PTGpASSjaTRHDGOpWxfHvyPjgoovuGvxRkD7+i6Tby/q1eV
         7jJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yh40ZYgMwbP81n6hFixo15LEQgbd5DixHArPEoYRm6A=;
        b=Mbs1ZTt2kj3+IJXyjAfwqds2y0gaeUJNbPtwEfi5i+R4r2112wmfkYwnkl5RR6i+Wu
         SD+7u6eFRRVJtWqQ/GpSmKOwN87lIDCZcskrSgC3fIpQ3TZ6o11tfdskNCc1oOQrPnht
         IWvEH7veOp+eO5U2ab2BQ+8RfnR8U4yLfUsv+MDGU+WwGzg89DOX6yLWGBsQcxSfUxnB
         1TaVEFjgWlyPJ3bB9cmj7C7jYEg8dtoid2syTp5xuDgrIHlzoDfGSL+AT+qhh5aBVnR+
         R/KpDV8bbh7HQMIJLqtZ+cFKjUEKP4IWaUlYFULsoCcTiRRCtASmjM82Ugik5xyJzOI1
         cSQg==
X-Gm-Message-State: AOAM531FqYD/zbQoTnGS6oEdDdhe+LTvk5id4SBwroP7Vo5pAYpMgv5F
        P47zd3waY1YMBiC8bhZFLW6tGbCeRbe6gg==
X-Google-Smtp-Source: ABdhPJzsMcE6ImoLAZhGs40ODZFK1daGCMZsofDy51LKrrJqNC9alxOVIRtYlfUt8Aas9GeqrQ/Z2w==
X-Received: by 2002:a50:dac3:: with SMTP id s3mr11774351edj.322.1633667226202;
        Thu, 07 Oct 2021 21:27:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 03/10] trace-cmd dump: Add helpers for processing trace file sections
Date:   Fri,  8 Oct 2021 07:26:54 +0300
Message-Id: <20211008042701.979075-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new local database for storing sections, found in trace file
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3cce231f..f7284436 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -43,8 +43,18 @@ enum dump_items {
 	OPTIONS		= (1 << 9),
 	FLYRECORD	= (1 << 10),
 	CLOCK		= (1 << 11),
+	SECTIONS	= (1 << 12),
 };
 
+struct file_section {
+	int id;
+	unsigned long long offset;
+	struct file_section *next;
+	enum dump_items verbosity;
+};
+
+static struct file_section *sections;
+
 enum dump_items verbosity;
 
 #define DUMP_CHECK(X) ((X) & verbosity)
@@ -723,6 +733,17 @@ static void dump_therest(int fd)
 	}
 }
 
+static void free_sections(void)
+{
+	struct file_section *del;
+
+	while (sections) {
+		del = sections;
+		sections = sections->next;
+		free(del);
+	}
+}
+
 static void dump_file(const char *file)
 {
 	int fd;
@@ -748,7 +769,7 @@ static void dump_file(const char *file)
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
 	dump_therest(fd);
-
+	free_sections();
 	tep_free(tep);
 	tep = NULL;
 	close(fd);
-- 
2.31.1

