Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1719EC43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEDF520732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAXZtSmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgC3QHj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:39 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41738 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3QHj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:39 -0400
Received: by mail-lj1-f195.google.com with SMTP id n17so18702390lji.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JagE3gg7EOjP9DoUhFL18DESlQrz7ZjYlwhDnrGKdQY=;
        b=HAXZtSmvetrP8hKV4sZodG1+B7w5StroFJyzhUQzmciDSlogN+WN119JZhx+9bt8Fe
         nH52VfzISTlArfak0D0hR/1xHezcLb/TYgwmY/Y8xbcS/w/dYaF3+vhnaKKP/IPL0/tS
         pdBvFP4bVut2SntBj+CyS8289wFrGJ/FuvmlNaUx55rEizswMDJTCnjDB84tjh+OQAQt
         YaUHGLdEJp7Ioq67ujwsQTehJ3klUWlXqdX127gr/rCyVWa/TEQ5mb+Q0QLya5ipDMax
         CaoNf+MYgLJQm/e3h0KFSWOgysld+E3icU6SRNZp5ZskdDxxmKrAAdgLzFK12bPhGqpR
         vr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JagE3gg7EOjP9DoUhFL18DESlQrz7ZjYlwhDnrGKdQY=;
        b=Jgxaly9XKxyx2e1CjCpYEfuispBc3/fVI/rN8ygPG4G+aDg7bAk/sm+AbOVfi8eiau
         bwxRKFBebI6Q+9eYBQuWEz2OQC+r91VcgIyl4ADyre7uO/zSMI+J6L+glfCck8c9Vc4v
         UtHuu+2PSUYiyXnR65B2xL7037QyRnr4WHejW1gQOSHEhCOsPBqrVn+2J+FGkxF1TgJb
         pXQcbiQhWWP2CBVg6zpjk9owEVuYn4ePIVBtmZxBGCho6oSU1Wz7xG8unIC48xh/J3OC
         gBEdjxNC02vlOvpzHq/OL8g5dmT+GJy7pWCYrat70XJYGgz/xFc/bZwAkXow2YIPi06L
         76pQ==
X-Gm-Message-State: AGi0PubnEKCw0/j+QAX0d4KSPw+oLKTJHtuId8i43QW/uTva9uRWolo1
        GiPIfOpr4sxAVkmGpc4Vwoe+I6YZ
X-Google-Smtp-Source: APiQypJuyaYo6pzcSUGKfhcryJ5QPjeg+ytTscqy2E44AUPfwrUrZT6I5V3tNvdTVvjX/queR6oW1Q==
X-Received: by 2002:a2e:8e3a:: with SMTP id r26mr7675076ljk.233.1585584456106;
        Mon, 30 Mar 2020 09:07:36 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:35 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/6] kernel-shark: Add getIds() to class KsCheckBoxWidget
Date:   Mon, 30 Mar 2020 19:06:50 +0300
Message-Id: <20200330160652.28424-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330160652.28424-1-y.karadz@gmail.com>
References: <20200330160652.28424-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a simple "get" method that returns a copy of the vector of Ids
managed by this CheckBox widget.
---
 kernel-shark/src/KsWidgetsLib.hpp | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel-shark/src/KsWidgetsLib.hpp b/kernel-shark/src/KsWidgetsLib.hpp
index 0d79250..59e773d 100644
--- a/kernel-shark/src/KsWidgetsLib.hpp
+++ b/kernel-shark/src/KsWidgetsLib.hpp
@@ -99,6 +99,12 @@ public:
 
 	void set(QVector<bool> v);
 
+	/**
+	 * Get a vector containing all Ids (can be PID CPU Ids etc.) managed
+	 * by this widget.
+	 */
+	QVector<int> getIds() const {return _id;}
+
 	QVector<int> getCheckedIds();
 
 private:
-- 
2.20.1

