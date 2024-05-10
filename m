Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614E17556D;
	Fri, 10 May 2024 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715358401; cv=none; b=J4Bd9ggDvIp51+YWVRq+/2HbnSph0tRURB7wwBdogU34Jliff85zIBgo28fLbFVht0J3JODla9DF/+ypEZ5mk7jOHp+ddszApFZuz8j4Oq9o3LgdWQAxB65gPkU3xB6FNkiiF7G+7LLvtUa1Z9RMiPBD0g8iD/dbSKzo0GPVTvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715358401; c=relaxed/simple;
	bh=oonXHbg2KhBW9RZ+Rvo2vSdZHQiB0Wn1HguIuEl89Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T9zb8PK5gBDrINAvwPc0ou0w1puHaQd36bMC8sRNBAsNksIZsQkAJ4vb5kmRt0Cm4yhk4Yl/3FxZBsmnQVhK0ljqpOb7Qk7N/kKGNbxpQ6xldi0y2WiRSNGGQAOpTM5z2sQL/hZg68ztZcGjlv/OT/nuRj6uBbDzHLLrvH2hi4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RaE2QnwU; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RaE2QnwU"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-792b934de39so174301685a.3;
        Fri, 10 May 2024 09:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715358399; x=1715963199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Rz28DuNSZQjFl8RAwmtdo8KD28yac4guG+V7e+ZRJ4s=;
        b=RaE2QnwUSnNe5kBSJRUTQEbVdQd79wlLOkfPFKLk3jl+Z0wigNlBgITT9W0Mkp4SCE
         KVId5z/RoyUfaZ6ynFSdQEhr2wwjmaudHLvXJ5uG1HD5zRHNelDddxFrVgDHB9pymW+I
         nl9KogyTkGz5o4FZPgrg1VDamlge/A9icGblYVc6WEMTrgJ1SUeUBFzKwKtV8sPLzXm4
         ioU8HaTMk8VFHWxjUGnQAmf9Vscxyv+zz9ovT++b426CtT60KHrddmj6RIW/5+QJPxgA
         WF78NGk2d9tjX7iPXrc73mXYhrKyA2MY8zM+Nvz2p0dtF2Z/oMQLjBpPr3ccfyEXosPd
         mpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715358399; x=1715963199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rz28DuNSZQjFl8RAwmtdo8KD28yac4guG+V7e+ZRJ4s=;
        b=tpeGZedWrKmUs/6C2yq6/ISmwNAZXt/eYMjVVCaHhRTeBf5Cqu9lEzD3UXjZUhpLAR
         ltfWpD0YZln2ZGq+ktm1cXdQa25/Z6Y2FboorkgNZuQnoc5j5k6McFA9S4BgBsOdylnZ
         ORyJApqJA9h72A+9Yy+dY2O0YSh339ultlyKv15lJgmW+SmvdLqwzDKbZNSZCTWxroh6
         O4UsUSI4kYvdPExm6JT6wmLWZjRa/2UGzkJ6/VDy3y0TBqvrtVEHZu9bWs1L7TI8aon6
         hKwjGVKx5t3N3r9bR7qQvM+aKVOeQ56NHYBFuGSpcuRcdsgdbHvFXhJU0+MRoDRpOSO/
         /0RQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLtWZFCv6r53pt3xTFN3FCXmNWuheskWybMR+Mr5szKmHBQ+pA99Uv8Jk0KoN6g7+uncsH4VCGxbzTOVGX9sQfOdzY5lNfAe87gSY8J4Wmy5N5ho5Nw4XhTezSYB1auaAl5Vl0N7XmsYw=
X-Gm-Message-State: AOJu0YykBZRfhFL5pEhgKUKejwrXZFli9hY96QDSUSis5g0lHz/2ysp9
	3gLR2W3D3fMfJB2LPH/1TlOuVcjdvZabMr57Z27rmEHx+C29qs3Fijerjg==
X-Google-Smtp-Source: AGHT+IFeJTPzixcTATWsrxoXajVTKdM3YJfH2cngx4/IBf6scasq3GLmbYBrpTEio3usBbWVItGNVg==
X-Received: by 2002:a05:620a:e88:b0:790:c7f6:595f with SMTP id af79cd13be357-792c7574885mr297066285a.12.1715358399065;
        Fri, 10 May 2024 09:26:39 -0700 (PDT)
Received: from localhost.localdomain (bras-base-rdwyon0600w-grc-16-74-12-5-183.dsl.bell.ca. [74.12.5.183])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf275b07sm194853985a.24.2024.05.10.09.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 09:26:38 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-devel@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org,
	John Kacur <jkacur@redhat.com>
Subject: [PATCH] Fix reporting when a cpu count is 0
Date: Fri, 10 May 2024 12:26:05 -0400
Message-ID: <20240510162605.28050-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On short runs it is possible to get no samples on a cpu, like this

rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50'

Index   IRQ-001   Thr-001   Usr-001   IRQ-002   Thr-002   Usr-002
2             1         0         0         0         0         0
33            0         1         0         0         0         0
36            0         0         1         0         0         0
49            0         0         0         1         0         0
52            0         0         0         0         1         0
over:         0         0         0         0         0         0
count:        1         1         1         1         1         0
min:          2        33        36        49        52 18446744073709551615
avg:          2        33        36        49        52         -
max:          2        33        36        49        52         0
rtla timerlat hit stop tracing
  IRQ handler delay:		(exit from idle)	    48.21 us (91.09 %)
  IRQ latency:						    49.11 us
  Timerlat IRQ duration:				     2.17 us (4.09 %)
  Blocking thread:					     1.01 us (1.90 %)
	               swapper/2:0        		     1.01 us
------------------------------------------------------------------------
  Thread latency:					    52.93 us (100%)Max timerlat IRQ latency from idle: 49.11 us in cpu 2

Note, the value 18446744073709551615 is the same as ~0
Fix this by reporting no results for the min, avg and max if the count
is 0

This solution came from Daniel Bristot de Oliveria <bristot@kernel.org>

Fixes: 1eeb6328e8b3 ("rtla/timerlat: Add timerlat hist mode")
Tested-by: John Kacur <jkacur@redhat.com>
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/tracing/rtla/src/timerlat_hist.c | 60 ++++++++++++++++++--------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 8bd51aab6513..5b869caed10d 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -324,17 +324,29 @@ timerlat_print_summary(struct timerlat_hist_params *params,
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].min_irq);
+		if (!params->no_irq) {
+			if (data->hist[cpu].irq_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].min_irq);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 
-		if (!params->no_thread)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].min_thread);
+		if (!params->no_thread) {
+			if (data->hist[cpu].thread_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].min_thread);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 
-		if (params->user_hist)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].min_user);
+		if (params->user_hist) {
+			if (data->hist[cpu].user_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].min_user);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 	}
 	trace_seq_printf(trace->seq, "\n");
 
@@ -384,17 +396,29 @@ timerlat_print_summary(struct timerlat_hist_params *params,
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].max_irq);
+		if (!params->no_irq) {
+			if (data->hist[cpu].irq_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						 data->hist[cpu].max_irq);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 
-		if (!params->no_thread)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].max_thread);
+		if (!params->no_thread) {
+			if (data->hist[cpu].thread_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].max_thread);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 
-		if (params->user_hist)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].max_user);
+		if (params->user_hist) {
+			if (data->hist[cpu].user_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].max_user);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 	}
 	trace_seq_printf(trace->seq, "\n");
 	trace_seq_do_printf(trace->seq);
-- 
2.44.0

