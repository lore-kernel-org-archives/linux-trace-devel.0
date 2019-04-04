Return-Path: <SRS0=Fk9f=SG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE509C10F0F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FDC4205F4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfDDO4S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:56:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55542 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfDDO4S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 10:56:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id o25so3402906wmf.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Apr 2019 07:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaAcxvLXdkIUy3oCd1hVeb66KDSze7oeTnLjclEwM08=;
        b=heW+uMbaW++staYjQrzkJixLlW1HO5clzKYEjfXmZfRUYoZhFRctfKum+D8+y/R3Sl
         TdLFQqI4mTAMghCV3Qsuhni8TaiF+kqEcltYr4LPPjmJLBvy7OdVuVPQ48sifFR6RObj
         34CagG2DtQVbXVIUX2jJZb0A/8l9mnIJp14jM+j7HKhsplDqI3VvaddLZIrRnSA23tzj
         1z59un6fT/DLEspE2AWq0H9I8T5jWu82TLmyFpIoDl5L4vyUHyCwSL4nHSOqEk9KbQTo
         7fscqHqCnwXXAUkb0DurKpZo+Mm16SfipeCmGeqPmOMUCsPJDCUNEhq56IZ0bGy9HFB/
         RmyQ==
X-Gm-Message-State: APjAAAVEqXQVrHkgeXRaOXMSFdnuNJi7+CDMhgm6/9ARVHjnYgsNLtkS
        uoG8pAGiB5EVepN4hcc6VxcYNI/FK14=
X-Google-Smtp-Source: APXvYqy4P55bD6sUnQSoaA3rCg4JrGzK6sCQybtH5mvUJ+S5JOHRNd/Zio/ifGhRoBvOkYCeTaziWw==
X-Received: by 2002:a1c:a64d:: with SMTP id p74mr4642892wme.89.1554389776500;
        Thu, 04 Apr 2019 07:56:16 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id m13sm21919883wmg.42.2019.04.04.07.56.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 07:56:16 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] kernel-shark: Load Last Session from command line
Date:   Thu,  4 Apr 2019 17:56:02 +0300
Message-Id: <20190404145603.13592-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190404145603.13592-1-ykaradzhov@vmware.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

./kernelshark -l  will load directly the Last Session

Signed-off-by : Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/kernelshark.cpp | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/kernelshark.cpp b/kernel-shark/src/kernelshark.cpp
index 2ec91de..1ec6678 100644
--- a/kernel-shark/src/kernelshark.cpp
+++ b/kernel-shark/src/kernelshark.cpp
@@ -28,6 +28,7 @@ void usage(const char *prog)
 	printf("  -p	register plugin, use plugin name, absolute or relative path\n");
 	printf("  -u	unregister plugin, use plugin name or absolute path\n");
 	printf("  -s	import a session\n");
+	printf("  -l	import the last session\n");
 }
 
 int main(int argc, char **argv)
@@ -40,7 +41,7 @@ int main(int argc, char **argv)
 	int c;
 	bool fromSession = false;
 
-	while ((c = getopt(argc, argv, "hvi:p:u:s:")) != -1) {
+	while ((c = getopt(argc, argv, "hvi:p:u:s:l")) != -1) {
 		switch(c) {
 		case 'h':
 			usage(argv[0]);
@@ -65,6 +66,12 @@ int main(int argc, char **argv)
 		case 's':
 			ks.loadSession(QString(optarg));
 			fromSession = true;
+			break;
+
+		case 'l':
+			ks.loadSession(ks.lastSessionFile());
+			fromSession = true;
+			break;
 
 		default:
 			break;
-- 
2.19.1

