Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE23C33CB7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8D202071E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ve5ZFxAp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgA2Jy2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:28 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33818 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgA2Jy2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so11459655lfc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xA7MSteWZ7d4mJnrknuVUwm6a/jp4okyMU5X333fZDc=;
        b=Ve5ZFxApTbbenYPOS46dE4lXRmK1BbSjsyilgNcK1hUp68dXUAfZXNAISramvZM4nu
         /SztyGMXRqJjx5J8AwYMU5xsecCsfJcBmoUnPSlfzmzYOo4W2pWTo/ZqJpyKxTVLomFS
         EyLJ8FpRz7d9NcILV4Ubod1/r7/0zvFxpoZAZGI9s6gdC4rCf+RNVPyJLUH4j3tIlagi
         yeEXpve8G3dkFIQDe/yU/kFPn1ijw9KjpD8tN+pF7KcrnSb8yJRjw+XQbLDTOWDFwdcd
         UyiTEY0OJBLAtV2Sih4SiSn6nXQY9+RBmg2wlR0wtWxO5D2zLDwr4JcKAniQWXwxQdrG
         cHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xA7MSteWZ7d4mJnrknuVUwm6a/jp4okyMU5X333fZDc=;
        b=Oy9qA4DiOwKYEeMruyXgRR7SrlYubR082Ov8rFw0+AfASNEmyuTGtE8xt0oj7J4hXC
         u3phUyJl1uMokTrXFsCGE8Rkv3mWkh0gmDllYcHSQvlCCmdO6gj+aOSA5xCv+2N5YHi4
         JanzhohSwCFq4QPNY19tIAoiwmfxkfGbC8ketmCXUOGh7D7iQBgpNQsni0COUo1BXAxf
         Dv+oEsWDDNvn+4sFjVfPRl1Inv9klPLdoGre1MPGMtDiyVIlUappRARMEcCh3gpbkiCl
         AGH+m/OSAc/6KQXDflxtxiArybvDY3zYYICxgi99DNkSWEURRHeNrnPIgxjauB18xexQ
         3Qyg==
X-Gm-Message-State: APjAAAVTIOlW/+H1YW6G+wOvvxecrW+7R+fDjRr1CQWmrwnqdTVw+H4E
        WkPORvDg1GH7y9OMDmriSGtekE/a
X-Google-Smtp-Source: APXvYqwOg4IA+IG/h6kAKUnX9JcPS5ZCZmJ3xfEkKmPK/leetcpVoke6Z/QvkvS56jHHzW9TkFQpQg==
X-Received: by 2002:ac2:4476:: with SMTP id y22mr5024809lfl.169.1580291666766;
        Wed, 29 Jan 2020 01:54:26 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/9] trace-cmd: Add sanity check of tracefs_get_tracing_file() input parameter.
Date:   Wed, 29 Jan 2020 11:54:15 +0200
Message-Id: <20200129095421.881786-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The input parameter "name" of tracefs_get_tracing_file() API is mandatory,
it cannot be NULL. A check is added to verify this.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/tracefs/tracefs-utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index de46aab..227990a 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -161,6 +161,9 @@ char *tracefs_get_tracing_file(const char *name)
 	char *file;
 	int ret;
 
+	if (!name)
+		return NULL;
+
 	if (!tracing) {
 		tracing = tracefs_find_tracing_dir();
 		if (!tracing)
-- 
2.24.1

