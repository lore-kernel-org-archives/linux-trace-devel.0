Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A8BC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C5AE20811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfCNPKk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44184 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:40 -0400
Received: by mail-pg1-f194.google.com with SMTP id h34so4161569pgh.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wJcoGckOFj9oO8wuQMOOcPmhEAHLrH/VEmKbEF+MBVs=;
        b=b2HhKG6E3kq78oAUqoM3eaVSYgssYZTHX/QnYK0k1fUrLRmIvOTGKeDZpn3qw7SACz
         BqWeys7LHzOik+eSPS21fW5+mMAfMc/DtpoFz7ACYAik/8hii0mdQ18CKzNAPhC8RSWa
         d+2pwJrctEuvC3BENs2tgPHJ8Q3iWcp+8bL9BcQl50efB9RIISODgZr+c1gh4UxDE0Rc
         O8v93M7sI2k83Jy3SnynyQqneeFVraOYiEmHjsW+i93pLKLW3Iod9BTunj7nKRNmMOD7
         Rijuvf+F5o7avutvspHR/D/JZbRSiBldSbf1KW3xZoEAXMb6h2nM0Pt+4qljBL8I3ous
         96+w==
X-Gm-Message-State: APjAAAVD87GEKGOnnUbCPbb6iQnm+hqK7x29nkEqKQk1P6dEWP9GU7pL
        NXmApfdQWLKc9p72OGeEwDEEKyEu
X-Google-Smtp-Source: APXvYqxol9kmjrGdbtL+B/qTjeJvxsB7AhmHRXFdrjbhDXWT0jt7OFECjvmjucWUsUWk5KkLc43ZEg==
X-Received: by 2002:a63:e101:: with SMTP id z1mr46046421pgh.190.1552576239506;
        Thu, 14 Mar 2019 08:10:39 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:38 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/12] kernel-shark: Disables automatic quotation for errors in KsMainWindow
Date:   Thu, 14 Mar 2019 17:10:05 +0200
Message-Id: <20190314151012.905-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When quoting in the output stream is disabled, the text of the
message is printed without quotations and without escaping of
non-printable characters.

example output with quoting enabled:
ERROR:  "Unable to open trace data file for session mysession.json\n"

and with quoting disabled:
ERROR:  Unable to open session description file mysession.json.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 44221f6..9bcf9e2 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -980,7 +980,7 @@ void KsMainWindow::_error(const QString &text, const QString &errCode,
 	if (unloadPlugins)
 		_plugins.unloadAll();
 
-	qCritical() << "ERROR: " << text;
+	qCritical().noquote() << "ERROR: " << text;
 	em->showMessage(text, errCode);
 	em->exec();
 }
-- 
2.19.1

