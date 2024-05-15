Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F11F54654;
	Wed, 15 May 2024 18:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715797847; cv=none; b=QJ7G6Yey47EeJVGUKol/x0rH8I4RmJSPG1CB55s5/VL/MYCUiEngw2S/pN/R01aUJPcJPYxZHRlViJlaslpBNCzviUYvdm3ImGrSWHSN4486kOH6Ae8dnmW+KFbr5KvS99XNbCQiIqjfZZWYXKbLhghA4/QG3dFfgJQ91bPb9EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715797847; c=relaxed/simple;
	bh=zPphWFwqaOTWGFAzeLRXiv8kIODySpaDn5j45el3tt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwglUoskyTvEcDeobNvkjR8KVtousY3WYCPsgrsi8W9Neb7WhGSv8m2YtOsw0j0KuVpgo5h8qpvdMoCJpH6vrTO5fxGLrbt4/xG4IdjPAvfQuTQrOnTy8Q5vMnIcF1xMn3kuIJ1LkAHpVZvspdBYV2RJbbPa/lgNYeMrVDoy650=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fs5EHQGs; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fs5EHQGs"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c9b94951d5so1032124b6e.3;
        Wed, 15 May 2024 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715797844; x=1716402644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3fZRWZsu8lHo34cetgWPq75hTHkyfAQuDiVipVSsT0=;
        b=fs5EHQGsXXyOvUV8SypDAijx6eFaAWnziYXMgU40pBf//AxtHFNuuxUBM2MnuQ2BeK
         1V1cEceOl+g+9pd1cFYUClsw/SGwcTfWo04h6zVZeRXAAg0jKZskRTLaajBAe+DtZHr2
         i2N8md024WFgRXwSM5EOijpe9i8Yt/GwpT8XwCGoSrLG1v+shBDcjqRrcQi2VWXyMZJ7
         XSw0iVDuHQLokF1NsBrYiIfxfF8d+nWifENg9yoVTlbDQLnINW9nds+BbPSYLfX+iM1c
         HPZ9JRB+oD+0yFolLHo7ajwysSNJa6Aw8XgtiEv8qGY0KfiTb6vVXWo3tZj0rj8/UnQd
         XN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715797844; x=1716402644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M3fZRWZsu8lHo34cetgWPq75hTHkyfAQuDiVipVSsT0=;
        b=uH+iUpDFrqZ2PrhznABe4Ehuyp7LNOQvKziue6h9v70u1TXuZPcMEn0844UEYnOAgh
         zfFD0GAcERoGtckWWbiIsGfQKElHs5CEo01WjiVR7qKB+lfPPqNzK/PKcgH8PGJrQR/f
         j+wzKgfhd0LGFnKw4AexZ1Fx0pHsa4XtEP5X8dGfmSm5/A9apnFmv2XXs13A8431/fx+
         ykdOius+0bL8VZ533V8umEWOAbGdmkuBZ0TXxUfXPJO0oRDN9/Rhg/2T5CqlaEFpfVT2
         HCkp+Ri06vwnZDQZfzKQycaTXuO9/ggjqD6Mp7dRRKc7O78QUeJoGrof2aens6soHQMY
         Iw/A==
X-Forwarded-Encrypted: i=1; AJvYcCWwrQghLq2nu/KNuUgqSjkjC2saV3M5/CgAAIs/TLcstsSnK5QK2ZGNf5UTGJtn4q8WKr5p4Os6S4zYlFNFAurh0sreWkjplvd/Q5QQjIsug6wGUGdmPzrgiLJhl0F/CWHRZDy0LeMwKw2GW2egyBs=
X-Gm-Message-State: AOJu0YynNMvS4x8yIj9vRm12OzXRbTnaJVj/UTxMOxL2PVucOw2fE3bJ
	0P+naf5K8EwfvUq+YuiJw3Hklbl0ra6b3JA2zjJCg5CNI0d/jrar
X-Google-Smtp-Source: AGHT+IFLLZodY9LgbwTN2BxPcRs1Kw01JxOK0LCD1TpFFbWHiroVI32ShR+CCM9J4fytt6jF+6uNjw==
X-Received: by 2002:a05:6870:b296:b0:240:7904:f5b6 with SMTP id 586e51a60fabf-24172bd0727mr17765866fac.28.1715797844453;
        Wed, 15 May 2024 11:30:44 -0700 (PDT)
Received: from fionn.redhat.com ([74.12.5.183])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e25f3ec65sm28965351cf.81.2024.05.15.11.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 11:30:43 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-trace-devel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH v3 2/2] rtla: Documentation: Fix -t, --trace
Date: Wed, 15 May 2024 14:30:24 -0400
Message-ID: <20240515183024.59985-2-jkacur@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515183024.59985-1-jkacur@redhat.com>
References: <20240515183024.59985-1-jkacur@redhat.com>
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
index 090700a6ae9f..b12f232f7499 100644
--- a/Documentation/tools/rtla/common_timerlat_options.rst
+++ b/Documentation/tools/rtla/common_timerlat_options.rst
@@ -22,6 +22,10 @@
         Save the stack trace at the *IRQ* if a *Thread* latency is higher than the
         argument in us.
 
+**-t**, **--trace** \[*file*]
+
+        Save the stopped trace to [*file|osnoise_trace.txt*].
+
 **--dma-latency** *us*
         Set the /dev/cpu_dma_latency to *us*, aiming to bound exit from idle latencies.
         *cyclictest* sets this value to *0* by default, use **--dma-latency** *0* to have
-- 
2.44.0

