Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8693D968;
	Fri, 10 May 2024 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715367834; cv=none; b=c0nEgWUbjRTqYTxbCJ61guZ/c6tW9BhyABKsHsFG912vYll0ZUitsfasmk87otUcwj9OcEhK7so3yyGnEVZ/sEuQea13jt0dTUCvgniWgQYOgICXPGUXKX8tOPosd5FUwdRbxwt6Hckh9BofBhEzo4+LCisVk9a0NNIegd3QJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715367834; c=relaxed/simple;
	bh=Y4vh2N4jqljg2BMvNoIwwrVvViw9wRY1YxdZzay6vbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UGUdV9cDlhf9FzeK8SOiryUTAErJQn6H3BnP+Czl9t1NlQPtTsYB+sVJvEaV31H4y3x8RIX0FCD7eGigYnVmzhKsm8CxTHjqx+Lnl2++YmiET5g6mrCglYZA/ihc3Hp+OqFta2gK7faWmoDJA4mMldXUx5eQjORalQ+wIjzzppg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQ4n766e; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQ4n766e"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-434c695ec3dso13729981cf.0;
        Fri, 10 May 2024 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715367831; x=1715972631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=RpKObjyoYGAzF55h49XjF90ue0R++WjDXWQv+BTMvTc=;
        b=LQ4n766eK+SK8MFsve2S4CDiE1A01q2aapi7cmshDMIeDdqX9iTKXM/8Vg+IR0PDy4
         EQ8fKdxxZJbbsAqr9HbMay/j/mpRPF0G5MPYP8I0Sfql3cU+drCIzcwpCJIl3YFkZvDL
         MiBaag9f1XvH5lhrhJlbmbNelIUiaT+OZroCwSau5GSfiPAhSYKd6jdhcLtZfotP+9iB
         uQDvjEidUtaIDd1Hcn8gDF2n3Bcr/ri93V9/T6asgeviEPSmDkfmoBIE+5IEMD7R9Xj4
         avK9qyGHNJrApy72tLW3VC1RCY0oaj9R0w/Mn4kzS+HEDyW276Nq5mEMUAQOCTeoBEK/
         +UnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715367831; x=1715972631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpKObjyoYGAzF55h49XjF90ue0R++WjDXWQv+BTMvTc=;
        b=nabrRji2lXwganR/08u105duSL3UxBfyHNzGwgT8E6sA2ibk7J4A89XCNJFDv+VOMO
         P2uvbBvvMNskjgtpaq2CkTJtnH/Df9VfHwAeqXV3KjP3jveNj+L+e+/TX+tMMwY/JwTu
         x229m3VW9KcchrgCLKoacdEJxscFDEb/IJsm/1o2az5ZYQENvJhi2fK8F1EqWVCa40vD
         1vRwOqkfTekUi+2GNr+bWt9/kND+RxlgrNHivyWtPuF8dT2oaokb1T1tWDaVrNQqaXaz
         JVZPh9Ebc9w2+MOrsZPCMw2Yrj3ZZskPoQhvhXjrtx1WJg3eV9hQeZJSmU2ZbhZKvFfr
         Bzbw==
X-Forwarded-Encrypted: i=1; AJvYcCVPho3j1T1N5TyAh8pledcYSVI8yUjg3ZVGIBjJpBU/oORHQEORiK9OTk1GrA+6CDKAqKsxkHXj7bch385DzJOI/3UTaR+3drVpiYNENQBq2+ylPml5nRX53umnJRP16AN3UqpEk+izwaE=
X-Gm-Message-State: AOJu0YxFsWfsTHYy2/qYEHgpz7x+DJCMpTkReoJPHYiea+NQC9i8+Iqk
	NWlZdCWfJTexRkAuJKpQCEL7ZzIYF5uOwLwZk8+35jExhu7zqKoi
X-Google-Smtp-Source: AGHT+IGnp0V9aDjqW2gQ1mmfcrtzBJcGOxcOWJpsBmWOddvm2DRQg8j8lUOoD7prJ1kBNLxYC5+ffg==
X-Received: by 2002:a05:622a:4d1:b0:43a:ea67:fe91 with SMTP id d75a77b69052e-43dfdb7ff7amr30680151cf.52.1715367831535;
        Fri, 10 May 2024 12:03:51 -0700 (PDT)
Received: from localhost.localdomain (bras-base-rdwyon0600w-grc-16-74-12-5-183.dsl.bell.ca. [74.12.5.183])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e069a24basm4962671cf.67.2024.05.10.12.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 12:03:51 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-devel@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org,
	John Kacur <jkacur@redhat.com>
Subject: [PATCH] rtla: Fix reporting when a cpu count is 0
Date: Fri, 10 May 2024 15:03:18 -0400
Message-ID: <20240510190318.44295-1-jkacur@redhat.com>
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
Cc: stable@vger.kernel.org
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

