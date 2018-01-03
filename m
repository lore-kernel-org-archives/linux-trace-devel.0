Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeACRxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:36 -0500
Message-Id: <20180103175335.005689291@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/38] pevent: Simplify pointer print logic and fix %pF
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-pevent-Simplify-pointer-print-logic-and-fix-pF.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When processing %pX in pretty_print(), simplify the logic slightly by
incrementing the ptr to the format string if isalnum(ptr[1]) is true. This
follows the logic a bit more closely to what is in the kernel.

Also, this fixes a small bug where %pF was not giving the offset of the
function.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 event-parse.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/event-parse.c b/event-parse.c
index 7ef66f853b75..2a6b9ffaa4aa 100644
--- a/event-parse.c
+++ b/event-parse.c
@@ -4935,21 +4935,22 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				else
 					ls = 2;
 
-				if (*(ptr+1) == 'F' || *(ptr+1) == 'f' ||
-				    *(ptr+1) == 'S' || *(ptr+1) == 's') {
+				if (isalnum(ptr[1]))
 					ptr++;
+
+				if (*ptr == 'F' || *ptr == 'f' ||
+				    *ptr == 'S' || *ptr == 's') {
 					show_func = *ptr;
-				} else if (*(ptr+1) == 'M' || *(ptr+1) == 'm') {
-					print_mac_arg(s, *(ptr+1), data, size, event, arg);
-					ptr++;
+				} else if (*ptr == 'M' || *ptr == 'm') {
+					print_mac_arg(s, *ptr, data, size, event, arg);
 					arg = arg->next;
 					break;
-				} else if (*(ptr+1) == 'I' || *(ptr+1) == 'i') {
+				} else if (*ptr == 'I' || *ptr == 'i') {
 					int n;
 
-					n = print_ip_arg(s, ptr+1, data, size, event, arg);
+					n = print_ip_arg(s, ptr, data, size, event, arg);
 					if (n > 0) {
-						ptr += n;
+						ptr += n - 1;
 						arg = arg->next;
 						break;
 					}
-- 
2.13.2
