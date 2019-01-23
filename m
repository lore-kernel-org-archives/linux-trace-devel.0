Return-Path: <SRS0=ycWA=P7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17642C282C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jan 2019 13:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11D421848
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jan 2019 13:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfAWN0d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:26:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59856 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfAWN0d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jan 2019 08:26:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmIY3-0002BE-1D; Wed, 23 Jan 2019 14:26:31 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] trace-cmd: make python work again
Date:   Wed, 23 Jan 2019 14:26:27 +0100
Message-Id: <20190123132627.7619-1-johannes@sipsolutions.net>
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
 python/ctracecmd.i     | 1 +
 python/event-viewer.py | 4 ++--
 python/tracecmd.py     | 8 ++++----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index b18cba9b3b5f..55fd8755c237 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -239,4 +239,5 @@ static int python_callback(struct trace_seq *s,
 #define __thread
 
 %include "trace-cmd.h"
+%include "trace-seq.h"
 %include "event-parse.h"
diff --git a/python/event-viewer.py b/python/event-viewer.py
index 3a082b81fc3d..c7c50d16df14 100755
--- a/python/event-viewer.py
+++ b/python/event-viewer.py
@@ -68,8 +68,8 @@ class EventStore(gtk.GenericTreeModel):
         for cpu in range(0, trace.cpus):
             rec = tracecmd_read_data(self.trace._handle, cpu)
             while rec:
-                offset = pevent_record_offset_get(rec)
-                ts = pevent_record_ts_get(rec)
+                offset = tep_record_offset_get(rec)
+                ts = tep_record_ts_get(rec)
                 self.refs.append(self.EventRef(index, ts, offset, cpu))
                 index = index + 1
                 rec = tracecmd_read_data(self.trace._handle, cpu)
diff --git a/python/tracecmd.py b/python/tracecmd.py
index f551a1489e25..f4f241e22580 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -84,7 +84,7 @@ class Event(object, DictMixin):
 
     @cached_property
     def cpu(self):
-        return pevent_record_cpu_get(self._record)
+        return tep_record_cpu_get(self._record)
 
     @cached_property
     def name(self):
@@ -96,7 +96,7 @@ class Event(object, DictMixin):
 
     @cached_property
     def ts(self):
-        return pevent_record_ts_get(self._record)
+        return tep_record_ts_get(self._record)
 
     @cached_property
     def type(self):
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

