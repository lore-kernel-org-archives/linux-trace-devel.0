Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35981 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732127AbeGaPd5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 11:33:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id h9-v6so16771451wro.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Jul 2018 06:53:31 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/7] kernel-shark-qt: Change the type of the fields in struct kshark_entry
Date: Tue, 31 Jul 2018 16:52:42 +0300
Message-Id: <20180731135248.30587-2-y.karadz@gmail.com>
In-Reply-To: <20180731135248.30587-1-y.karadz@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch aims to increase the max value limits of the "pid" and
"cpu" fields of struct kshark_entry. The type of the "visible" is
changed as well, but this is done just to provide optimal packing.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 2e26552..0ad31c0 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -42,16 +42,16 @@ struct kshark_entry {
 	 * kshark_filter_masks to check the level of visibility/invisibility
 	 * of the entry.
 	 */
-	uint8_t		visible;
+	uint16_t	visible;
 
 	/** The CPU core of the record. */
-	uint8_t		cpu;
+	int16_t		cpu;
 
 	/** The PID of the task the record was generated. */
-	int16_t		pid;
+	int32_t		pid;
 
 	/** Unique Id ot the trace event type. */
-	int		event_id;
+	int32_t		event_id;
 
 	/** The offset into the trace file, used to find the record. */
 	uint64_t	offset;
-- 
2.17.1
