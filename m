Return-Path: <SRS0=psbM=P3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E1EC61CE4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Jan 2019 09:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ABE42086A
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Jan 2019 09:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfASJPz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 19 Jan 2019 04:15:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48456 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfASJPy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 19 Jan 2019 04:15:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gkmjI-0000ru-GQ; Sat, 19 Jan 2019 10:15:52 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] trace-cmd: make python work again
Date:   Sat, 19 Jan 2019 10:15:46 +0100
Message-Id: <20190119091546.20584-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Code reshuffling/renaming wasn't complete in ctracecmd.i:
 * it needs to %include "trace-seq.h" so that we
   can access those functions from python
 * it needs to use tep_* instead of pevent_* everywhere,
   even function calls done as parameters to functions,
   I guess some sort of automatic conversion missed those

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 python/ctracecmd.i | 1 +
 python/tracecmd.py | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index b18cba9b3b5f..55fd8755c237 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -239,4 +239,5 @@ static int python_callback(struct trace_seq *s,
 #define __thread
 
 %include "trace-cmd.h"
+%include "trace-seq.h"
 %include "event-parse.h"
diff --git a/python/tracecmd.py b/python/tracecmd.py
index f551a1489e25..a3816dfdb788 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -106,7 +106,7 @@ class Event(object, DictMixin):
         f = tep_find_any_field(self._format, name)
         if f is None:
             return None
-        ret, val = tep_read_number_field(f, pevent_record_data_get(self._record))
+        ret, val = tep_read_number_field(f, tep_record_data_get(self._record))
         if ret:
             return None
         return val
@@ -142,7 +142,7 @@ class Field(object):
 
     def __long__(self):
         ret, val =  tep_read_number_field(self._field,
-                                             pevent_record_data_get(self._record))
+                                          tep_record_data_get(self._record))
         if ret:
             raise FieldError("Not a number field")
         return val
-- 
2.17.2

