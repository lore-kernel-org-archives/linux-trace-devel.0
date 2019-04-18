Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC41C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA32B20821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbfDRPWu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54304 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388806AbfDRPWu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id c1so3186075wml.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaAcxvLXdkIUy3oCd1hVeb66KDSze7oeTnLjclEwM08=;
        b=ORBVGwHRJAD92vuU8riBJ7BTWUZks0y17eG0j93BGrNN1hsku3kytWvyQeQgs1rBNh
         XKznEW9kHjfBQkRFFZID0SYf8RHrJ665zAGVRemURndfabtlCrIRsZkawJ6JHA5OrIsg
         ySgjIp9xPGgd4+X0kMkQeXA8RwRr0Z00bURlV77sOqNnTXG1Va1/N73NKzOwzhk4Q8FZ
         UWIBeLzt5R3yKBXrM5+j1WFgHby+b6lnAPmptUW/3yyfirarS/D13MPHWJRzhWcqgozu
         PigeJlkdJJ7HxfxAYnmCKQkFF86zv2O2OBx7I8Z04JyLHuiwMGTfNPDU/XrQB7Dq4pGQ
         OrMA==
X-Gm-Message-State: APjAAAW4Li4tTkWp6OGh4L0ExBuxTRcX1G03KREFRSjQ7IMomvXc0f5C
        qaUBmldIsCBR69iln33v8+I=
X-Google-Smtp-Source: APXvYqxCGu0DqQood8sE5csyMPm3HDMzkdYwrLsbJm46MsiUSYXRXBpUsgLqNXsqkh5fkhznuJWSUg==
X-Received: by 2002:a7b:c923:: with SMTP id h3mr3527654wml.34.1555600968690;
        Thu, 18 Apr 2019 08:22:48 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:47 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 6/8] kernel-shark: Load Last Session from command line
Date:   Thu, 18 Apr 2019 18:21:44 +0300
Message-Id: <20190418152146.27232-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
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

