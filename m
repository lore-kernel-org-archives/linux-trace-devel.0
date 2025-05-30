Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C237230D1E
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 22:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748645677; cv=none; b=EB5NepchAIPUpQhGILkgmt3fI8Z6fpdY9AHBdbq83kG5zo6C/rMSK6PUHzdlfOkXUV/jnT5wSd2cmhjSspILnbT4B+CHc49rTU6NuyofH9l903WbT06Vr7I6GWKlWV+2b52WbzD/EJWUbFP1vK4JQiVN7TdDhdv46S9dZO8elGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748645677; c=relaxed/simple;
	bh=rsS8detZPblqr140gMhtAEHA/mxggBuIJE3s4rhRH7c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BMYpNw4X/RADRGv2mbl2EJjf7RYZVfinYVxlALg7nPCxJZTLW/0e6TxQStDUph3s02EACfo6aYRqwSS63ERJ0kjbhi23pPhFK4nfOFGCKgEYPO8JEqs7ZNtIeB34Jur4nesnF0svMAm5hseuAM1E5xBf6/Uu4esWTu0M5wdmYp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v1aBmWqr; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v1aBmWqr"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2d4e42a2b2bso2227639fac.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 15:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748645675; x=1749250475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TLlfxmmVvtAPwBZ3xAUxS+Xan7Re2iByUzlvOcuYmL0=;
        b=v1aBmWqrvBpSPXxqN1uEhyTdGq4qAhoGZr2nVHBug26tz5DH8MAHH4kobxf/LlikVf
         c64+LCabLJ0uLPc0x+PqIf4iDhijKxMu/ctQoLXbEUBG1WsR3TnzjHKSJnlDkE2P1zid
         xP/3SbIxjzLt+enuOmK0abGCJZiD/mwWANfcGf7C3wR9mc3n2VkCiIIAzuCL91dPKl1r
         gRG3lk8hrgjpEW4JQbE28rvCYqeQFAkXChhs+XLD0ei6q6iERMWoU6X0CU/1CzFSYaiO
         Xtd2aUARxvZEcKJrhIG7Fcn1yGGOC+ksFHcVqwL39+Iw4bmlFLL2iQMjzGtgkmlnoK1I
         0yDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748645675; x=1749250475;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TLlfxmmVvtAPwBZ3xAUxS+Xan7Re2iByUzlvOcuYmL0=;
        b=qoLPV+T233/T/VJ65cawnXTBmOwYYKBVtIVCfLPik+YoloIYFx8HH9AtjmOT9cz1NV
         VazHqUuHR9hTFI2HlPdl/l9ODCp2YA0SDjepB8VTe7R8BM+YVbQDfsXiorpMGfdoZ9B5
         zymuCO1gNdna1FfmJQK6AQF0RckysNhBtetDgQ1DpOh9raP+Yl+yzA3kV7phFka2a1cg
         rZSoXLprdBNTBoatGV9dTYmAgGV614gmZsSkcvGzxJ9Mu0kGYEV4cwhXag4cEjO7dn1R
         WQUahFzDnlZdP2tTEGjPm6yR/pZ+0VaSMo4XEe4CmBJ3a8GrDSh9pMp/Zyun1RpPHBwb
         gw2g==
X-Gm-Message-State: AOJu0Yz5DhNVqxZsl+K1bhqxgn4PGlQHVZKxv5fxQM2iN7IosjkYmZ36
	AxLjSWL0WYug1UKmgMH/rQAvqEWnYU6BNRN5uu3ifYzEXNymPaQA2I7gswWAUu2OGVvDDkSGGC1
	5z0Rzde/+/e1HzWyS9PWGLz8l3DnFJqr4ba+snobOEoCXrgEgmN/FjlBVzfq/8wbgi5TdjCchgB
	j6FQZYJT2v8diXq5e+/7hxyOBUUQMcnR9ouZVbHovrHyVi73REF3qTg/V7
X-Google-Smtp-Source: AGHT+IFq5YLoETx32kDwPcKrvxpvGGpXr0fZnBx0/gIT/+mVKnokOZ6TPPQ8/I+sUYvB4wTlPYjH3+BigOp+
X-Received: from oablk4.prod.google.com ([2002:a05:6870:3e04:b0:289:2c09:4e10])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:9707:b0:2c1:6663:f603
 with SMTP id 586e51a60fabf-2e92a3adfb4mr2167124fac.19.1748645675208; Fri, 30
 May 2025 15:54:35 -0700 (PDT)
Date: Fri, 30 May 2025 15:54:26 -0700
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250530225426.721741-1-irogers@google.com>
Subject: [PATCH v1] libtracefs: Fix enum type in read_event_state
From: Ian Rogers <irogers@google.com>
To: linux-trace-devel@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>, Asmaa AbdelGhany <asmok@google.com>
Content-Type: text/plain; charset="UTF-8"

The state variable is of type event_state but is assigned
TRACEFS_ERROR(-1) of type tracefs_enable_state which has no
corresponding event_state name. Fix this by assigning STATE_ERROR(4).

Reported-by: Asmaa AbdelGhany <asmok@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 5515d15..1576153 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -1459,7 +1459,7 @@ static int read_event_state(struct tracefs_instance *instance, const char *file,
 		*state = STATE_MIXED;
 		break;
 	default:
-		*state = TRACEFS_ERROR;
+		*state = STATE_ERROR;
 		ret = -1;
 		break;
 	}
-- 
2.49.0.1204.g71687c7c1d-goog

