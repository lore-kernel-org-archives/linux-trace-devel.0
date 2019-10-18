Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116F8CA9EA1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 07:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75ED222C5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 07:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oy/tTOt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408991AbfJRHsD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:48:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52126 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfJRHsD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 03:48:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so5095786wme.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2019 00:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHBE4r8GHg8Nn4QAdx74R6dITon7K+LYUpfPkUj/jOQ=;
        b=Oy/tTOt0SPeuJ9HsyuHIW7q5b5UOyxvritfJJV5BUp85m4g8A3lvSVhZeiP6L7adyq
         YWlrB4gWk3OjX51ls8YiRj88Ngcqhd0KtyCSc0iwe+6qPKtdnIU7uBPGn0gq1GcDXY9T
         5truJQBWuweHsd6qvDevpPSECoGkZuaFW3yrSz0giQmexxPEux/oAMQ4dwQ7XNXYExtX
         w9VEq+bfGhhLElFmrsq4ynfDqB6mOwtT/1nnjZVIDWO+x3bGEGoo5Ce/+ztVyPt4BtlH
         L3+GirQhdn7Uhy5UvhVyG3xqMK5j4Y4SUML9ExksyqOBiIzdkhVv3qOf9VABOxVEVT8x
         NSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHBE4r8GHg8Nn4QAdx74R6dITon7K+LYUpfPkUj/jOQ=;
        b=JRpSHYIAPNicViGPL7dXClxhYDZyFh1so/o939xqwhmfN9dh36Z5pn/8JNbSjW0B5W
         C+jLSsQdCYgm+SglyWCuZaBLVg5EB54Q6HyrBI1Tyw2/EoKXLBn6yEYzqNIF3eHP9N75
         n3R4R+ubVkkRzOUdh7hTS+BkadpbTjgkV1PHRNnbdxKJPgaCtBEdz7x7ogilgF8ExzmM
         HkXoSlIIpuP4lSXZmtlox1imY+c0Q4kP0VbSQCLGp4K2dMcPL5q6/f/YVPtQ+TO6r2gK
         3GeOMBPXHjjoWd5wOKjMvyiHMdqLrEFw2E6C1U7hDNMn54o4TSSDlqT5NlyBjmVOeJDN
         ikvw==
X-Gm-Message-State: APjAAAWTbMrdSr6n284HcGht9wvbAKusFGApWWX5a0PVi6XXrRumFG3+
        LbUZyUK35O6P/XPkGmrRk4g=
X-Google-Smtp-Source: APXvYqx42F6tamigjW4xGmrt4XsvMBSqv8kpZEaO/zM3jwus7SRpzLIDj8p9mWrofGjA6mcOumAt5A==
X-Received: by 2002:a1c:968b:: with SMTP id y133mr6290727wmd.141.1571384880338;
        Fri, 18 Oct 2019 00:48:00 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm7740832wrg.8.2019.10.18.00.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 00:47:59 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Fix potential memory leak in libkshark-collection
Date:   Fri, 18 Oct 2019 10:47:22 +0300
Message-Id: <20191018074722.6976-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018074722.6976-1-y.karadz@gmail.com>
References: <20191018074722.6976-1-y.karadz@gmail.com>
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

