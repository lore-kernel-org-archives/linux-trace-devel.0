Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236A5C2BB86
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC0D22072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ormYSn5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDIN2D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42414 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDIN2D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:03 -0400
Received: by mail-lj1-f196.google.com with SMTP id q19so11399970ljp.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e3sg2NbhAbiy2SgdTDVquTcl4Fkh+a8KDnG0VV7fEO0=;
        b=ormYSn5dlRhsW5jSESHsCRBqDXvTBK7Xne+e9H7aIh6b8Kqa6s06ZGvKzMWiUYAu2G
         ZOTtmY3b/wGwJ5kXQxqIV/2UXZxgtPdFNFHzGJvK2rr8Uo6tzQSRuJKo058TCys+oxIT
         M/Pb+GwbRkj5Ps1L6N2snw26n+9BfX+F+LfM80sXei1Vd+yyeE+NWB5XwNwt8WzfIFzx
         hX+A4tTv/+3iAMV7YS2sYswC37UWvU7r8HTPiGWDL954vN8081rFJJm6P1NdgxhUpWUX
         gTJLAEaEEkB5AVjoR5K7hf7PPcUbyC1/QcRjngROQ3FuX3LbVB7str3YbfhBFME2Swxt
         a8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3sg2NbhAbiy2SgdTDVquTcl4Fkh+a8KDnG0VV7fEO0=;
        b=tMI/I7yfbjDLvF1KiLNFOiWfbOqnoyqipMJA8STemrXIHwW0EJRb/mcuJOf75hiiqu
         jhrzumvXpJlBRRC6f3tMRO8xfEWUsyr/dIZBf1rdsZ5rBaK4jbsBozekSqVTQXWicRX1
         LSDMEAvSnBf8FuREkb5Fnd2g+5ChXTYI1WllV/SBT0JzChCNvGIoPsCbYHysO/sYVelc
         1ZZKDCuHhqkshtXG42G2Ab3s3nkxYBhAuenzvHPsc5/El3r1Ku2wFWUAuwHAHaOb7z7D
         GMqO/PQdpFJitmISv8PwAe/z5EIzZRy1tPtImqVIw+t/Iu/mknq6fmtUeuZcbwxQrywc
         iDHA==
X-Gm-Message-State: AGi0PuYZo6aoUyui7bH4ityuSQeCSchBISUMfRFG7saHTRQxGq1Mmi0o
        nvQ+6SgPtOamZaKZJqBgyovb3NoS+d0=
X-Google-Smtp-Source: APiQypKbc145q3OuwhOWS89hIslLNUigCmg84O9GqZW+0Irdh9TS6rnFqsLWBAzxzQbZAP0OjCl0vA==
X-Received: by 2002:a2e:8017:: with SMTP id j23mr5145014ljg.271.1586438881727;
        Thu, 09 Apr 2020 06:28:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f2sm1067220lfl.18.2020.04.09.06.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Fix possible usage of not null-terminated string
Date:   Thu,  9 Apr 2020 16:27:55 +0300
Message-Id: <20200409132756.79402-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132756.79402-1-tz.stoyanov@gmail.com>
References: <20200409132756.79402-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

According to the
   readlink(const char *filename, char *buffer, size_t size);
documentation, the terminating '\0' is not written in the buffer.
As the buffer that is passed to this API is not initialized, this
can lead to working with not null-terminated string.
The problem was detected by valgrind.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-plugin.c | 1 +
 lib/trace-cmd/trace-util.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 6bec18bc..92f9edf3 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -199,6 +199,7 @@ static char *get_source_plugins_dir(void)
 	if (ret > PATH_MAX || ret < 0)
 		return NULL;
 
+	path[ret] = 0;
 	dirname(path);
 	p = strrchr(path, '/');
 	if (!p)
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 04dc804c..0ead96ea 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -269,6 +269,7 @@ static char *get_source_plugins_dir(void)
 	if (ret > PATH_MAX || ret < 0)
 		return NULL;
 
+	path[ret] = 0;
 	dirname(path);
 	p = strrchr(path, '/');
 	if (!p)
-- 
2.25.1

