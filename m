Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbeACRxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:36 -0500
Message-Id: <20180103175335.152275812@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/38] pevent: Handle new pointer processing of bprint strings
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-pevent-Handle-new-pointer-processing-of-bprint-strin.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The Linux kernel printf() has some extended use cases that dereference the
pointer. This is dangerouse for tracing because the pointer that is
dereferenced can change or even be unmapped. It also causes issues when the
trace data is extracted, because user space does not have access to the
contents of the pointer even if it still exists.

To handle this, the kernel was updated to process these dereferenced
pointers at the time they are recorded, and not post processed. Now they
exist in the tracing buffer, and no dereference is needed at the time of
reading the trace.

The event parsing library needs to handle this new case.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 event-parse.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/event-parse.c b/event-parse.c
index 2a6b9ffaa4aa..bd288c184d20 100644
--- a/event-parse.c
+++ b/event-parse.c
@@ -4279,6 +4279,26 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				goto process_again;
 			case 'p':
 				ls = 1;
+				if (isalnum(ptr[1])) {
+					ptr++;
+					/* Check for special pointers */
+					switch (*ptr) {
+					case 's':
+					case 'S':
+					case 'f':
+					case 'F':
+						break;
+					default:
+						/*
+						 * Older kernels do not process
+						 * dereferenced pointers.
+						 * Only process if the pointer
+						 * value is a printable.
+						 */
+						if (isprint(*(char *)bptr))
+							goto process_string;
+					}
+				}
 				/* fall through */
 			case 'd':
 			case 'u':
@@ -4331,6 +4351,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 
 				break;
 			case 's':
+ process_string:
 				arg = alloc_arg();
 				if (!arg) {
 					do_warning_event(event, "%s(%d): not enough memory!",
@@ -4938,6 +4959,11 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				if (isalnum(ptr[1]))
 					ptr++;
 
+				if (arg->type == PRINT_BSTRING) {
+					trace_seq_puts(s, arg->string.string);
+					break;
+				}
+
 				if (*ptr == 'F' || *ptr == 'f' ||
 				    *ptr == 'S' || *ptr == 's') {
 					show_func = *ptr;
-- 
2.13.2
