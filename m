Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB1348C46
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780080806; cv=none; b=XLlxGawDI933vufzDjWkeZNBimdWc8Ptypzj1HdknUB0KbC6lfHo0ANZWDSn6ksF9lMwd9TLknv/9woG4ifAxG264XtHDG9kGxtXUFupSTpB3SIxQTM7V73E3hClaxkCvZ9QXGL9B9j+vsG5mTD3b+ZN7wgRdXlhdrIpIDPoNfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780080806; c=relaxed/simple;
	bh=y+gHs41H2Euse8Q7t8tkAHTb7UPTMVnFrzHnLE+1i3Y=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=JfKK3BileOE2GMWU5K1GVTGqM33TZtDOo+q17rtNTxN8k+70KHZiJE+1W5l62UvDq1ONeQW/n4uWWJB71an5yvW/4iJugumVfYd9glRQg5OfwQpGZTq9MyUsPO9BfUdFRlRAPL3nhjNizlKwiEfypA8AKvY+DXKPQmOiSr+ArL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 340E440265
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:53:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id F28D520024
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:53:20 +0000 (UTC)
Date: Fri, 29 May 2026 14:53:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceveent: Add printable characters
Message-ID: <20260529145319.49b0acd4@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9xaozq5os1upb44o9nq8whqwb8uuxszz
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: F28D520024
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/s5QVTulhIkSGcUUYxeqylrvVgLWolzlc=
X-HE-Tag: 1780080800-29848
X-HE-Meta: U2FsdGVkX1+ZrnnG6cPTrKPHPrTtD+Kp31uQFuFxWy1wmRdb1vKltZjLKqjBZq9f9HMdgBBq/Dt1tdWHLyvNmGELgAmsJ5wIlM6VeW/eD0IwB62+mv9GkTz/IPtpDT07mptFi7GyC0yxHAxatZmQhSlxQL6CJ6yH7XO/sAG00JMvjm74/7FKZlNfxqSXisEw1XlgsrkKZGyj5YMBu8yyULgY3zdEuAgn02OdrrzLfu9gHzVxwHOhtAjoTFrPXAxezbo8AVbXA/6aiAsz0nUTNta3M/76Vgt9CCiv1LCZQaB/asIb1V2z60JNS5IGt+b223tcD6l73dU0Q8yUmeCf/cRG6oTuuu/6TaDdPmmNzd7b7Oaras9prHq/ajBSfcbo

From: Steven Rostedt <rostedt@goodmis.org>

If an array of characters are all printable, print the string it represents.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/event-parse.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 0427e29..4ba2686 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5416,6 +5416,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_INT_ARRAY: {
 		void *num;
 		int el_size;
+		int is_print = 0;
 
 		len = 0;
 
@@ -5450,7 +5451,20 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 				trace_seq_putc(s, ',');
 
 			if (el_size == 1) {
-				trace_seq_printf(s, "0x%x", *(uint8_t *)num);
+				int ch = *(uint8_t *)num;
+
+				trace_seq_printf(s, "0x%x", ch);
+
+				if (!is_print)
+					is_print = 1;
+
+				/*
+				 * Only print string if all characters are
+				 * printable
+				 */
+				if (is_print && !isprint(ch) && !isspace(ch))
+					is_print = -1;
+
 			} else if (el_size == 2) {
 				trace_seq_printf(s, "0x%x", *(uint16_t *)num);
 			} else if (el_size == 4) {
@@ -5466,6 +5480,19 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			num += el_size;
 		}
 		trace_seq_putc(s, '}');
+
+		if (is_print == 1) {
+			char *p = data + offset;
+
+			trace_seq_puts(s, " \"");
+			for (i = 0; i < len; i++) {
+				if (p[i] == '\n')
+					trace_seq_puts(s, "\\n");
+				else
+					trace_seq_putc(s, p[i]);
+			}
+			trace_seq_putc(s, '"');
+		}
 		break;
 	}
 	case TEP_PRINT_TYPE:
-- 
2.51.0

