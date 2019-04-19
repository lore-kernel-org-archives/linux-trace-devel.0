Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C06C282E3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3407222EC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfDSSRT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:17:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40688 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfDSSRT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:17:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so7814500wre.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 11:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vohe4X2m1SR1JylOFC13tql3lHwVXjFouFgd4+HFAZM=;
        b=FW2LUpDVr9j6POmoytTHFRhorZCAz+O/7RTSLCJz9RnY251gt7CsdAv5le3TbkrnX1
         50h+sgp59+0B6TrRffQumAULiO0KlC7bn+w5dHz1xpbbxrdlWu1HR4KBEMTteghAjcJM
         KWANWQB8ukj1BQ/10bqBpFGZZ3o/t8zXoi9UgycwycvMUAnMLExltUALjCKcY2itGnym
         tMGNUIT2SG1ruOX76ZKCxpY7ztgzHEi5XYZ6ZWmqGVJdErAxhOw2wXctTSJTfLkldBol
         YZAfNGuYct1+d8Qb6Wkyj7wfPdfuAN1TGoEiMNLI4D6gKpDRfzT1oHhYTA0I3EyS3Od2
         /tNg==
X-Gm-Message-State: APjAAAW1khzN6zrg4EdkjB/WB/4TLoL1FZhbjhswzdpQ525SgMSSV8U+
        +mWiOgTFnK92Egkqh8R2zKzQ5KgZ
X-Google-Smtp-Source: APXvYqzLt8FjCaWzocdWfe2ZoabZfC3JcgykmglNqRi3QcjOj2OL199vBoD0voELH3tMSyB7pcXXrw==
X-Received: by 2002:a5d:4b01:: with SMTP id v1mr3201711wrq.48.1555681863138;
        Fri, 19 Apr 2019 06:51:03 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.51.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:51:02 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 6/8] kernel-shark: Load Last Session from command line
Date:   Fri, 19 Apr 2019 16:50:34 +0300
Message-Id: <20190419135036.19340-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
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
2.20.1

