Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9967AC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A05520811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfCNPKm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39834 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id i20so4037331pfo.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaAcxvLXdkIUy3oCd1hVeb66KDSze7oeTnLjclEwM08=;
        b=bcubbhY8bPtVOQmFGmdMwc+ZlBA2YjnO4laxMyyNlcPPygImWBt/kQvG/Ls7nOjw5v
         w46zSu28nR0pB8otIAejhMgSy5gZOc+aknlVj+rKyrSGtyE9c+3/VScYvl80ISfUVoaI
         FYDmAUf7Xe4YOlvIytGGAJ7nnXyAOdWzgY8Al9EvHg3q/eym5v/7WhGushldaOgRAc96
         qS5Ouz+j42LGsKM835HWpFTc8+j7LYX2WOEIyDl+wRfc1QvDkvMu3dx9JdAVjgL+1s8I
         VRFOi2gdHOO/9rF6RfeJXcIKqX0jD9+235b0Gjg/RkJKI3d7EVPwme8TTJVThaRUZIqo
         6abQ==
X-Gm-Message-State: APjAAAU+uk4HmUy5yHs3wdAlsMAsxp+AOcPJVGsXhmwVQCe3+GWuchFV
        KoIezu6kwt3eeI21KwK4jyX/SoJ6
X-Google-Smtp-Source: APXvYqxM7tNovmVJYSJcUpHAKdlf0Ta+6JT07LSrGixSGDsO0q1koZbPa7P6wh1TcwrYubuZxijxwQ==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr44671368pgi.135.1552576241511;
        Thu, 14 Mar 2019 08:10:41 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:40 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/12] kernel-shark: Load Last Session from command line
Date:   Thu, 14 Mar 2019 17:10:06 +0200
Message-Id: <20190314151012.905-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
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

