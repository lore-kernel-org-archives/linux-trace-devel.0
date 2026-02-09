Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1D219EB
	for <linux-trace-devel@vger.kernel.org>; Mon,  9 Feb 2026 04:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770611739; cv=none; b=UOIZTytevdP3l012Rxpi1znlLi69GDc912fbd/nnQ15NsX57w9UJHoWkL8r+FASO7EFEeWBn3gH+A5rZJH37P0YLeCfxWs8CvSa4nYegpUVlzqWgk32Mc/z9fs6ar7Z84ORNjdjYXGB/nCI3jgtpCuHlOcTmDcYRo0oTbLXHTVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770611739; c=relaxed/simple;
	bh=ApOqhbtIyE7AJDJOsk4U4svu/y7tzpXfQsJ5laKZN/0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rPPWj0/uXRDCQMJ31pVr5DJScCGErFlRjxu5Ytz2BbIZOH6mLBsdsndHhTRvLQNGby4wN+44XOKdOOYhONUIP4ZXT/C5vZwi07VLJdJDMQPJNs0BO4HwT9oO5gNFcQkPdPwIeAPB6JjhKtzOPG5xo2j0N9bRRF27j/ujj8DtVzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ao+aH3PY; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ao+aH3PY"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8244c048d41so1899929b3a.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 08 Feb 2026 20:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770611739; x=1771216539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MG2/MAbCMDjB+93wHcJcfWeHMIpmKSlrwHMq46cieyg=;
        b=ao+aH3PY42JI/VGBxPNVxdf4+AdKGVXI6bhH1Vql/5ttgLPQkmqBkVm4nUKk6QlmmT
         tOQEoV5caq11rOhNMVGE+ZKGCZRoCLfwa5JJ9hUteWYTpq+42F6QgbhXYupFIQZQgM37
         g8IhGHvmgThTWiom+zyVs1H2a1gSDImAF/XGBrIFv3GyuZKnqnqCA3ypKLrDz6Gu+vda
         y+t5tQcCF02ItTZCBkXQoGipYEx3cRuQmfNsQDJzIhV4u4JAjUOjP8GffH6okAxAOfxM
         kNeTLPIv1HFxDOh/tM3nZTG4tzegaGIzVmHep4+T1kGU7RNa9rHT9keszg20XAFlWdVz
         0r5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770611739; x=1771216539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MG2/MAbCMDjB+93wHcJcfWeHMIpmKSlrwHMq46cieyg=;
        b=KoY1kqK1MD8QmmdJkaduwgUAKEctGHTcwEEnr3djrONEOKpfiWgYQJmT91ga+IF15S
         2of9UEz/BoV43MA9McmrkthT1idMO4PyY3dbj7HG63teDFnuxDTyJRTHC9jWd5iv2TpR
         wWEALccvUyGsTWj48ycAxvBOr7Kl/tNx5oSIKmwU/gr4Efj4hNX5Bdmfz5r09M6+15YY
         I/znNNxmsPECgBNKt/fWmVudLDWPLn7j+KW8md2o4pnNFUFhCfHDMKK2A96AD0cujRYx
         Iu7IdHRClBzevRg+XeiU6cAei+sY6QCIEqRTZkTt//hVIWRTxwWM8blQNrVgn/sfqSX9
         vilA==
X-Forwarded-Encrypted: i=1; AJvYcCUTgLop+kQunoINR6BS+PUinLfmvS3D39UysJA9cFhZaBTohT+j9OatoXNPtMX5zG+E+BPpTV9300jlxyja/ZOWJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqxhJo6bksa+Q/lEa3JoYp+FtT8bFQkV9EYFgM2QdFlVNKHXqJ
	aSOkohrKhoxxINvn36C4QoR8wqJPIfKRFuKWWYzN2c8GRPcgYIbPXeJj
X-Gm-Gg: AZuq6aIxxEC+myoCirGvd2/PjXRhZirMg0K+LnVpPiUh1x2dehRVvFdMq2sUrWWC3WC
	txyvB0VuUyptDmTuAauRfHuVHJZWUp3IDGZn6o5npSl0rxYZC8qdPGz0Y9jvw1dejX33KhyLsoF
	+NQdDI4R8Pd4y0zwcusRQS1t6+GgHZWsJfzHziPRnl8gbcgbSPdZMVwkbG+XNMxngfLB3cihjsY
	1TGeQ8sqc4/StKPH8YIJrcSm6H6RBrNo1U3TUBDLb/h4mgt+vR/9n0aJgDtmnmZaxW7taiBtJfr
	WssdLYEJAWUWxR5M++sHIV9Wb7wEDGxPbVL/XSxG5/GJi5kvhknuP/GXK0iYHr3WaUS8F94PVIw
	aevUoXzIe36luCCIrjKVsj80TiCfj8/1xJ1pVgTXfuw82+ODsOG11B1HP3SeQS6J054JDIfycAp
	Vzd5Oh6gnptrp+XgatVuCpfQjm/RY=
X-Received: by 2002:a05:6a00:a885:b0:81f:22ca:257 with SMTP id d2e1a72fcca58-82441629836mr9443992b3a.20.1770611738697;
        Sun, 08 Feb 2026 20:35:38 -0800 (PST)
Received: from pengdl-pc.mioffice.cn ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418b31c2sm9182176b3a.50.2026.02.08.20.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 20:35:37 -0800 (PST)
From: Donglin Peng <dolinux.peng@gmail.com>
To: rostedt@goodmis.org
Cc: mhiramat@kernel.org,
	linux-trace-devel@vger.kernel.org,
	Donglin Peng <pengdonglin@xiaomi.com>
Subject: [PATCH] libtracecmd: Print call offset in parent function for funcgraph-retaddr
Date: Mon,  9 Feb 2026 12:35:30 +0800
Message-Id: <20260209043530.3860119-1-dolinux.peng@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Donglin Peng <pengdonglin@xiaomi.com>

When the "funcgraph-retaddr" option is enabled, trace-cmd currently
prints only the parent function name using the return address.

Enhance it to include the call offset within the parent function,
enabling tools like faddr2line to locate the exact call site.

Before:
  preempt_count_add(val=65536) /* <-irq_enter_rcu */

After:
  preempt_count_add(val=65536) /* <-irq_enter_rcu+0x17 */

Example usage with faddr2line:
  $ ./scripts/faddr2line vmlinux irq_enter_rcu+0x17
  irq_enter_rcu+0x17/0x80:
  irq_enter_rcu at kernel/softirq.c:664

Signed-off-by: Donglin Peng <pengdonglin@xiaomi.com>
---
 lib/trace-cmd/trace-ftrace.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 53c958653c28..069ed51bf3fe 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -237,6 +237,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 	unsigned long long duration, depth;
 	unsigned long long val;
 	unsigned long long retval;
+	unsigned long long offset;
 	bool fgraph_retval_supported = true;
 	const char *retfunc = NULL;
 	const char *func;
@@ -257,8 +258,10 @@ print_graph_entry_leaf(struct trace_seq *s,
 	}
 
 	/* In case this is a retaddr event */
-	if (!tep_get_field_val(s, event, "retaddr", record, &val, 0))
+	if (!tep_get_field_val(s, event, "retaddr", record, &val, 0)) {
 		retfunc = tep_find_function(pevent, val);
+		offset = val - tep_find_function_address(pevent, val);
+	}
 
 	duration = rettime - calltime;
 
@@ -290,7 +293,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
 	if (retfunc)
-		ret = trace_seq_printf(s, " /* <-%s */", retfunc);
+		ret = trace_seq_printf(s, " /* <-%s+0x%x */", retfunc, (int)offset);
 
 	/* Return Value */
 	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
@@ -317,6 +320,7 @@ static int print_graph_nested(struct trace_seq *s,
 	struct tep_handle *pevent = event->tep;
 	unsigned long long depth;
 	unsigned long long val;
+	unsigned long long offset;
 	const char *retfunc = NULL;
 	const char *func;
 	int ret;
@@ -332,8 +336,10 @@ static int print_graph_nested(struct trace_seq *s,
 		return trace_seq_putc(s, '!');
 
 	/* In case this is a retaddr event */
-	if (!tep_get_field_val(s, event, "retaddr", record, &val, 0))
+	if (!tep_get_field_val(s, event, "retaddr", record, &val, 0)) {
 		retfunc = tep_find_function(pevent, val);
+		offset = val - tep_find_function_address(pevent, val);
+	}
 
 	/* Function */
 	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
@@ -344,17 +350,18 @@ static int print_graph_nested(struct trace_seq *s,
 
 	func = tep_find_function(pevent, val);
 
-
 	if (func) {
 		ret = trace_seq_printf(s, "%s(", func);
 		print_args(s, event, record, func);
 		if (retfunc)
-			ret = trace_seq_printf(s, ") /* <-%s */ {", retfunc);
+			ret = trace_seq_printf(s, ") /* <-%s+0x%x */ {", retfunc,
+					       (int)offset);
 		else
 			ret = trace_seq_puts(s, ") {");
 	} else {
 		if (retfunc)
-			ret = trace_seq_printf(s, "%llx() /* <-%s */ {", val, retfunc);
+			ret = trace_seq_printf(s, "%llx() /* <-%s+0x%x */ {", val,
+					       retfunc, (int)offset);
 		else
 			ret = trace_seq_puts(s, ") {");
 	}
-- 
2.34.1

