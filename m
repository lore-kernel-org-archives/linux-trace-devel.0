Return-Path: <SRS0=f3YT=YQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13DACA9EB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1DDF2086D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:21:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0ojksFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405264AbfJWMVu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:21:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38379 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfJWMVu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 08:21:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id q78so5753262lje.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Oct 2019 05:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHBE4r8GHg8Nn4QAdx74R6dITon7K+LYUpfPkUj/jOQ=;
        b=m0ojksFOM6eS6jtrlzznIyamm2rYakI04L02IfvBcD1T1MAn9eWQEp5iOr05DZJ/oA
         w1WZL5nB02KUswPP42SlutHjKjpFg36+QUaecYcavwBb4qNQUwFNSQanQ5NPrzTNAkvQ
         UBAlLbnIozu0+qPtpXKmD6Nm2WwxjYrGqp/YMOTI7Hb8r7sUXx55Ab8Tg60Av/LI0xvQ
         iie5+qRJdqqi91OxUY5x9TAAsxbijYpazoIQRQIv2FrcfIzTO5J88s+8C1xa3e0iyJnn
         NHPVrf8KkSSF51nmumA43Y0fi9GYqfFs15uuueJnpFQEF/pwLWezuVUSSjcuSzs8ZHMg
         PMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHBE4r8GHg8Nn4QAdx74R6dITon7K+LYUpfPkUj/jOQ=;
        b=MzckDqjsFArCuJrkAY4dCTHp6DKzk5AU8wxtAUqYCaEzx9U+BMT7NKHiiOjjKTVITX
         sGoqko9Q0YRiPXl4r3DdEzSEXzNwwQgyaA0IvtGDXZIF27AaV/glo2RQ7BHqrNhAylYn
         Z+ZoTXh6qeMD4cgO/t6UM3+0jmRjuhvZumUy072DhjmI9BpHPbFJaOk9EuMHIHzvgZNW
         /ugOjydim50V/6O26aCbSohHEmEfQqk5BaKjJD0Z+0+7fgt0APGgk5D3xBIs9p6pfyXT
         fOy7aq9zrHszPcp4txkznWstURpFD+3L0LMLMQg8t7vmrRkaNJWXvnO44zhqDEYwjMqC
         2XXA==
X-Gm-Message-State: APjAAAX9G536o265uz6rVxT3WrlBZ8+4Ih3QhSZ2H56zEWtjnpI5oOVe
        ugAqQTJMQ7SRAUe/Wm1VIYY=
X-Google-Smtp-Source: APXvYqwspm9D6ZtLM4HccZKwbaq8F4gUcM+DPIWVqxLq9Yc2v2syeGhkWh70ItsyvLwDV8tQvERg3A==
X-Received: by 2002:a2e:a0ca:: with SMTP id f10mr300897ljm.84.1571833308447;
        Wed, 23 Oct 2019 05:21:48 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g26sm10453566lje.80.2019.10.23.05.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:21:47 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] kernel-shark: Fix potential memory leak in libkshark-collection
Date:   Wed, 23 Oct 2019 15:21:44 +0300
Message-Id: <20191023122145.14314-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191023122145.14314-1-y.karadz@gmail.com>
References: <20191023122145.14314-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When searching for the entry, do not loop over the original list of
requests. Use a copy instead. If we loop over the original list and
no entry is found in the first element of the list, later the memory
used for this first element will leak.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-collection.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel-shark/src/libkshark-collection.c b/kernel-shark/src/libkshark-collection.c
index 02a014e..95fdbab 100644
--- a/kernel-shark/src/libkshark-collection.c
+++ b/kernel-shark/src/libkshark-collection.c
@@ -622,6 +622,7 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
 				  ssize_t *index)
 {
 	const struct kshark_entry *entry = NULL;
+	struct kshark_entry_request *list;
 	int req_count;
 
 	/*
@@ -638,12 +639,10 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
 	 * Loop over the list of redefined requests and search until you find
 	 * the first matching entry.
 	 */
-	while (*req) {
-		entry = kshark_get_entry_front(*req, data, index);
+	for (list = *req; list; list = list->next) {
+		entry = kshark_get_entry_front(list, data, index);
 		if (entry)
 			break;
-
-		*req = (*req)->next;
 	}
 
 	return entry;
@@ -680,6 +679,7 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
 				 ssize_t *index)
 {
 	const struct kshark_entry *entry = NULL;
+	struct kshark_entry_request *list;
 	int req_count;
 
 	/*
@@ -695,12 +695,10 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
 	 * Loop over the list of redefined requests and search until you find
 	 * the first matching entry.
 	 */
-	while (*req) {
-		entry = kshark_get_entry_back(*req, data, index);
+	for (list = *req; list; list = list->next) {
+		entry = kshark_get_entry_back(list, data, index);
 		if (entry)
 			break;
-
-		*req = (*req)->next;
 	}
 
 	return entry;
-- 
2.20.1

