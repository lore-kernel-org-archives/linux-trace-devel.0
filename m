Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590B13A87A
	for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2024 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724706031; cv=none; b=V8DlFq5P2I/Hz2ctADW06s6+RASMvi1kLqfvL9+Aza+VavUdMCL8dJTXvjMqQvC44Plzk1zQuZC/efk1rG14wX8EbNKVyrlm/NLotVGDGVYMB0jEaXkl+WHNlgSkQNPGwHtojh909EknOSQYOzuR+SwpSZs10sBwm3v1nU2OPuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724706031; c=relaxed/simple;
	bh=aNArwg0i7BMQo7sWrLwk8YTLuIwIf32+siNnpUJOmmg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eROTwTng3AC/j1dU6wE8Pvwzh9WAtpjLYGJbLDaDwvnMUKV2fLaOVr8OzlRSwc12F/0p3fj20eC9e3J9/NpbJmbJEaveYkVAKyNQcoc7xei63j01J2GsKNDr33I9LgUjCjB8LGn1nbNloEeC9ydtlsUkVgUVkFZ7vU7+NhtgZ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VhdT9qkG; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VhdT9qkG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724706026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IGkQTE1/lvEMZESIuo9WQv8dqR158xiFv4bt2+zj96I=;
	b=VhdT9qkGQKKnWoNj2ZMU1rtohDJ++l/R1TEB2ruy/mzW5eetfrWTlUhV+MCNy7hGNMbW2H
	1alv0eA+Xw7HN5qV4X+vD4f42lc27w8zOE6dp2auqq6p5l6J3JIHUoPlDomE6XQxAhOO1u
	UyiH+8w8UPfRomZ86QpNHSkZbhu1vqI=
From: Sean Anderson <sean.anderson@linux.dev>
To: linux-trace-devel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Sean Anderson <sean.anderson@linux.dev>
Subject: [PATCH] Print arrays like Linux does
Date: Mon, 26 Aug 2024 17:00:22 -0400
Message-Id: <20240826210022.2251838-1-sean.anderson@linux.dev>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In Linux, trace_print_array_seq prints array elements as hexadecimal
numbers, separates them with commas, and surrounds the whole thing with
curly braces. Modify print_str_arg to use the same formatting.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
---

 src/event-parse.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index ba4a153..3c6f6f2 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4938,18 +4938,19 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		len = eval_num_arg(data, size, event, arg->int_array.count);
 		el_size = eval_num_arg(data, size, event,
 				       arg->int_array.el_size);
+		trace_seq_putc(s, '{');
 		for (i = 0; i < len; i++) {
 			if (i)
-				trace_seq_putc(s, ' ');
+				trace_seq_putc(s, ',');
 
 			if (el_size == 1) {
-				trace_seq_printf(s, "%u", *(uint8_t *)num);
+				trace_seq_printf(s, "0x%x", *(uint8_t *)num);
 			} else if (el_size == 2) {
-				trace_seq_printf(s, "%u", *(uint16_t *)num);
+				trace_seq_printf(s, "0x%x", *(uint16_t *)num);
 			} else if (el_size == 4) {
-				trace_seq_printf(s, "%u", *(uint32_t *)num);
+				trace_seq_printf(s, "0x%x", *(uint32_t *)num);
 			} else if (el_size == 8) {
-				trace_seq_printf(s, "%"PRIu64, *(uint64_t *)num);
+				trace_seq_printf(s, "0x%"PRIx64, *(uint64_t *)num);
 			} else {
 				trace_seq_printf(s, "BAD SIZE:%d 0x%x",
 						 el_size, *(uint8_t *)num);
@@ -4958,6 +4959,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 
 			num += el_size;
 		}
+		trace_seq_putc(s, '}');
 		break;
 	}
 	case TEP_PRINT_TYPE:
-- 
2.35.1.1320.gc452695387.dirty

