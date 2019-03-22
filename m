Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CF5C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7F11218E2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbfCVNHs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:07:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46993 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730634AbfCVNHr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 09:07:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id o1so2253767wrs.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Mar 2019 06:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JJ7XgkX73S4IYLWeLBZAaa70aOYZgQ3/NmBpXdf7oxc=;
        b=lNpCPDu0khTIROHwMQk1/o6O9TkcT/Dp67y7OOQ06mBFi9PsuVBHINc9UhpSlArH31
         4LfYQhnz80G0oATjM+gcQ6TqsMxtu9Ze/KW8Yh1C2yLDIK763EqA0df0FqwnhFOdNBnS
         cRjsH2Jdg77D4dik43jM48pE3VrlUQ6ZISPIvYYA7lxGm9nGEAn95d0doTUk1gGiBPuG
         68hyTUrwbPIaueB0vkN7PJRZZreq/LyVy3m+JW5Ib1cnHzMCIIySxfyeQW61c+CBonz+
         F5BW/p9AV5ibtvQuDPSMYJIscHFVDFC7bWKqektJhFRFnXdxrzA35t/HvBYGeN5f9+AF
         d04Q==
X-Gm-Message-State: APjAAAV4RR6rJaK+Q4MC37THyPvzOg0vFk+qN57DQO5K6lUPdaQpWA73
        lW6jL+Hpj22iyjQdzQMqGn910552
X-Google-Smtp-Source: APXvYqz5w17xBdKnFg4gYHESJxdklkzDWmVYbS7XoNs75vhAAhg44r4YOhHfE2xYSbR5VcbHEAFNjw==
X-Received: by 2002:adf:eb84:: with SMTP id t4mr6891901wrn.100.1553260065760;
        Fri, 22 Mar 2019 06:07:45 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 204sm13010466wmc.1.2019.03.22.06.07.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 06:07:45 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] tools/lib/traceevent: Coding style fixes
Date:   Fri, 22 Mar 2019 15:07:41 +0200
Message-Id: <20190322130742.13753-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322130742.13753-1-tstoyanov@vmware.com>
References: <20190322130742.13753-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed few coding style problems in event-parse-api.c

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c | 30 +++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 3686a221e981..3716a9142aef 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -32,7 +32,7 @@ struct tep_event *tep_get_first_event(struct tep_handle *tep)
  */
 int tep_get_events_count(struct tep_handle *tep)
 {
-	if(tep)
+	if (tep)
 		return tep->nr_events;
 	return 0;
 }
@@ -47,7 +47,7 @@ int tep_get_events_count(struct tep_handle *tep)
  */
 void tep_set_flag(struct tep_handle *tep, int flag)
 {
-	if(tep)
+	if (tep)
 		tep->flags |= flag;
 }
 
@@ -108,7 +108,7 @@ tep_data2host8(struct tep_handle *pevent, unsigned long long data)
  */
 int tep_get_header_page_size(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->header_page_size_size;
 	return 0;
 }
@@ -122,7 +122,7 @@ int tep_get_header_page_size(struct tep_handle *pevent)
  */
 int tep_get_cpus(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->cpus;
 	return 0;
 }
@@ -135,7 +135,7 @@ int tep_get_cpus(struct tep_handle *pevent)
  */
 void tep_set_cpus(struct tep_handle *pevent, int cpus)
 {
-	if(pevent)
+	if (pevent)
 		pevent->cpus = cpus;
 }
 
@@ -148,7 +148,7 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus)
  */
 int tep_get_long_size(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->long_size;
 	return 0;
 }
@@ -162,7 +162,7 @@ int tep_get_long_size(struct tep_handle *pevent)
  */
 void tep_set_long_size(struct tep_handle *pevent, int long_size)
 {
-	if(pevent)
+	if (pevent)
 		pevent->long_size = long_size;
 }
 
@@ -175,7 +175,7 @@ void tep_set_long_size(struct tep_handle *pevent, int long_size)
  */
 int tep_get_page_size(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->page_size;
 	return 0;
 }
@@ -189,7 +189,7 @@ int tep_get_page_size(struct tep_handle *pevent)
  */
 void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
-	if(pevent)
+	if (pevent)
 		pevent->page_size = _page_size;
 }
 
@@ -202,7 +202,7 @@ void tep_set_page_size(struct tep_handle *pevent, int _page_size)
  */
 int tep_file_bigendian(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->file_bigendian;
 	return 0;
 }
@@ -216,7 +216,7 @@ int tep_file_bigendian(struct tep_handle *pevent)
  */
 void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 {
-	if(pevent)
+	if (pevent)
 		pevent->file_bigendian = endian;
 }
 
@@ -229,7 +229,7 @@ void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
  */
 int tep_is_host_bigendian(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->host_bigendian;
 	return 0;
 }
@@ -243,7 +243,7 @@ int tep_is_host_bigendian(struct tep_handle *pevent)
  */
 void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 {
-	if(pevent)
+	if (pevent)
 		pevent->host_bigendian = endian;
 }
 
@@ -256,7 +256,7 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
  */
 int tep_is_latency_format(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->latency_format;
 	return 0;
 }
@@ -270,6 +270,6 @@ int tep_is_latency_format(struct tep_handle *pevent)
   */
 void tep_set_latency_format(struct tep_handle *pevent, int lat)
 {
-	if(pevent)
+	if (pevent)
 		pevent->latency_format = lat;
 }
-- 
2.20.1

