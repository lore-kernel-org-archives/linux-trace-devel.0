Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF06E1DFEF;
	Thu, 16 May 2024 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715869914; cv=none; b=OF3RsVEhTz0R+ndvfqS/gkPwHfnh5P2i7rCTg4bFiFk5bhMsHdcdOLEj2iCGH2Qp9WVWvhsjAgzlgS8NXkJsXuDVm5J6vLJbywXnbLrrxynQvPFsPb2y8rVWKMmGqXY/g3u9fG5W1e+Qf/uI+QEXrFTQIxoxecwWJAH7pvCgizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715869914; c=relaxed/simple;
	bh=jvVZGA7H6sXu3GiSe16GVX2mz0miO0wNsG/zgxGgUXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bNaeqaeOkGN3sEGkqqir/WEm1NiIA/VGe5uxo73DjRezYTxMxE9my5j5MJvin3X0gxUcPPupzSaRP/HS0cG2z7B1Gk4FDHF/wfcbdj6aV6xkNcGCmfpdQgBtk3RlvI9oIQ4YioDCvh9muRUseJ5Tgs7dD6bz6DBcuPK3SumJUMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kqdSUwAg; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqdSUwAg"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-792ecce9522so232078285a.3;
        Thu, 16 May 2024 07:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715869912; x=1716474712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+xAdIky7gTlt0M0dTTgGjPHLt66lkGoZNqYYkbXl8cs=;
        b=kqdSUwAg0yHwTPIbsPMJEZ6FWkLf8b2s4vsKexKmcsZbC58Q3zKFZBvjI2BUcvyMf4
         suqAgPgJ/8Aiz+8nNzqeZ6FRC7oMzcx+81BB+oIBUaqvEq/nXGY2rN9JZ1q7NRqcvxNg
         IfVrOb42ZtqiOH9NSjtBaxBbUhrR2ySHZ/8Mh9ku7pavbLXAHPqNf+AtRywOL7WrEs/t
         oby0cMqV6zkITRFBHUv/gh6fiOfk7peHOQB7tMsJXYAZi1z5Te2RdekIPFy9FGlLUiQl
         eQbYJwRWwNUD340U1pgy8N0XzdbexFYiRt6dkdPUMqJGRCfv4TLmarI3ABT/lAQbekxA
         RAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715869912; x=1716474712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xAdIky7gTlt0M0dTTgGjPHLt66lkGoZNqYYkbXl8cs=;
        b=Tp5kAJwW8n6lUGxaN5GqGDQCcGeUSSaHakmR0NONTUt1aOCf9IbtvmlMOUadgyXBvf
         0hnm1Q/wC7iRIoZyK/wdU2ma4lOrxn6p/LW1Vu7f5fsf5ih3W6ZEAs6BMiNqGkOLJULt
         ONc0oCxUKJsaf4MXBpvWkQMd7NeZwm1qG73HJsPfd+7fMbtT244Wgagv7CyYNyJzVgg5
         PRmGeCIU1DKJjhOmEodUdP3YQZ44/0II73w4LXYIa8Ln9o5+e7jDTPZJjHaO/kVq3T++
         rszFEE/aBYDORKY5Ro02CGwT4A4JeDs4zM9Bg6FSxWSgNlrLKIeufZBL3Rlhaw5r29Tf
         IKfA==
X-Forwarded-Encrypted: i=1; AJvYcCWSPUWx1ZoN26LoLeQdGCjjQ3CYY+57JiNnPEvUlFNFYh3AWMINfMIEtroCNB+w7NurSsptZfjNSrfhRs7wTPKzKcafL0KpBxx+V0JA0fAh/8/AGu+pKNFw6/QlopA/nyxSboipaUVbT0HxLzGt1+k=
X-Gm-Message-State: AOJu0YxoD8UinhMYEnamRlbroe5ILjeePqQuot2mX3sMO+Xrd52n56mg
	BZ/0HQ48casdg5j4ODpZwB08lnD27mKcojNL0aREuWkIoru7ZKy1tzbOFQ==
X-Google-Smtp-Source: AGHT+IFzmonKwgepST6WyWPL0BazVe+U6iDIRko7b1gg0vXhnjw6vch4RiMtLecA3c0k5ZNBKzbDtw==
X-Received: by 2002:a05:6214:5b0a:b0:6a0:e2ca:1e69 with SMTP id 6a1803df08f44-6a16822ae19mr195740416d6.29.1715869911635;
        Thu, 16 May 2024 07:31:51 -0700 (PDT)
Received: from fionn.redhat.com (bras-base-rdwyon0600w-grc-16-74-12-5-183.dsl.bell.ca. [74.12.5.183])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f194945sm75260906d6.61.2024.05.16.07.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 07:31:51 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-trace-devel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH v4] rtla: Documentation: Fix -t, --trace
Date: Thu, 16 May 2024 10:31:21 -0400
Message-ID: <20240516143121.12614-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move -t, --trace from common_options.rst to
common_osnoise_options.rst and
common_timerlat_options.rst

so that it will appear in the man pages

rtla-timerlat-hist.1
rtla-timerlat-top.1
rtla-osnoise-hist.1
rtla-osnoise-top.1

Remove the equals ('=') sign and add a space.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Documentation/tools/rtla/common_options.rst          | 4 ----
 Documentation/tools/rtla/common_osnoise_options.rst  | 4 ++++
 Documentation/tools/rtla/common_timerlat_options.rst | 4 ++++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/tools/rtla/common_options.rst b/Documentation/tools/rtla/common_options.rst
index 7ac7b7581466..2dc1575210aa 100644
--- a/Documentation/tools/rtla/common_options.rst
+++ b/Documentation/tools/rtla/common_options.rst
@@ -14,10 +14,6 @@
 
         Print debug info.
 
-**-t**, **--trace**\[*=file*]
-
-        Save the stopped trace to [*file|osnoise_trace.txt*].
-
 **-e**, **--event** *sys:event*
 
         Enable an event in the trace (**-t**) session. The argument can be a specific event, e.g., **-e** *sched:sched_switch*, or all events of a system group, e.g., **-e** *sched*. Multiple **-e** are allowed. It is only active when **-t** or **-a** are set.
diff --git a/Documentation/tools/rtla/common_osnoise_options.rst b/Documentation/tools/rtla/common_osnoise_options.rst
index f792ca58c211..d73de2d58f5f 100644
--- a/Documentation/tools/rtla/common_osnoise_options.rst
+++ b/Documentation/tools/rtla/common_osnoise_options.rst
@@ -25,3 +25,7 @@
 
         Specify the minimum delta between two time reads to be considered noise.
         The default threshold is *5 us*.
+
+**-t**, **--trace** \[*file*]
+
+        Save the stopped trace to [*file|osnoise_trace.txt*].
diff --git a/Documentation/tools/rtla/common_timerlat_options.rst b/Documentation/tools/rtla/common_timerlat_options.rst
index 090700a6ae9f..cef6651f1435 100644
--- a/Documentation/tools/rtla/common_timerlat_options.rst
+++ b/Documentation/tools/rtla/common_timerlat_options.rst
@@ -22,6 +22,10 @@
         Save the stack trace at the *IRQ* if a *Thread* latency is higher than the
         argument in us.
 
+**-t**, **--trace** \[*file*]
+
+        Save the stopped trace to [*file|timerlat_trace.txt*].
+
 **--dma-latency** *us*
         Set the /dev/cpu_dma_latency to *us*, aiming to bound exit from idle latencies.
         *cyclictest* sets this value to *0* by default, use **--dma-latency** *0* to have
-- 
2.44.0

