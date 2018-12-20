Return-Path: <SRS0=0Hq+=O5=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54922 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731829AbeLTPuL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Dec 2018 10:50:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so2538657wmh.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Dec 2018 07:50:08 -0800 (PST)
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: improve the accuracy of date to ts mapping
Date: Thu, 20 Dec 2018 17:50:04 +0200
Message-Id: <20181220155004.5457-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch modifies the get_date_to_ts() function to
achieve more accuracy in date to log's time stamp mappings

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e45a1f8..0b58884 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <getopt.h>
+#include <time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/time.h>
@@ -96,7 +97,7 @@ static int fset;
 static unsigned recorder_flags;
 
 /* Try a few times to get an accurate date */
-static int date2ts_tries = 5;
+static int date2ts_tries = 50;
 
 static struct func_list *graph_funcs;
 
@@ -3495,8 +3496,8 @@ static char *get_date_to_ts(void)
 	unsigned long long min_ts;
 	unsigned long long ts;
 	struct tep_handle *pevent;
-	struct timeval start;
-	struct timeval end;
+	struct timespec start;
+	struct timespec end;
 	char *date2ts = NULL;
 	char *path;
 	char *buf;
@@ -3546,20 +3547,20 @@ static char *get_date_to_ts(void)
 		clear_trace_instances();
 		tracecmd_enable_tracing();
 
-		gettimeofday(&start, NULL);
+		clock_gettime(CLOCK_REALTIME, &start);
 		write(tfd, STAMP, 5);
-		gettimeofday(&end, NULL);
+		clock_gettime(CLOCK_REALTIME, &end);
 
 		tracecmd_disable_tracing();
 		ts = find_time_stamp(pevent);
 		if (!ts)
 			continue;
 
-		diff = (unsigned long long)end.tv_sec * 1000000;
-		diff += (unsigned long long)end.tv_usec;
+		diff = (unsigned long long)end.tv_sec * 1000000000LL;
+		diff += (unsigned long long)end.tv_nsec;
 		stamp = diff;
-		diff -= (unsigned long long)start.tv_sec * 1000000;
-		diff -= (unsigned long long)start.tv_usec;
+		diff -= (unsigned long long)start.tv_sec * 1000000000LL;
+		diff -= (unsigned long long)start.tv_nsec;
 
 		if (diff < min) {
 			min_ts = ts;
@@ -3584,7 +3585,8 @@ static char *get_date_to_ts(void)
 	 * The difference between the timestamp and the gtod is
 	 * stored as an ASCII string in hex.
 	 */
-	snprintf(date2ts, 19, "0x%llx", min_stamp - min_ts / 1000);
+	diff = min_stamp - min_ts;
+	snprintf(date2ts, 19, "0x%llx", diff/1000);
 
  out_pevent:
 	tep_free(pevent);
-- 
2.19.2
