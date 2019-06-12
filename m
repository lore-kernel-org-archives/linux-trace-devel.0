Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A96C31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419F1215EA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409320AbfFLOVq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:21:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37261 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409256AbfFLOVp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:21:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so17127565wrr.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jun 2019 07:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=57eLlmQRNMEdLEYvD0lWzbVQFc7//tLNSs65hJjPQ0M=;
        b=CNjGrH9thqFv1zPn1D0+mlzE3XwepooUjZWV5QGGJNRPyqHR9JlWYhBwr1+NztVRJm
         qyP85zW4tdDdU9vc+8kjzDHgf2UqLNRZK0QwrQQP/ApKAFQJx3f0hrnGGOrPpI28SbOO
         9b3b7zbi+rrdNvhkF4/H5w8Yuv/C7zwAIpsRTu63y+fZ4JkKotgcMjKRWH+oyB0lnar9
         cdRrRbBE7kt9f+cvG/REGR03RrLogccDFUUi7V8+X2YP7liAXz/FMBv0cqYCZ9S7aeHY
         aI3VHCaNEmNjZ3MJh7Xwyehg6lvuxMOc0Yek+TZMqBegstZdZvn+rJbVXm86QGahl/m/
         KttA==
X-Gm-Message-State: APjAAAXeGsAb72Rh/UE769QGWDOHcNWm8i3e9Rg0erB1tYfhjeEb+yCF
        E4sjFsTQiX3z17oZGcX+JYI=
X-Google-Smtp-Source: APXvYqy4aAKEUGK9ki4WqCRLqZ4I9TlVkrF4bkiRK6Zs9frC4K8Nk/2bTofTHXEBabblvfp8MgG6fg==
X-Received: by 2002:a5d:4bc5:: with SMTP id l5mr9486244wrt.214.1560349304093;
        Wed, 12 Jun 2019 07:21:44 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f10sm27624826wrg.24.2019.06.12.07.21.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 07:21:43 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/2] kernel-shark: Fix a bug in ksmodel_set_next_bin_edge() part II
Date:   Wed, 12 Jun 2019 17:20:52 +0300
Message-Id: <20190612142053.14439-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On a first glance this patch may looks like reverting commit
9336dd6bcd38 (kernel-shark: Fix a bug in ksmodel_set_next_bin_edge())

The point is that for the last bin we want to increment its upper edge
used  when checking if the bin is empty, but we do not want to touch
the lower edge time used by kshark_find_entry_by_time().

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 978cd70..0cac924 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -260,20 +260,30 @@ static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
 static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 				      size_t bin, size_t last_row)
 {
-	size_t time, next_bin = bin + 1;
+	size_t time_min, time_max, next_bin = bin + 1;
 	ssize_t row;
 
-	/* Calculate the beginning of the next bin. */
-	time = histo->min + next_bin * histo->bin_size;
+	/* Calculate the beginning and the end of the next bin. */
+	time_min = histo->min + next_bin * histo->bin_size;
+	time_max = time_min + histo->bin_size;
+	/*
+	 * The timestamp of the very last entry of the dataset can be exactly
+	 * equal to the value of the upper edge of the range. This is very
+	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
+	 * case we have to increase the size of the very last bin in order to
+	 * make sure that the last entry of the dataset will fall into it.
+	 */
+	if (next_bin == histo->n_bins - 1)
+		++time_max;
 
 	/*
 	 * Find the index of the first entry inside
-	 * the next bin (timestamp > time).
+	 * the next bin (timestamp > time_min).
 	 */
-	row = kshark_find_entry_by_time(time, histo->data, last_row,
+	row = kshark_find_entry_by_time(time_min, histo->data, last_row,
 					histo->data_size - 1);
 
-	if (row < 0 || histo->data[row]->ts >= time + histo->bin_size) {
+	if (row < 0 || histo->data[row]->ts >= time_max) {
 		/* The bin is empty. */
 		histo->map[next_bin] = KS_EMPTY_BIN;
 		return;
-- 
2.20.1

